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
	 @IBOutlet weak var clockSuiteMenu: ClockSuiteMenu!
    @IBOutlet weak var colorsMenu: NSMenu!
    @IBOutlet weak var clocksMenu: ClocksMenu!
    @IBOutlet weak var clockMenu: ClockMenu!
	@IBOutlet weak var dockClockPreferencesMenu: DockClockPreferencesMenu!
    @IBOutlet weak var alarmsMenu: AlarmsMenu!
	@IBOutlet weak var timersMenu: TimersMenu!
	@IBOutlet weak var stopwatchMenu: StopwatchMenu!
	@IBOutlet weak var precisionMenu: PrecisionMenu!
	@IBOutlet weak var worldClockMenu: WorldClockMenu!
	@IBOutlet weak var helpMenu: HelpMenu!
	@IBAction func pressSimplePreferencesMenuItem(preferenceMenuItem: NSMenuItem) {

		if isThereASimplePreferencesWindow() {
			SimplePreferenceWindowController.prefrencesObject.window?.makeKeyAndOrderFront(nil)
		} else {
			showSimplePreferencesWindow()
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
