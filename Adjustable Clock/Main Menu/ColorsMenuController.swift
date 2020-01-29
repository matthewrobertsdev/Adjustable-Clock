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
    let clockNSColors=ColorDictionary()
    let colorArray=ColorArrays()
	let nsColorPanel=NSColorPanel.shared
	@objc var objectToObserve=DockClockController.dockClockObject.dockClockView
	var observation: NSKeyValueObservation?
	var dark=false
    init(colorsMenu: NSMenu) {
		super.init()
        self.colorsMenu=colorsMenu
        makeColorMenuUI()
        //reflect saved (or default) choice
        updateColorMenuUI()
		observation = observe(
			\.objectToObserve.dark,
            options: [.old, .new]
        ) { _, change in
			self.dark=change.newValue ?? false
			self.makeColorMenuUI()
			self.updateColorMenuUI()
        }
    }
    @objc func changeColor(sender: NSMenuItem) {
        let newColorChoice=colorArray.colorArray[sender.tag]
        ClockPreferencesStorage.sharedInstance.changeAndSaveColorSceme(colorChoice: newColorChoice)
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
    @objc func showColorPanel(sender: NSMenuItem) {
		let colorMasks: NSColorPanel.Options =
			[NSColorPanel.Options.wheelModeMask, NSColorPanel.Options.colorListModeMask,
			 NSColorPanel.Options.customPaletteModeMask, NSColorPanel.Options.crayonModeMask]
		NSColorPanel.setPickerMask(colorMasks)
        nsColorPanel.makeKeyAndOrderFront(self)
        //set action as using the picked color as the color and upating accordingly
        nsColorPanel.setTarget(self)
        nsColorPanel.setAction(#selector(useCustomColor))
    }
    @objc func useCustomColor() {
		ClockPreferencesStorage.sharedInstance.changeAndSaveCustomColor(customColor: nsColorPanel.color)
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
        for index in 0...colorArray.colorArray.count-1 {
            colorsMenu.items[index].isEnabled=true
            colorsMenu.items[index].target=self
			colorsMenu.items[index].action=#selector(changeColor(sender:))
			var templateImage=NSImage()
			var tintColor=NSColor.clear
			if dark && !ClockPreferencesStorage.sharedInstance.colorForForeground {
				templateImage=NSImage(named: "white_rectangle") ?? NSImage()
				tintColor=clockNSColors.colorsDictionary[colorArray.colorArray[index]]?.blended(withFraction: 0.5, of: NSColor.black) ?? NSColor.clear
			} else {
			templateImage=NSImage(named: "black_rectangle") ?? NSImage()
				tintColor=clockNSColors.colorsDictionary[colorArray.colorArray[index]] ?? NSColor.clear
			}
			templateImage.isTemplate=true
			let colorImage=templateImage.tintExceptBorder(tintColor: tintColor, borderPixels: CGFloat(0.25))
					colorsMenu.items[index].image=colorImage
		}
        //set-up reverse color mode menuItem
		colorsMenu.items[colorArray.colorArray.count+1].isEnabled=true
		colorsMenu.items[colorArray.colorArray.count+1].target=self
		colorsMenu.items[colorArray.colorArray.count+1].action=#selector(colorOnForeground(sender:))
		colorsMenu.items[colorArray.colorArray.count+2].isEnabled=true
		colorsMenu.items[colorArray.colorArray.count+2].target=self
		colorsMenu.items[colorArray.colorArray.count+2].action=#selector(colorOnBackground(sender:))
		//set-up show color panel menuItem
		colorsMenu.items[colorArray.colorArray.count+4].isEnabled=true
        colorsMenu.items[colorArray.colorArray.count+4].target=self
        colorsMenu.items[colorArray.colorArray.count+4].action=#selector(showColorPanel(sender:))
	}
	func updateColorMenuUI() {
        for index in 0...colorArray.colorArray.count-1 {
            //if saved color string matches the array at menuItem's index, select
            if ClockPreferencesStorage.sharedInstance.colorChoice==colorArray.colorArray[index] {
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
		if dark && !ClockPreferencesStorage.sharedInstance.colorForForeground {
			templateImage=NSImage(named: "white_rectangle") ?? NSImage()
			tintColor=tintColor.blended(withFraction: 0.5, of: NSColor.black) ?? NSColor.clear
		} else {
			templateImage=NSImage(named: "black_rectangle") ?? NSImage()
		}
        templateImage.isTemplate=true
		let colorImage=templateImage.tintExceptBorder(tintColor: tintColor, borderPixels: CGFloat(0.25))
		colorsMenu?.items[colorArray.colorArray.count-1].image=colorImage
		if ClockPreferencesStorage.sharedInstance.colorForForeground {
			colorsMenu?.items[colorArray.colorArray.count+1].state=NSControl.StateValue.on
			colorsMenu?.items[colorArray.colorArray.count+2].state=NSControl.StateValue.off
		} else {
			colorsMenu?.items[colorArray.colorArray.count+1].state=NSControl.StateValue.off
			colorsMenu?.items[colorArray.colorArray.count+2].state=NSControl.StateValue.on
		}
    }
	func updateClocksForPreferenceChanges() {
		ClockWindowController.clockObject.updateClockToPreferencesChange()
		DockClockController.dockClockObject.updateClockForPreferencesChange()
		AlarmsWindowController.alarmsObject.updateForPreferencesChange()
	}
}
