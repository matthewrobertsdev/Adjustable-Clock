//
//  AppDelegate.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
/*
other possibilities that could be done possibly from the same app:
--a analog clock
--a stopwatch
--a timer
*/
import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var colorsMenuController: ColorsMenuController!
	//on launch
    func applicationDidFinishLaunching(_ aNotification: Notification) {
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
        let appObject = NSApp as NSApplication
		if let mainMenu=appObject.mainMenu as? MainMenu {
			colorsMenuController=ColorsMenuController(colorsMenu: mainMenu.colorsMenu)
		}
    }
    //if the dock icon is clicked
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		DigitalClockWC.clockObject.showDigitalClock()
        return false
    }
	//before quiting
    func applicationWillTerminate(_ aNotification: Notification) {
	}
}
