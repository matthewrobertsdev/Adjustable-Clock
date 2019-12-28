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
func findFittingFont(label: NSTextField, size: NSSize) {
	label.sizeToFit()
	var newWidth=label.frame.width
	let desiredWidth=0.95*Double(size.width)
	var newHeight=label.frame.height
	let desiredHeight=Double(size.height)
	var textSize=CGFloat((label.font?.pointSize)!)
	//make it big enough
	while (Double(newWidth)-desiredWidth < 2)&&(Double(newHeight)-desiredHeight<2) {
		textSize+=CGFloat(1)
		label.font=NSFont.userFont(ofSize: textSize)
		label.sizeToFit()
		newWidth=label.frame.width
		newHeight=label.frame.height
		if textSize>2000 {
			textSize=2000
			label.font=NSFont.userFont(ofSize: textSize)
			label.sizeToFit()
			break
		}
	}
	//make it small enough
	while (Double(newWidth)-desiredWidth>2)||(Double(newHeight)-desiredHeight>2) {
		textSize-=CGFloat(1)
		label.font=NSFont.userFont(ofSize: textSize)
		label.sizeToFit()
		newWidth=label.frame.width
		newHeight=label.frame.height
		if textSize<2 {
			textSize=1
			label.font=NSFont.userFont(ofSize: textSize)
			label.sizeToFit()
			break
		}
	}
}
