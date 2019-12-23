//
//  DigItalClockAppFunctions.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 9/4/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
//if there is any active preferences window at all, return true
func isThereAPreferencesWindow()->Bool{
    //get the app object
    let appObject = NSApp as NSApplication
    //search for the "Preferences" window
    for window in appObject.windows{
        //if window is found
		if window.identifier==UserInterfaceIdentifier.simplePrefrencesWindow{
            //if it's in the dock
            if window.isMiniaturized{
                return true
            }
            else if window.isVisible{
                return true
            }
        }
    }
    return false
}

//if there is any active preferences window at all, return true
func isThereASimplePreferencesWindow()->Bool{
    //get the app object
    let appObject = NSApp as NSApplication
    //search for the "Preferences" window
    for window in appObject.windows{
        //if window is found
        if window.identifier==UserInterfaceIdentifier.simplePrefrencesWindow{
            //if it's in the dock
            if window.isMiniaturized{
                return true
            }
            else if window.isVisible{
                return true
            }
        }
    }
    return false
}
//save, but only if the app should
func digitalClockSaveStateAsNeeded(){
    //get app object
    let appObject = NSApp as NSApplication
    //get clock window data if it's still open
    for window in appObject.windows{
        if window.identifier==UserInterfaceIdentifier.clockWindow{
            let digitalClockVC=window.contentViewController as! DigitalClockVC
            if !(digitalClockVC.digitalClockModel.fullscreen==true){
                let digitalClockWC=window.windowController as! DigitalClockWC
                //save the window's state
                digitalClockWC.saveState()
            }
        }
    }
}
