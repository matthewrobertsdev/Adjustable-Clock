//
//  UpdateForPrenerfenceChanges.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 4/8/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
func updateClock() {
	if let app=NSApp.delegate as? AppDelegate {
		if let viewController=app.clockWindowController?.contentViewController as? ClockViewController {
			viewController.updateClock()
		}
	}
}
func showClock() {
	if let app=NSApp.delegate as? AppDelegate {
		app.showClock()
	}
}
func enableClockMenu(enabled: Bool) {
	guard let appDelagte = NSApplication.shared.delegate as? AppDelegate else {
		return
	}
	appDelagte.clockMenuController?.enableMenu(enabled: enabled)
}
