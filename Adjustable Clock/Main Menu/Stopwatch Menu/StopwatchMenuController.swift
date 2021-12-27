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
}
