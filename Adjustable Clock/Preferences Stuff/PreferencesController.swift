//
//  PreferencesController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 3/23/18.
//  Copyright © 2018 Celeritas Apps. All rights reserved.
//

import Cocoa

class PreferencesController{
    
    var preferencesVC: PreferencesVC!
    let userDefaults=UserDefaults()
    
    let preferencesModel=PreferenceModel()
    
    init(preferencesVC: PreferencesVC) {
        self.preferencesVC=preferencesVC
    }
    
    func setUpView(){
        
        ClockPreferencesStorage.sharedInstance.loadUserPreferences()
        updateForPreferencesChange()
        addColorMenuActions()
    }
    
    func addColorMenuActions(){
        for menuItem in preferencesVC.colorsMenu.items{
            menuItem.target=self
            menuItem.action=#selector(changeColorV2(sender:))
            let clockNSColors=ClockNSColors()
            
            let templateImage=NSImage(named: NSImage.Name(rawValue: "black_rectangle"))
            templateImage?.isTemplate=true
            let tintColor=clockNSColors.standardColorsV2[preferencesModel.standardColorOrderV2[menuItem.tag]]!
            
            let colorImage=templateImage?.tintExceptBorder(tintColor: tintColor)
            
            menuItem.image=colorImage
        }
    }
    
    @objc func changeColor(sender: NSMenuItem){
        let newColorScheme=preferencesModel.standardColorOrder[sender.tag]
        //ClockPreferencesStorage.sharedInstance.changeAndSaveColorSceme(colorScheme: newColorScheme)
        updateClockToPreferencesChange()
        setColorMenuItem(colorScheme: newColorScheme)
    }
    
    @objc func changeColorV2(sender: NSMenuItem){
        let newColorChoice=preferencesModel.standardColorOrderV2[sender.tag]
        ClockPreferencesStorage.sharedInstance.changeAndSaveColorScemeV2(colorChoice: newColorChoice)
        updateClockToPreferencesChange()
        setColorMenuItemV2()
    }
    
    func setColorMenuItem(colorScheme: String){
        var menuItemIndex=0
        for index in 0...preferencesModel.standardColorOrder.count-1{
            if preferencesModel.standardColorOrder[index]==colorScheme{
                menuItemIndex=index
            }
        }
        let itemToSelect=preferencesVC.colorsMenu.items[menuItemIndex]
        preferencesVC.colorSchemPopUpButton.select(itemToSelect)
    }
    
    func setColorMenuItemV2(){
        
        
        for index in 0...7{
            if ClockPreferencesStorage.sharedInstance.colorChoice==preferencesModel.standardColorOrderV2[index]{
                preferencesVC.colorsMenu.items[index].state=NSControl.StateValue.on
                
                let itemToSelect=preferencesVC.colorsMenu.items[index]
                preferencesVC.colorSchemPopUpButton.select(itemToSelect)
                
            }
            else{
                preferencesVC.colorsMenu.items[index].state=NSControl.StateValue.off
            }
        }
 
    }
    
    func setFloatState(){
        ClockPreferencesStorage.sharedInstance.changeAndSaveClockFloats()
        updateForPreferencesChange()
    }
    
    func handleHourModePress(button: NSButton){
        print("pressed an hour mode rdaio button")
        let use24hourClock=ClockPreferencesStorage.sharedInstance.use24hourClock
        if button===preferencesVC.useAMorPMRB && use24hourClock{
            print("will change to AM/PM mode")
            ClockPreferencesStorage.sharedInstance.changeAndSaveUseAmPM()
        }
        else if button===preferencesVC.use24HourClockRB && !use24hourClock{
            print("will change to 24 hour mode")
            ClockPreferencesStorage.sharedInstance.changeAndSaveUseAmPM()
        }
        updateForPreferencesChange()
    }
    
    func changeShowDate(){
        print("changed show date")
        ClockPreferencesStorage.sharedInstance.changeAndSaveShowDate()
        updateForPreferencesChange()
    }
    
    func changeShowSeconds(){
        print("changed show seconds")
        ClockPreferencesStorage.sharedInstance.changeAndSaveUseSeconds()
        updateForPreferencesChange()
    }
    
    func updateClockToPreferencesChange(){
        let appObject = NSApp as NSApplication
        for window in appObject.windows{
            //if window is found
            if window.identifier==UserInterfaceIdentifier.clockWindow{
                let digitalClockVC=window.contentViewController as! DigitalClockVC
                digitalClockVC.updateClock()
            }
        }
    }

    func updatePreferencesUI(){
        //let colorScheme=ClockPreferencesStorage.sharedInstance.colorScheme
        //setColorMenuItem(colorScheme: colorScheme)
        if(ClockPreferencesStorage.sharedInstance.fullscreen){
            preferencesVC.floatsCheckBox.isEnabled=false
        }
        else{
            preferencesVC.floatsCheckBox.isEnabled=true
        }
        if ClockPreferencesStorage.sharedInstance.clockFloats{
            preferencesVC.floatsCheckBox.state=NSControl.StateValue(rawValue: 1)
        }
        else{
            preferencesVC.floatsCheckBox.state=NSControl.StateValue(rawValue: 0)
        }
        if ClockPreferencesStorage.sharedInstance.showSeconds{
            preferencesVC.showSecondsCheckBox.state=NSControl.StateValue(rawValue: 1)
        }
        else{
            preferencesVC.showSecondsCheckBox.state=NSControl.StateValue(rawValue: 0)
        }
        if ClockPreferencesStorage.sharedInstance.use24hourClock{
            preferencesVC.use24HourClockRB.state=NSControl.StateValue(rawValue: 1)
            preferencesVC.useAMorPMRB.state=NSControl.StateValue(rawValue: 0)
        }
        else{
            preferencesVC.useAMorPMRB.state=NSControl.StateValue(rawValue: 1)
            preferencesVC.use24HourClockRB.state=NSControl.StateValue(rawValue: 0)
        }
        if ClockPreferencesStorage.sharedInstance.showDate{
            preferencesVC.showDateCheckBox.state=NSControl.StateValue(rawValue: 1)
        }
        else{
            preferencesVC.showDateCheckBox.state=NSControl.StateValue(rawValue: 0)
        }
        setColorMenuItemV2()
    }
    func updateClockMenuUI(){
        let appObject = NSApp as NSApplication
        let mainMenu=appObject.mainMenu as! AdjustableClockMenu
        mainMenu.updateClockMenuUI()
    }
    
    func updateForPreferencesChange(){
        updateClockToPreferencesChange()
        updatePreferencesUI()
        updateClockMenuUI()
    }
    
    func restoreDefaults(){
        let appUserDefaults=AppUserDefaults()
        appUserDefaults.setDefaultUserDefaults()
        ClockPreferencesStorage.sharedInstance.loadUserPreferences()
        updateForPreferencesChange()
    }
}
