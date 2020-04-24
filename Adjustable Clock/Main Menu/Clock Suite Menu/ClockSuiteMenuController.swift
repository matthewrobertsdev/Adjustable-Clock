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
		NotificationCenter.default.addObserver(self, selector: #selector(showStatus),
											   name: NSNotification.Name.activeCountChanged, object: nil)
		showStatus()
	}
	@objc func showStatus() {
		showPreventsSleep()
		showActiveAlarms()
		showActiveTimers()
	}
	@objc func showActiveAlarms() {
		if AlarmCenter.sharedInstance.activeAlarms==0 {
			menu.activeAlarmsMenuItem.title="0 Alarms Active"
		} else if AlarmCenter.sharedInstance.activeAlarms==1 {
			menu.activeAlarmsMenuItem.title="1 Alarm Active"
		} else if AlarmCenter.sharedInstance.activeAlarms>1 {
			menu.activeAlarmsMenuItem.title="\(AlarmCenter.sharedInstance.activeAlarms) Alarms Active"
		}
	}
	@objc func showActiveTimers() {
		if TimersCenter.sharedInstance.activeTimers==0 {
			menu.activeTimersMenuItem.title="0 Timers Active"
		} else if TimersCenter.sharedInstance.activeTimers==1 {
			menu.activeTimersMenuItem.title="1 Timer Active"
		} else if TimersCenter.sharedInstance.activeTimers>1 {
			menu.activeTimersMenuItem.title="\(TimersCenter.sharedInstance.activeTimers) Timers Active"
		}
	}
	@objc func showPreventsSleep() {
		if AlarmCenter.sharedInstance.activeAlarms>0||TimersCenter.sharedInstance.activeTimers>0 {
			menu.canSleepMenuItem.title="Preventing Sleep"
		} else {
			menu.canSleepMenuItem.title="Can Sleep"
		}
	}
}
