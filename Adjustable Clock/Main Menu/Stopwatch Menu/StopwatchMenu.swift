//
//  StopwatchMenu.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/20/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Cocoa
class StopwatchMenu: NSMenu {
	weak var stopwatchMenuDelegate: StopwatchMenuDelegate!
	@IBOutlet weak var activeStopwatchMenuItem: NSMenuItem!
	@IBOutlet weak var stopwatchFloatsMenuItem: NSMenuItem!
	@IBOutlet weak var exportLapsMenuItem: NSMenuItem!
	@IBAction func toggleFloatsOnTop(nsMenuItem: NSMenuItem) {
		stopwatchMenuDelegate.toggleStopwatchFloatsClicked()
	}
	@IBAction func showStopwatch(nsMenuItem: NSMenuItem) {
		stopwatchMenuDelegate.showStopwatchClicked()
	}
	@IBAction func exportLapsToCsvFile(nsMenuItem: NSMenuItem) {
		stopwatchMenuDelegate.exportLapsToCsvClicked()
	}
}
