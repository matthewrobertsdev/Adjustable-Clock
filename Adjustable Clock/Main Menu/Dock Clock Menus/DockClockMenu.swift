//
//  DockClockMenu.swift
//  Clock Suite
//
//  Created by Matt Roberts on 4/25/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Cocoa
class DockClockMenu: NSMenu {
	weak var dockClockMenuDelegate: DockClockMenuDelegate!
	@IBOutlet weak var analogNoSecondsMenuItem: NSMenuItem!
	@IBOutlet weak var analogWithSecondsMenuItem: NSMenuItem!
	@IBOutlet weak var digitalNoSecondsMenuItem: NSMenuItem!
	@IBOutlet weak var digitalWithSecondsMenuItem: NSMenuItem!
	@IBAction func useAnalogWithoutSeconds(_ sender: Any) {
		dockClockMenuDelegate.analogClockNoSecondsClicked()

	}
	@IBAction func useAnalogWithSeconds(_ sender: Any) {
		dockClockMenuDelegate.analogClockWithSecondsClicked()

	}
	@IBAction func useDigitalWithoutSeconds(_ sender: Any) {
		dockClockMenuDelegate.digitalClockNoSecondsClicked()

	}
	@IBAction func useDigitalWithSeconds(_ sender: Any) {
		dockClockMenuDelegate.digitalClockWithSecondsClicked()

	}
}
