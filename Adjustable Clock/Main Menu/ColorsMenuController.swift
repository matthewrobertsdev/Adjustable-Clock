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
    
    let prefrencesModel=PreferenceModel()
    
    var nsColorPanel: NSColorPanel!
    
    init(colorsMenu: ColorsMenu) {
        self.colorsMenu=colorsMenu
        colorsMenu.autoenablesItems=false
        for index in 0...prefrencesModel.standardColorOrderV2.count-1 {
            colorsMenu.items[index].isEnabled=true
            colorsMenu.items[index].target=self
            colorsMenu.items[index].action=#selector(changeColor(sender:))
            let clockNSColors=ClockNSColors()
            
            let templateImage=NSImage(named: NSImage.Name(rawValue: "black_rectangle"))
            templateImage?.isTemplate=true
            var tintColor=ClockPreferencesStorage.sharedInstance.customColor!
            if index<prefrencesModel.standardColorOrderV2.count-1{
                tintColor=clockNSColors.standardColorsV2[prefrencesModel.standardColorOrderV2[index]]!
            }
            
            let colorImage=templateImage?.tintExceptBorder(tintColor: tintColor)
 
            colorsMenu.items[index].image=colorImage
            
            }
        print("color menu count is "+colorsMenu.items.count.description)
        colorsMenu.items[prefrencesModel.standardColorOrderV2.count+1].isEnabled=true
        colorsMenu.items[prefrencesModel.standardColorOrderV2.count+1].target=self
        colorsMenu.items[prefrencesModel.standardColorOrderV2.count+1].action=#selector(reverseColorMode(sender:))
        colorsMenu.items[prefrencesModel.standardColorOrderV2.count+3].isEnabled=true
        colorsMenu.items[prefrencesModel.standardColorOrderV2.count+3].target=self
        colorsMenu.items[prefrencesModel.standardColorOrderV2.count+3].action=#selector(showColorPanel(sender:))
        updateColorMenuUI()
    }
    
    @objc func changeColor(sender: NSMenuItem){
        print("color should change")
        let newColorChoice=prefrencesModel.standardColorOrderV2[sender.tag]
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
        for index in 0...prefrencesModel.standardColorOrderV2.count-1{
            if ClockPreferencesStorage.sharedInstance.colorChoice==prefrencesModel.standardColorOrderV2[index]{
                colorsMenu.items[index].state=NSControl.StateValue.on
            }
            else{
                colorsMenu.items[index].state=NSControl.StateValue.off
            }
        }
        let templateImage=NSImage(named: NSImage.Name(rawValue: "black_rectangle"))
        templateImage?.isTemplate=true
        let tintColor=ClockPreferencesStorage.sharedInstance.customColor!
        
        let colorImage=templateImage?.tintExceptBorder(tintColor: tintColor)
        
        colorsMenu.items[prefrencesModel.standardColorOrderV2.count-1].image=colorImage
        
    }
    
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
