//
//  ClockSuiteMenuDelegate.swift
//  Clock Suite
//
//  Created by Matt Roberts on 4/24/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Foundation
class ClockSuiteMenuController {
	var menu: ClockSuiteMenu
	init(menu: ClockSuiteMenu) {
		self.menu=menu
		NotificationCenter.default.addObserver(self, selector: #selector(showPreventsSleep),
											   name: NSNotification.Name.activeCountChanged, object: nil)
		showPreventsSleep()
	}
	@objc func showPreventsSleep() {
		if AlarmCenter.sharedInstance.activeAlarms>0||TimersCenter.sharedInstance.activeTimers>0 {
			menu.canSleepMenuItem.title="Preventing Sleep"
		} else {
			menu.canSleepMenuItem.title="Can Sleep"
		}
	}
}
