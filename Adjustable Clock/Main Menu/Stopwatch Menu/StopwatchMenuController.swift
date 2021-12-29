//
//  StopwatchMenuController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/20/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import AppKit
class StopwatchMenuController: StopwatchMenuDelegate {
	var stopwatchMenu: StopwatchMenu
	init(menu: StopwatchMenu) {
		stopwatchMenu=menu
		stopwatchMenu.autoenablesItems=false
		stopwatchMenu.stopwatchMenuDelegate=self
		updateUI()
		NotificationCenter.default.addObserver(self, selector: #selector(showStopwatchStatus),
											   name: NSNotification.Name.activeCountChanged, object: nil)
		showStopwatchStatus()
	}
	func updateUI() {
		if StopwatchPreferencesStorage.sharedInstance.stopwatchFloats {
			stopwatchMenu.stopwatchFloatsMenuItem.state = .on
		} else {
			stopwatchMenu.stopwatchFloatsMenuItem.state = .off
		}
	}
	func showStopwatchClicked() {
		StopwatchWindowController.stopwatchObject.showStopwatch()
	}
	func toggleStopwatchFloatsClicked() {
		StopwatchPreferencesStorage.sharedInstance.toggleStopwatchFloats()
		updateUI()
		StopwatchWindowController.stopwatchObject.applyFloatState()
	}
	func exportLapsToCsvClicked() {
		StopwatchWindowController.stopwatchObject.showStopwatch()
		if let stopwatchViewController=StopwatchWindowController.stopwatchObject.contentViewController as? StopwatchViewController {
			stopwatchViewController.exportLapsToCsvFile()
		}
	}
	func enableMenu(enabled: Bool) {
		stopwatchMenu.stopwatchFloatsMenuItem.isEnabled=enabled
		stopwatchMenu.exportLapsMenuItem.isEnabled=enabled
	}
	@objc func showStopwatchStatus() {
		if StopwatchCenter.sharedInstance.active {
			stopwatchMenu.activeStopwatchMenuItem.title="Stopwatch Active"
		} else {
			stopwatchMenu.activeStopwatchMenuItem.title="Stopwatch Inactive"
		}
	}
}
