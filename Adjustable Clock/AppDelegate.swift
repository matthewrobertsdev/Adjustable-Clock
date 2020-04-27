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
	//on launch
    func applicationDidFinishLaunching(_ aNotification: Notification) {
		//*
		GeneralPreferencesStorage.sharedInstance.loadUserPreferences()
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		AlarmsPreferencesStorage.sharedInstance.loadPreferences()
		TimersPreferenceStorage.sharedInstance.loadPreferences()
		WorldClockPreferencesStorage.sharedInstance.loadPreferences()

		//*
		AlarmCenter.sharedInstance.setUp()
        let appObject = NSApp as NSApplication
		if let mainMenu=appObject.mainMenu as? MainMenu {
			colorsMenuController=ColorsMenuController(colorsMenu: mainMenu.colorsMenu)
			clockMenuController=ClockMenuController(menu: mainMenu.clockMenu)
			alarmsMenuController=AlarmsMenuController(menu: mainMenu.alarmsMenu)
			timersMenuController=TimersMenuController(menu: mainMenu.timersMenu)
			clockSuiteMenuController=ClockSuiteMenuController(menu: mainMenu.clockSuiteMenu)
			dockClockPreferencesController=DockClockPreferencesMenuController(menu:  mainMenu.dockClockPreferencesMenu)
			dockClockMenuController=DockClockMenuController(menu: dockClockMenu)
			//worldClockMenuController=WorldClockMenuController(menu: mainMenu.worldClockMenu)
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
		if NSApp.orderedWindows.count==0 {
			ClockWindowController.clockObject.showClock()
			//clockMenuController?.enableMenu(enabled: true)
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
	}
}
