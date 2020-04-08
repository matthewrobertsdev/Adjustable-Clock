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
	var clockWindowController: ClockWindowController!
	//on launch
    func applicationDidFinishLaunching(_ aNotification: Notification) {
		//*
		GeneralPreferencesStorage.sharedInstance.loadUserPreferences()
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		AlarmsPreferencesStorage.sharedInstance.loadPreferences()
		TimersPreferenceStorage.sharedInstance.loadPreferences()
		WorldClockPreferencesStorage.sharedInstance.loadPreferences()

		//*
        let appObject = NSApp as NSApplication
		if let mainMenu=appObject.mainMenu as? MainMenu {
			colorsMenuController=ColorsMenuController(colorsMenu: mainMenu.colorsMenu)
			clockMenuController=ClockMenuController(menu: mainMenu.clockMenu)
			alarmsMenuController=AlarmsMenuController(menu: mainMenu.alarmsMenu)
			timersMenuController=TimersMenuController(menu: mainMenu.timersMenu)
			generalMenuController=GeneralMenuController(menu: mainMenu.generalMenu)
			//worldClockMenuController=WorldClockMenuController(menu: mainMenu.worldClockMenu)
		}
		//*
		//AlarmCenter.sharedInstance.setUp()
		DockClockController.dockClockObject.updateDockTile()
		/*
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
			clockMenuController?.enableMenu(enabled: true)
		}
*/
	}

    //if the dock icon is clicked
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		if !flag {
			showClock()
		}
		/*
		if WindowManager.sharedInstance.dockWindowArray.count==WindowManager.sharedInstance.count {
			WindowManager.sharedInstance.dockWindowArray.last?.deminiaturize(nil)
		}
*/
		return false
    }
    func applicationWillTerminate(_ aNotification: Notification) {
		GeneralPreferencesStorage.sharedInstance.closing=true
	}
	func clockWindowPresent() -> Bool {
		return isWindowPresent(identifier: UserInterfaceIdentifier.digitalClockWindow)
	}
	func showClock() {
		if clockWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let windowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"ClockWindowController") as? ClockWindowController else { return }
		clockWindowController=windowController
		clockWindowController.loadWindow()
			if let clockViewController=clockWindowController.contentViewController as? ClockViewController {
				clockViewController.showClock()
				clockWindowController.showWindow(nil)
			}
		} else {
			let appObject = NSApp as NSApplication
			for window in appObject.windows where window.identifier==UserInterfaceIdentifier.digitalClockWindow {
				if let windowController=window.windowController as? ClockWindowController {
					clockWindowController=windowController
					if let clockViewController=clockWindowController.contentViewController as? ClockViewController {
						clockViewController.showClock()
						window.makeKeyAndOrderFront(nil)
					}
				}
			}
		}
	}
}
