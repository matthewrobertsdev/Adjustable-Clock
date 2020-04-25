//
//  DockClockMenu.swift
//  Clock Suite
//
//  Created by Matt Roberts on 4/24/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import Cocoa

class DockClockMenu: NSMenu {
	weak var dockClockMenuDelegate: DockClockMenuDelegate!
	@IBOutlet weak var analogNoSecondsMenuItem: NSMenuItem!
	@IBOutlet weak var analogWithSecondsMenuItem: NSMenuItem!
	@IBOutlet weak var digitalNoSecondsMenuItem: NSMenuItem!
	@IBOutlet weak var digitalWithSecondsMenuItem: NSMenuItem!
	@IBAction func useAnalogNoSeconds(nsMenuItem: NSMenuItem) {
		dockClockMenuDelegate.analogClockNoSecondsClicked()
	}
	@IBAction func useAnalogWithSeconds(nsMenuItem: NSMenuItem) {
		dockClockMenuDelegate.analogClockWithSecondsClicked()
	}
	@IBAction func useDigitalNoSeconds(nsMenuItem: NSMenuItem) {
		dockClockMenuDelegate.digitalClockNoSecondsClicked()
	}
	@IBAction func useDigitalWithSeconds(nsMenuItem: NSMenuItem) {
		dockClockMenuDelegate.digitalClockWithSecondsClicked()
	}
}
