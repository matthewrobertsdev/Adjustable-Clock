//
//  ColorsMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 7/5/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Cocoa

class ColorsMenuController{
    
    var colorsMenu: ColorsMenu!
    
    var nsColorPanel: NSColorPanel!
    
    let clockNSColors=ClockNSColors()
    let colorOrder=ColorOrders()
    
    init(colorsMenu: ColorsMenu) {
        self.colorsMenu=colorsMenu
        
        //so program can conrol what user can select
        colorsMenu.autoenablesItems=false
        
        //enable menu items
        //add change color selectors
        //add color images
        for index in 0...colorOrder.standardColorsOrder.count-1 {
            
            colorsMenu.items[index].isEnabled=true
            
            colorsMenu.items[index].target=self
            colorsMenu.items[index].action=#selector(changeColor(sender:))
            
            let clockNSColors=ClockNSColors()
            
            let templateImage=NSImage(named: NSImage.Name(rawValue: "black_rectangle"))
            templateImage?.isTemplate=true
            var tintColor=ClockPreferencesStorage.sharedInstance.customColor!
            if index<colorOrder.standardColorsOrder.count-1{
                tintColor=clockNSColors.standardColor[colorOrder.standardColorsOrder[index]]!
            }
            let colorImage=templateImage?.tintExceptBorder(tintColor: tintColor)
            colorsMenu.items[index].image=colorImage
            
            }
        
        //print("color menu count is "+colorsMenu.items.count.description)
        
        //set-up reverse color mode menuItem
        colorsMenu.items[colorOrder.standardColorsOrder.count+1].isEnabled=true
        colorsMenu.items[colorOrder.standardColorsOrder.count+1].target=self
        colorsMenu.items[colorOrder.standardColorsOrder.count+1].action=#selector(reverseColorMode(sender:))
        
        //set-up show color panel menuItem
        colorsMenu.items[colorOrder.standardColorsOrder.count+3].isEnabled=true
        colorsMenu.items[colorOrder.standardColorsOrder.count+3].target=self
        colorsMenu.items[colorOrder.standardColorsOrder.count+3].action=#selector(showColorPanel(sender:))
        
        //reflect saved (or default) choice
        updateColorMenuUI()
    }
    
    @objc func changeColor(sender: NSMenuItem){
        print("color should change")
        let newColorChoice=colorOrder.standardColorsOrder[sender.tag]
        ClockPreferencesStorage.sharedInstance.changeAndSaveColorSceme(colorChoice: newColorChoice)
        updateColorMenuUI()
        updateClockToPreferencesChange()
    }
    
    @objc func reverseColorMode(sender: NSMenuItem){
        print("should reverse colors")
        ClockPreferencesStorage.sharedInstance.changeAndSaveLonD()
        updateClockToPreferencesChange()
    }
    
    @objc func showColorPanel(sender: NSMenuItem){
        
    NSColorPanel.setPickerMask([NSColorPanel.Options.wheelModeMask, NSColorPanel.Options.colorListModeMask,NSColorPanel.Options.customPaletteModeMask, NSColorPanel.Options.crayonModeMask])
        nsColorPanel=NSColorPanel.shared
        nsColorPanel.makeKeyAndOrderFront(self)
        //set action as using the picked color as the color and upating accordingly
        nsColorPanel.setTarget(self)
        nsColorPanel.setAction(#selector(useCustomColor))
        
    }
    
    @objc func useCustomColor(){
        print("chose custum color")
            ClockPreferencesStorage.sharedInstance.changeAndSaveCustomColor(customColor: nsColorPanel.color)
        updateColorMenuUI()
        updateClockToPreferencesChange()
        
    }
    
    func updateColorMenuUI(){
        for index in 0...colorOrder.standardColorsOrder.count-1{
            //if saved color string matches the array at menuItem's index, select
            if ClockPreferencesStorage.sharedInstance.colorChoice==colorOrder.standardColorsOrder[index]{
                colorsMenu.items[index].state=NSControl.StateValue.on
            }
            //otherwise, deselect
            else{
                colorsMenu.items[index].state=NSControl.StateValue.off
            }
        }
        
        //update color image for custom color based on current custum color
        let templateImage=NSImage(named: NSImage.Name(rawValue: "black_rectangle"))
        templateImage?.isTemplate=true
        let tintColor=ClockPreferencesStorage.sharedInstance.customColor!
        let colorImage=templateImage?.tintExceptBorder(tintColor: tintColor)
        colorsMenu.items[colorOrder.standardColorsOrder.count-1].image=colorImage
        
    }
    
    //update clock is clock is found
    func updateClockToPreferencesChange(){
        print("clock should update")
        let appObject = NSApp as NSApplication
        for window in appObject.windows{
            //if window is found
            if window.identifier==UserInterfaceIdentifier.clockWindow{
                let digitalClockVC=window.contentViewController as! DigitalClockVC
                digitalClockVC.updateClock()
            }
        }
    }
    
    
}
