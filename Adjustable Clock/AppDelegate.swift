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
    var colorsMenuController: ColorsMenuController?
	var player: AVAudioPlayer?
	//on launch
    func applicationDidFinishLaunching(_ aNotification: Notification) {
	//let activity = ProcessInfo().beginActivity(options: .userInitiatedAllowingIdleSystemSleep, reason: "Good Reason")
	//playSong()
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		updateClockMenuUI()
		enableClockMenu(enabled: true)
        let appObject = NSApp as NSApplication
		if let mainMenu=appObject.mainMenu as? MainMenu {
			colorsMenuController=ColorsMenuController(colorsMenu: mainMenu.colorsMenu)
		}
		DockClockController.dockClockObject.updateDockTile()
	}
    //if the dock icon is clicked
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		ClockWindowController.clockObject.showClock()
        return false
    }
    func applicationWillTerminate(_ aNotification: Notification) {
	}
	func playSong() {
		let url = Bundle.main.url(forResource: "01_Hooked_On_A_Feeling", withExtension: "m4a")
		
		print(url)

		do {
			player = try AVAudioPlayer(contentsOf: url!)
			guard let player = player else { return }

			player.prepareToPlay()
			player.play()

		} catch let error as NSError {
			print(error.description)
		}
	}

}
