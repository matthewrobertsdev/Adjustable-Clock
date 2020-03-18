//
//  TimersMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class TimersMenuController: TimerMenuDelegate {
	var menu: TimersMenu
	init(menu: TimersMenu) {
		self.menu=menu
		menu.timersMenuDelegate=self
		updateUI()
	}
	func updateUI(){
		if TimersPreferenceStorage.sharedInstance.asSeconds {
			menu.asSecondsMenuItem.state=NSControl.StateValue.on
		} else {
			menu.asSecondsMenuItem.state=NSControl.StateValue.off
		}
	}
	func asSecondsClicked() {
		TimersPreferenceStorage.sharedInstance.setAsSeconds()
		updateUI()
		TimersWindowController.timersObject.update()
	}
	func showTimerOneClicked() {
		showTimer(index: 0)
	}
	func showTimerTwoClicked() {
		showTimer(index: 1)
	}
	func showTimerThreeClicked() {
		showTimer(index: 2)
	}
	func showTimer(index: Int) {
		TimersWindowController.timersObject.showTimers()
		let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.timersWindow {
			if let timersViewController=window.contentViewController as? TimersViewController {
				timersViewController.scrollToTimer(index: index)
            }
        }
	}
	func showTimersClicked() {
		TimersWindowController.timersObject.showTimers()
	}
}
