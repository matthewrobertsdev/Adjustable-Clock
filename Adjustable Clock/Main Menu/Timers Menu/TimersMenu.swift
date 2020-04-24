//
//  TimersMenu.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class TimersMenu: NSMenu {
	weak var timersMenuDelegate: TimerMenuDelegate!
	@IBOutlet weak var activeTimersMenuItem: NSMenuItem!
	@IBOutlet weak var timerFloatsMenuItem: NSMenuItem!
	@IBOutlet weak var asSecondsMenuItem: NSMenuItem!
	@IBAction func toggleTimersFloats(nsMenuItem: NSMenuItem) {
		timersMenuDelegate.toggleTimerFloatsClicked()
	}
	@IBAction func setAsSeconds(nsMenuItem: NSMenuItem) {
		timersMenuDelegate.asSecondsClicked()
	}
	@IBAction func showTimers(nsMenuItem: NSMenuItem) {
		timersMenuDelegate.showTimersClicked()
	}
}
