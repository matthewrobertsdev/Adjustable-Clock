//
//  AlarmMenuContrroller.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/21/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class AlarmsMenuController: AlarmMenuDelegate {
	var menu: AlarmsMenu
	init(menu: AlarmsMenu) {
		self.menu=menu
		menu.alarmMenuDelegate=self
		showActiveAlarms()
		NotificationCenter.default.addObserver(self, selector: #selector(showActiveAlarms),
		name: NSNotification.Name.activeCountChanged, object: nil)
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
	func addAlarmClicked() {
		if AlarmCenter.sharedInstance.count>=24 {
			let alert=NSAlert()
			alert.messageText="Sorry, but Clock Suite does not allow more than 24 alarms."
			alert.runModal()
		} else {
		EditableAlarmWindowController.newAlarmConfigurer.showNewAlarmConfigurer()
		}
	}
	func showAlarmsClicked() {
		AlarmsWindowController.alarmsObject.showAlarms()
	}
}
