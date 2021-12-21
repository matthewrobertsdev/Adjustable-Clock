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
		stopwatchMenu.stopwatchMenuDelegate=self
	}
	func showStopwatchClicked() {
		StopwatchWindowController.stopwatchObject.showStopwatch()
	}
}
