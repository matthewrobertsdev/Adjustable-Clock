//
//  AppDelegate.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	var generalMenuController: GeneralMenuController?
    var colorsMenuController: ColorsMenuController?
	var clockMenuController: ClockMenuController?
	var alarmsMenuController: AlarmsMenuController?
	var timersMenuController: TimersMenuController?
	var worldClockMenuController: WorldClockMenuController?
	//on launch
    func applicationDidFinishLaunching(_ aNotification: Notification) {
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		AlarmsPreferencesStorage.sharedInstance.loadPreferences()
		TimersPreferenceStorage.sharedInstance.loadPreferences()
		WorldClockPreferencesStorage.sharedInstance.loadPreferences()
		updateClockMenuUI()
		enableClockMenu(enabled: true)
        let appObject = NSApp as NSApplication
		if let mainMenu=appObject.mainMenu as? MainMenu {
			colorsMenuController=ColorsMenuController(colorsMenu: mainMenu.colorsMenu)
			clockMenuController=ClockMenuController(menu: mainMenu.clockMenu)
			alarmsMenuController=AlarmsMenuController(menu: mainMenu.alarmsMenu)
			timersMenuController=TimersMenuController(menu: mainMenu.timersMenu)
			generalMenuController=GeneralMenuController(menu: mainMenu.generalMenu)
			//worldClockMenuController=WorldClockMenuController(menu: mainMenu.worldClockMenu)
		}
		DockClockController.dockClockObject.updateDockTile()
		AlarmCenter.sharedInstance
		if AlarmsPreferencesStorage.sharedInstance.windowIsOpen {
			AlarmsWindowController.alarmsObject.showAlarms()
		}
		if TimersPreferenceStorage.sharedInstance.windowIsOpen {
			TimersWindowController.timersObject.showTimers()
		}
		if WorldClockPreferencesStorage.sharedInstance.windowIsOpen {
			WorldClockWindowController.worldClockObject.showWorldClock()
		}
		if ClockPreferencesStorage.sharedInstance.windowIsOpen {
			ClockWindowController.clockObject.showClock()
		}
		print("abcd count"+NSApp.windows.count.description)
		if NSApp.orderedWindows.count==0 {
			ClockWindowController.clockObject.showClock()
		} else {
			NSApp.orderedWindows[0].makeKeyAndOrderFront(nil)
		}
	}
    //if the dock icon is clicked
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		if NSApp.orderedWindows.count==0 {
			ClockWindowController.clockObject.showClock()
		} else {
			NSApp.orderedWindows[0].makeKeyAndOrderFront(nil)
		}
        return false
    }
    func applicationWillTerminate(_ aNotification: Notification) {
		GeneralPreferencesStorage.sharedInstance.closing=true
	}
}
