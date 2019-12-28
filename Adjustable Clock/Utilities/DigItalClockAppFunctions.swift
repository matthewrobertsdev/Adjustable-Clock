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
    for window in appObject.windows where  window.identifier==UserInterfaceIdentifier.simplePrefrencesWindow {
		return true
    }
    return false
}

//if there is any active preferences window at all, return true
func isThereASimplePreferencesWindow() -> Bool {
    //get the app object
    let appObject = NSApp as NSApplication
    //search for the "Preferences" window
    for window in appObject.windows where window.identifier==UserInterfaceIdentifier.simplePrefrencesWindow {
            return true
    }
    return false
}

func windowPresent(identifier: NSUserInterfaceItemIdentifier) -> Bool {
	//get the app object
	let appObject = NSApp as NSApplication
	//search for the Digital Clock window
	for window in appObject.windows where window.identifier==identifier{
			return true
		}
	return false
}
func updateClockMenuUI() {
	let appObject = NSApp as NSApplication
	if let mainMenu=appObject.mainMenu as? MainMenu {
		mainMenu.updateClockMenuUI()
	}
}
func enableClockMenu(enabled: Bool) {
	let appObject = NSApp as NSApplication
	if let mainMenu=appObject.mainMenu as? MainMenu {
		mainMenu.enableClockMenuPreferences(enabled: enabled)
	}
}
