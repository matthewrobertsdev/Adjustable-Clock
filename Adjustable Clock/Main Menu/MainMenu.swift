//
//  AdjustableClockMainMenu.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 8/24/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//

import  Cocoa

class MainMenu: NSMenu{
    
    @IBOutlet weak var colorsMenu: NSMenu!
    
    var simplePreferencesWC: SimplePreferencesWC?
    var digitalClockWC: DigitalClockWC?
    
    let prefrences=ClockPreferencesStorage.sharedInstance
    
    @IBOutlet weak var clockMenu: NSMenu!
    
    @IBOutlet weak var clockFloatsMenuItem: NSMenuItem!
    @IBOutlet weak var showSecondsMenuItem: NSMenuItem!
    @IBOutlet weak var use24HourClockMenuItem: NSMenuItem!
    @IBOutlet weak var showDateMenuItem: NSMenuItem!
    @IBOutlet weak var showDayOfWeekMenuItem: NSMenuItem!
    @IBOutlet weak var datePreferencesMenu: NSMenu!
    @IBOutlet weak var useNumericalDateMenuItem: NSMenuItem!
    
    @IBAction func clickClockFloats(nsMenuItem: NSMenuItem){
        ClockPreferencesStorage.sharedInstance.changeAndSaveClockFloats()
        updateForPreferencesChange()
    }
    
    @IBAction func clickShowSeconds(nsMenuItem: NSMenuItem){
        ClockPreferencesStorage.sharedInstance.changeAndSaveUseSeconds()
        updateForPreferencesChange()
    }
    
    @IBAction func clickUse24Hours(nsMenuItem: NSMenuItem){
        ClockPreferencesStorage.sharedInstance.changeAndSaveUseAmPM()
        updateForPreferencesChange()
    }
    
    @IBAction func clickShowDate(nsMenuItem: NSMenuItem){
        ClockPreferencesStorage.sharedInstance.changeAndSaveShowDate()
        updateForPreferencesChange()
    }
    
    @IBAction func showDayOfWeek(nsMenuItem: NSMenuItem){
        ClockPreferencesStorage.sharedInstance.changeAndSaveShowDofW()
        updateForPreferencesChange()
    }
    
    @IBAction func useNumericalDate(nsMenuItem: NSMenuItem){
        ClockPreferencesStorage.sharedInstance.changeAndSaveUseNumericalDate()
        updateForPreferencesChange()
    }
    
    func updateClockMenuUI(){
        datePreferencesMenu.autoenablesItems=false
        if(ClockPreferencesStorage.sharedInstance.fullscreen){
            clockFloatsMenuItem.isEnabled=false
        }
        else{
            clockFloatsMenuItem.isEnabled=true
        }
        if ClockPreferencesStorage.sharedInstance.clockFloats{
            clockFloatsMenuItem.state=NSControl.StateValue.on
        }
        else{
            clockFloatsMenuItem.state=NSControl.StateValue.off
        }
        if ClockPreferencesStorage.sharedInstance.showSeconds{
            showSecondsMenuItem.state=NSControl.StateValue.on
        }
        else{
            showSecondsMenuItem.state=NSControl.StateValue.off
        }
        if ClockPreferencesStorage.sharedInstance.use24hourClock{
            use24HourClockMenuItem.state=NSControl.StateValue.on
        }
        else{
            use24HourClockMenuItem.state=NSControl.StateValue.off
        }
        if ClockPreferencesStorage.sharedInstance.showDate{
            showDateMenuItem.state=NSControl.StateValue.on
            useNumericalDateMenuItem.isEnabled=true
        }
        else{
            showDateMenuItem.state=NSControl.StateValue.off
            useNumericalDateMenuItem.isEnabled=false
        }
        
        if ClockPreferencesStorage.sharedInstance.showDayOfWeek{
            showDayOfWeekMenuItem.state=NSControl.StateValue.on
        }
        else{
            showDayOfWeekMenuItem.state=NSControl.StateValue.off
        }
        if ClockPreferencesStorage.sharedInstance.useNumericalDate{
            useNumericalDateMenuItem.state=NSControl.StateValue.on
        }
        else{
            useNumericalDateMenuItem.state=NSControl.StateValue.off
        }
    }
    
    @IBAction func pressSimplePreferencesMenuItem(preferenceMenuItem: NSMenuItem){
        print("show preferences clicked")
        let appObject = NSApp as NSApplication
        
        for window in appObject.windows{
            if window.identifier==UserInterfaceIdentifier.clockWindow{
                let digitalClockVC=window.contentViewController as! DigitalClockVC
                if digitalClockVC.digitalClockModel.fullscreen==true{
                    for window in appObject.windows{
                        if window.identifier==UserInterfaceIdentifier.prefrencesWindow{
                            let preferencesWC=window.windowController as! SimplePreferencesWC
                            preferencesWC.close()
                        }
                    }
                    
                    showSimplePreferencesWindow()
                }
                else{
                    if(isThereASimplePreferencesWindow()){
                        simplePreferencesWC?.window?.makeKeyAndOrderFront(nil)
                    }
                    else
                    {
                        showSimplePreferencesWindow()
                    }
                    
                }
            }
        }
        
    }
    
    @IBAction func pressShowDigitalClockMenuItem(showClockMenuItem: NSMenuItem){
        if(!digitalClockWindowPresent()){
            showDigitalClock()
        }
    }
    
    func showDigitalClock(){
        let adjustableClockStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        digitalClockWC = adjustableClockStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "DigitalClockWC")) as? DigitalClockWC
        digitalClockWC?.loadWindow()
        digitalClockWC?.showWindow(nil)
    }
    
    func showSimplePreferencesWindow(){
        print("should show simple preferences window")
        let adjustableClockStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        simplePreferencesWC = adjustableClockStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SimplePreferencesWC")) as? SimplePreferencesWC
        simplePreferencesWC?.loadWindow()
        simplePreferencesWC?.showWindow(nil)
    }
    
    
    func updateForPreferencesChange(){
        updateClockMenuUI()
        updateClockToPreferencesChange()
    }
    
    func enableClockMenuPreferences(enabled: Bool){
        clockMenu.autoenablesItems=false
        clockFloatsMenuItem.isEnabled=enabled
        showSecondsMenuItem.isEnabled=enabled
        use24HourClockMenuItem.isEnabled=enabled
        showDateMenuItem.isEnabled=enabled
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

}
