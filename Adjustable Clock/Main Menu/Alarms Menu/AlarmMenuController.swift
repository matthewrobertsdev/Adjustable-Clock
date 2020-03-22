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
		updateClockMenuUI()
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
