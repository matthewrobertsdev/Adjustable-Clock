//
//  ColorsMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 7/5/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Cocoa
class ColorsMenuController: NSObject {
    var colorsMenu: NSMenu?
	let nsColorPanel=NSColorPanel.shared
	let notificationCenter=NotificationCenter.default
	static var dark=false
    init(colorsMenu: NSMenu) {
		super.init()
        self.colorsMenu=colorsMenu
        makeColorMenuUI()
        //reflect saved (or default) choice
        updateColorMenuUI()
		notificationCenter.addObserver(self, selector:
			#selector(handleChangeToDarkMode), name: NSNotification.Name.didChangToDarkMode, object: nil)
		notificationCenter.addObserver(self, selector:
			#selector(handleChangeToLightMode), name: NSNotification.Name.didChangToLightMode, object: nil)
    }
	@objc func handleChangeToDarkMode(sender: Any) {
		ColorsMenuController.dark=true
		makeColorMenuUI()
		updateColorMenuUI()
		updateClocksForPreferenceChanges()
	}
	@objc func handleChangeToLightMode(sender: Any) {
		ColorsMenuController.dark=false
		makeColorMenuUI()
		updateColorMenuUI()
		updateClocksForPreferenceChanges()
	}
    @objc func changeColor(sender: NSMenuItem) {
        let newColorChoice=ColorModel.sharedInstance.colorArray[sender.tag]
		ClockPreferencesStorage.sharedInstance.changeAndSaveColorSceme(colorChoice: newColorChoice)
		NSColorPanel.shared.close()
        updateColorMenuUI()
        updateClocksForPreferenceChanges()
    }
    @objc func colorOnForeground(sender: NSMenuItem) {
		ClockPreferencesStorage.sharedInstance.colorOnForeground()
		makeColorMenuUI()
		updateColorMenuUI()
        updateClocksForPreferenceChanges()
    }
	@objc func colorOnBackground(sender: NSMenuItem) {
		ClockPreferencesStorage.sharedInstance.colorOnBackground()
		makeColorMenuUI()
		updateColorMenuUI()
        updateClocksForPreferenceChanges()
    }
	@objc func useNightmode(sender: NSMenuItem) {
		ClockPreferencesStorage.sharedInstance.toggleNightMode()
		makeColorMenuUI()
		updateColorMenuUI()
		updateClocksForPreferenceChanges()
	}
    @objc func showColorPanel(sender: NSMenuItem) {
		let colorMasks: NSColorPanel.Options =
			[NSColorPanel.Options.wheelModeMask, NSColorPanel.Options.colorListModeMask,
			 NSColorPanel.Options.customPaletteModeMask]
		NSColorPanel.setPickerMask(colorMasks)
        nsColorPanel.makeKeyAndOrderFront(self)
        //set action as using the picked color as the color and upating accordingly
		ClockPreferencesStorage.sharedInstance.changeToUsesCustumColor()
		nsColorPanel.color=ClockPreferencesStorage.sharedInstance.customColor
        nsColorPanel.setTarget(self)
        nsColorPanel.setAction(#selector(useCustomColor))
		updateColorMenuUI()
		updateClocksForPreferenceChanges()
    }
    @objc func useCustomColor() {
		let custumColor=nsColorPanel.color
		ClockPreferencesStorage.sharedInstance.changeCustomColor(customColor: custumColor)
		updateColorMenuUI()
		updateClocksForPreferenceChanges()
    }
	func makeColorMenuUI() {
		//add change color selectors
        //add color images
		guard let colorsMenu=self.colorsMenu else {
			return
		}
		//so program can conrol what user can select
        colorsMenu.autoenablesItems=false
        //enable menu items
        for index in 0...ColorModel.sharedInstance.colorArray.count-1 {
            colorsMenu.items[index].isEnabled=true
            colorsMenu.items[index].target=self
			colorsMenu.items[index].action=#selector(changeColor(sender:))
			var templateImage=NSImage()
			var tintColor=NSColor.clear
			if ColorsMenuController.dark {
				templateImage=NSImage(named: "white_rectangle") ?? NSImage()
				if ClockPreferencesStorage.sharedInstance.colorForForeground && !ClockPreferencesStorage.sharedInstance.useNightMode {
					templateImage=NSImage(named: "black_rectangle") ?? NSImage()
					tintColor=ColorModel.sharedInstance.lightColorsDictionary[ColorModel.sharedInstance.colorArray[index]]
						?? NSColor.clear
				} else {
					tintColor=ColorModel.sharedInstance.darkColorsDictionary[ColorModel.sharedInstance.colorArray[index]]
						?? NSColor.clear
				}
			} else {
			templateImage=NSImage(named: "black_rectangle") ?? NSImage()
				tintColor=ColorModel.sharedInstance.lightColorsDictionary[ColorModel.sharedInstance.colorArray[index]]
					?? NSColor.clear
			}
			templateImage.isTemplate=true
			let colorImage=tintExceptBorder(image: templateImage, tintColor: tintColor, borderPixels: CGFloat(0.25))
					colorsMenu.items[index].image=colorImage
		}
        //set-up reverse color mode menuItem
		colorsMenu.items[ColorModel.sharedInstance.colorArray.count+1].isEnabled=true
		colorsMenu.items[ColorModel.sharedInstance.colorArray.count+1].target=self
		colorsMenu.items[ColorModel.sharedInstance.colorArray.count+1].action=#selector(colorOnForeground(sender:))
		colorsMenu.items[ColorModel.sharedInstance.colorArray.count+2].isEnabled=true
		colorsMenu.items[ColorModel.sharedInstance.colorArray.count+2].target=self
		colorsMenu.items[ColorModel.sharedInstance.colorArray.count+2].action=#selector(colorOnBackground(sender:))
		colorsMenu.items[ColorModel.sharedInstance.colorArray.count+4].isEnabled=true
		colorsMenu.items[ColorModel.sharedInstance.colorArray.count+4].target=self
		colorsMenu.items[ColorModel.sharedInstance.colorArray.count+4].action=#selector(useNightmode(sender:))
		//set-up show color panel menuItem
		colorsMenu.items[ColorModel.sharedInstance.colorArray.count+6].isEnabled=true
        colorsMenu.items[ColorModel.sharedInstance.colorArray.count+6].target=self
        colorsMenu.items[ColorModel.sharedInstance.colorArray.count+6].action=#selector(showColorPanel(sender:))
	}
	func updateColorMenuUI() {
        for index in 0...ColorModel.sharedInstance.colorArray.count-1 {
            //if saved color string matches the array at menuItem's index, select
            if ClockPreferencesStorage.sharedInstance.colorChoice==ColorModel.sharedInstance.colorArray[index] {
				colorsMenu?.items[index].state=NSControl.StateValue.on
            }
            //otherwise, deselect
            else {
				colorsMenu?.items[index].state=NSControl.StateValue.off
            }
        }
        //update color image for custom color based on current custum color
        var templateImage=NSImage()
		var tintColor=ClockPreferencesStorage.sharedInstance.customColor
		if ColorsMenuController.dark && (!ClockPreferencesStorage.sharedInstance.colorForForeground || ClockPreferencesStorage.sharedInstance.useNightMode) {
			tintColor=ClockPreferencesStorage.sharedInstance.customColor.blended(withFraction: 0.4, of: NSColor.black)
				?? NSColor.systemGray
		}
		if !ColorsMenuController.dark || (ClockPreferencesStorage.sharedInstance.colorForForeground && !ClockPreferencesStorage.sharedInstance.useNightMode) {
			templateImage=NSImage(named: "black_rectangle") ?? NSImage()
		} else {
			templateImage=NSImage(named: "white_rectangle") ?? NSImage()
		}
        templateImage.isTemplate=true
		let colorImage=tintExceptBorder(image: templateImage, tintColor: tintColor, borderPixels: CGFloat(0.25))
		colorsMenu?.items[ColorModel.sharedInstance.colorArray.count-1].image=colorImage
		if ClockPreferencesStorage.sharedInstance.colorForForeground {
			colorsMenu?.items[ColorModel.sharedInstance.colorArray.count+1].state=NSControl.StateValue.on
			colorsMenu?.items[ColorModel.sharedInstance.colorArray.count+2].state=NSControl.StateValue.off
		} else {
			colorsMenu?.items[ColorModel.sharedInstance.colorArray.count+1].state=NSControl.StateValue.off
			colorsMenu?.items[ColorModel.sharedInstance.colorArray.count+2].state=NSControl.StateValue.on
		}
		if ClockPreferencesStorage.sharedInstance.useNightMode {
			colorsMenu?.items[ColorModel.sharedInstance.colorArray.count+4].state=NSControl.StateValue.on
		} else {
				colorsMenu?.items[ColorModel.sharedInstance.colorArray.count+4].state=NSControl.StateValue.off
		}
    }
	func updateClocksForPreferenceChanges() {
		ClockWindowController.clockObject.updateClockToPreferencesChange()
		DockClockController.dockClockObject.updateClockForPreferencesChange()
		AlarmsWindowController.alarmsObject.updateForPreferencesChange()
		TimersWindowController.timersObject.update()
		WorldClockWindowController.worldClockObject.update()
	}
}
