//
//  AppDelegate.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
/*
other possibilities that could be done possibly from the same app:
--a stopwatch
--a timer
*/
import AVFoundation
import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	var clock=ClockWindowController.clockObject.window
	var generalMenuController: GeneralMenuController?
    var colorsMenuController: ColorsMenuController?
	var clockMenuController: ClockMenuController?
	var alarmsMenuController: AlarmsMenuController?
	var player: AVAudioPlayer?
	//on launch
    func applicationDidFinishLaunching(_ aNotification: Notification) {
	//playSong()
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		AlarmsPreferencesStorage.sharedInstance.loadPreferences()
		updateClockMenuUI()
		enableClockMenu(enabled: true)
        let appObject = NSApp as NSApplication
		if let mainMenu=appObject.mainMenu as? MainMenu {
			colorsMenuController=ColorsMenuController(colorsMenu: mainMenu.colorsMenu)
			clockMenuController=ClockMenuController(menu: mainMenu.clockMenu)
			alarmsMenuController=AlarmsMenuController(menu: mainMenu.alarmsMenu)
			generalMenuController=GeneralMenuController(menu: mainMenu.generalMenu)
		}
		DockClockController.dockClockObject.updateDockTile()
		AlarmCenter.sharedInstance
		if AlarmsPreferencesStorage.sharedInstance.windowIsOpen {
			AlarmsWindowController.alarmsObject.showAlarms()
		}
		if ClockPreferencesStorage.sharedInstance.hasLaunchedBefore() {
		print("Onboarding")
			OnboardingWindowController.onboardingObject.showOnboarding()
			//OnboardingAlertController.onboardingObject.showOnboarding()
		} else {
			ClockWindowController.clockObject.showClock()
		}
	}
    //if the dock icon is clicked
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		ClockWindowController.clockObject.showClock()
        return false
    }
    func applicationWillTerminate(_ aNotification: Notification) {
		GeneralPreferencesStorage.sharedInstance.closing=true
	}
}
