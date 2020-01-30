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
		if(!ClockPreferencesStorage.sharedInstance.hasLaunchedBefore()) {
			let alert=NSAlert()
			alert.messageText = "Welcome to Clock Suit!  Click OK to begin the process of allowing Clock Suite to control your music.  It will send a one-time command to the Music app to stop your music so you can give it permission to play it from then on."
			alert.addButton(withTitle: "OK")
			alert.addButton(withTitle: "Cancel")
			alert.beginSheetModal(for: ClockWindowController.clockObject.window ?? NSWindow()) { (modalResponse) in
				if modalResponse==NSApplication.ModalResponse.alertFirstButtonReturn {
					let appleScript =
					"""
					tell application "Music"
						stop
					end tell
					"""
					var error: NSDictionary?
					if let scriptObject = NSAppleScript(source: appleScript) {
						if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
						print(outputString)
						} else if error != nil {
						print("Error: ", error ?? "")
						}
					}
				}
			}
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
