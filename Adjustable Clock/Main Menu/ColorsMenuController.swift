//
//  ColorsMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 7/5/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Cocoa
class ColorsMenuController{
    var colorsMenu: NSMenu?
    let clockNSColors=ColorDictionary()
    let colorArray=ColorArrays()
	let nsColorPanel=NSColorPanel.shared
    init(colorsMenu: NSMenu) {
        self.colorsMenu=colorsMenu
        makeColorMenuUI()
        //reflect saved (or default) choice
        updateColorMenuUI()
    }
    
    @objc func changeColor(sender: NSMenuItem){
        let newColorChoice=colorArray.colorArray[sender.tag]
        ClockPreferencesStorage.sharedInstance.changeAndSaveColorSceme(colorChoice: newColorChoice)
        updateColorMenuUI()
        DigitalClockWC.clockObject.updateClockToPreferencesChange()
    }
    @objc func reverseColorMode(sender: NSMenuItem){
		ClockPreferencesStorage.sharedInstance.changeAndSaveLonD()
        DigitalClockWC.clockObject.updateClockToPreferencesChange()
    }
    @objc func showColorPanel(sender: NSMenuItem){
		NSColorPanel.setPickerMask([NSColorPanel.Options.wheelModeMask, NSColorPanel.Options.colorListModeMask,NSColorPanel.Options.customPaletteModeMask, NSColorPanel.Options.crayonModeMask])
        nsColorPanel.makeKeyAndOrderFront(self)
        //set action as using the picked color as the color and upating accordingly
        nsColorPanel.setTarget(self)
        nsColorPanel.setAction(#selector(useCustomColor))
    }
    @objc func useCustomColor(){
		ClockPreferencesStorage.sharedInstance.changeAndSaveCustomColor(customColor: nsColorPanel.color)
        updateColorMenuUI()
		DigitalClockWC.clockObject.updateClockToPreferencesChange()
    }
	func makeColorMenuUI(){
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
            let templateImage=NSImage(named: "black_rectangle")
            templateImage?.isTemplate=true
			var tintColor=NSColor.clear
            if index<colorArray.colorArray.count-1{
				tintColor=clockNSColors.colorsDictionary[colorArray.colorArray[index]] ?? NSColor.clear
            }
			if let colorImage=templateImage?.tintExceptBorder(tintColor: tintColor, borderPixels: CGFloat(0)){
					colorsMenu.items[index].image=colorImage
				}
		}
        //set-up reverse color mode menuItem
		colorsMenu.items[colorArray.colorArray.count+1].isEnabled=true
		colorsMenu.items[colorArray.colorArray.count+1].target=self
		colorsMenu.items[colorArray.colorArray.count+1].action=#selector(reverseColorMode(sender:))
		
		//set-up show color panel menuItem
		colorsMenu.items[colorArray.colorArray.count+3].isEnabled=true
        colorsMenu.items[colorArray.colorArray.count+3].target=self
        colorsMenu.items[colorArray.colorArray.count+3].action=#selector(showColorPanel(sender:))
	}
    func updateColorMenuUI(){
        for index in 0...colorArray.colorArray.count-1{
            //if saved color string matches the array at menuItem's index, select
            if ClockPreferencesStorage.sharedInstance.colorChoice==colorArray.colorArray[index]{
				colorsMenu?.items[index].state=NSControl.StateValue.on
            }
            //otherwise, deselect
            else{
				colorsMenu?.items[index].state=NSControl.StateValue.off
            }
        }
        //update color image for custom color based on current custum color
        let templateImage=NSImage(named: "black_rectangle")
        templateImage?.isTemplate=true
        let tintColor=ClockPreferencesStorage.sharedInstance.customColor
		let colorImage=templateImage?.tintExceptBorder(tintColor: tintColor, borderPixels: CGFloat(0))
		colorsMenu?.items[colorArray.colorArray.count-1].image=colorImage
    }
}
