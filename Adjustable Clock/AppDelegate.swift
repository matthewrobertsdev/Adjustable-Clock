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
	@IBOutlet weak var dockClockMenu: DockClockMenu!
	var dockClockMenuController: DockClockMenuController?
	var clockSuiteMenuController: ClockSuiteMenuController?
	var dockClockPreferencesController: DockClockPreferencesMenuController?
    var colorsMenuController: ColorsMenuController?
	var clockMenuController: ClockMenuController?
	var alarmsMenuController: AlarmsMenuController?
	var timersMenuController: TimersMenuController?
	var worldClockMenuController: WorldClockMenuController?
	var helpMenuController: HelpMenuController?
    var clocksMenuController: ClocksMenuController?
	var stopwatchMenuController: StopwatchMenuController?
	var precisionMenuController: PrecsionMenuController?

	//on launch
    func applicationDidFinishLaunching(_ aNotification: Notification) {
		//*
		GeneralPreferencesStorage.sharedInstance.loadUserPreferences()
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		AlarmsPreferencesStorage.sharedInstance.loadPreferences()
		TimersPreferenceStorage.sharedInstance.loadPreferences()
		StopwatchPreferencesStorage.sharedInstance.loadPreferences()
		WorldClockPreferencesStorage.sharedInstance.loadPreferences()

		//*
		AlarmCenter.sharedInstance.setUp()
		StopwatchCenter.sharedInstance.setUp()
        let appObject = NSApp as NSApplication
		if let mainMenu=appObject.mainMenu as? MainMenu {
			colorsMenuController=ColorsMenuController(colorsMenu: mainMenu.colorsMenu)
			clockMenuController=ClockMenuController(menu: mainMenu.clockMenu)
			alarmsMenuController=AlarmsMenuController(menu: mainMenu.alarmsMenu)
			timersMenuController=TimersMenuController(menu: mainMenu.timersMenu)
			clockSuiteMenuController=ClockSuiteMenuController(menu: mainMenu.clockSuiteMenu)
			dockClockPreferencesController=DockClockPreferencesMenuController(menu: mainMenu.dockClockPreferencesMenu)
			dockClockMenuController=DockClockMenuController(menu: dockClockMenu)
            clocksMenuController=ClocksMenuController(menu: mainMenu.clocksMenu)
			stopwatchMenuController=StopwatchMenuController(menu: mainMenu.stopwatchMenu)
			precisionMenuController=PrecsionMenuController(menu: mainMenu.precisionMenu)
			//worldClockMenuController=WorldClockMenuController(menu: mainMenu.worldClockMenu)
			helpMenuController=HelpMenuController(menu: mainMenu.helpMenu)
		}
		//*
		DockClockController.dockClockObject.updateDockTile()
		if AlarmsPreferencesStorage.sharedInstance.windowIsOpen {
			AlarmsWindowController.alarmsObject.showAlarms()
		}
		if TimersPreferenceStorage.sharedInstance.windowIsOpen {
			TimersWindowController.timersObject.showTimers()
			timersMenuController?.enableMenu(enabled: true)
		} else {
			timersMenuController?.enableMenu(enabled: false)
		}
		if WorldClockPreferencesStorage.sharedInstance.windowIsOpen {
			WorldClockWindowController.worldClockObject.showWorldClock()
		}
		if ClockPreferencesStorage.sharedInstance.windowIsOpen {
			ClockWindowController.clockObject.showClock()
			clockMenuController?.enableMenu(enabled: true)
		} else {
			clockMenuController?.enableMenu(enabled: false)
		}
		if StopwatchPreferencesStorage.sharedInstance.windowIsOpen {
			StopwatchWindowController.stopwatchObject.showStopwatch()
			stopwatchMenuController?.enableMenu(enabled: true)
			precisionMenuController?.enableMenu(enabled: true)
		} else {
			stopwatchMenuController?.enableMenu(enabled: false)
			precisionMenuController?.enableMenu(enabled: false)
		}
		if NSApp.orderedWindows.count==0 {
			ClockWindowController.clockObject.showClock()
		}
		//NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
	}

    //if the dock icon is clicked
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		if !flag {
			ClockWindowController.clockObject.showClock()
		}
		if WindowManager.sharedInstance.dockWindowArray.count==WindowManager.sharedInstance.count {
			WindowManager.sharedInstance.dockWindowArray.last?.deminiaturize(nil)
		}
		return false
    }
    func applicationWillTerminate(_ aNotification: Notification) {
		NSColorPanel.shared.close()
		GeneralPreferencesStorage.sharedInstance.closing=true
		ClockPreferencesStorage.sharedInstance.saveCustomColor()
		TimersCenter.sharedInstance.saveTimers()
		if let stopwatchViewController=StopwatchWindowController.stopwatchObject.contentViewController as? StopwatchViewController {
			stopwatchViewController.stop()
		}
		StopwatchCenter.sharedInstance.saveLaps()
		NSColorPanel.shared.close()
	}
}
