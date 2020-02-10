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
	@IBAction func showTimerNumber1(nsMenuItem: NSMenuItem) {
		timersMenuDelegate.showTimerOneClicked()
	}
	@IBAction func showTimerNumber2(nsMenuItem: NSMenuItem) {
		timersMenuDelegate.showTimerTwoClicked()
	}
	@IBAction func showTimerNumber3(nsMenuItem: NSMenuItem) {
		timersMenuDelegate.showTimerThreeClicked()
	}
	@IBAction func showTimers(nsMenuItem: NSMenuItem) {
		timersMenuDelegate.showTimersClicked()
	}
}
