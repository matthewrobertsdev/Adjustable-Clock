//
//  DigItalClockAppFunctions.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 9/4/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
//if there is any active preferences window at all, return true
func isThereAPreferencesWindow() -> Bool {
    //get the app object
    let appObject = NSApp as NSApplication
    //search for the "Preferences" window
    for window in appObject.windows {
        //if window is found
		if window.identifier==UserInterfaceIdentifier.simplePrefrencesWindow {
            //if it's in the dock
            return true
        }
    }
    return false
}

//if there is any active preferences window at all, return true
func isThereASimplePreferencesWindow() -> Bool {
    //get the app object
    let appObject = NSApp as NSApplication
    //search for the "Preferences" window
    for window in appObject.windows {
        //if window is found
        if window.identifier==UserInterfaceIdentifier.simplePrefrencesWindow {
            //if it's in the dock
            return true
        }
    }
    return false
}
