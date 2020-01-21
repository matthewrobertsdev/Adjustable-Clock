//
//  AdjustableClockMainMenu.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 8/24/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import  Cocoa
class MainMenu: NSMenu {
	let clockPreferences=ClockPreferencesStorage.sharedInstance
    @IBOutlet weak var colorsMenu: NSMenu!
    @IBOutlet weak var clockMenu: ClockMenu!
    @IBOutlet weak var alarmsMenu: AlarmsMenu!
    @IBAction func pressSimplePreferencesMenuItem(preferenceMenuItem: NSMenuItem) {
        let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.digitalClockWindow {
				guard let digitalClockVC=window.contentViewController as? ClockViewController else {
					return
				}
                if digitalClockVC.model.fullscreen==true {
                    for window in appObject.windows where window.identifier==UserInterfaceIdentifier.prefrencesWindow {
						if let preferencesWC=window.windowController as? SimplePreferenceWindowController {
							preferencesWC.close()
						}
                    }
                    showSimplePreferencesWindow()
				} else {
                    if isThereASimplePreferencesWindow() {
						SimplePreferenceWindowController.prefrencesObject.window?.makeKeyAndOrderFront(nil)
                    } else {
                        showSimplePreferencesWindow()
                    }
                }
            }
    }
    func showSimplePreferencesWindow() {
        let adjustableClockStoryboard = NSStoryboard(name: "Main", bundle: nil)
		guard let preferencesObject = adjustableClockStoryboard.instantiateController(withIdentifier:
			"SimplePreferencesWC") as? SimplePreferenceWindowController else {
				return
		}
		SimplePreferenceWindowController.prefrencesObject=preferencesObject
		SimplePreferenceWindowController.prefrencesObject.loadWindow()
		SimplePreferenceWindowController.prefrencesObject.showWindow(nil)
    }
	func reloadSimplePreferencesWindow() {
		SimplePreferenceWindowController.prefrencesObject.loadWindow()
		SimplePreferenceWindowController.prefrencesObject.showWindow(nil)
	}
}
