//
//  AlarmMenuContrroller.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/21/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class AlarmsMenuController: AlarmMenuDelegate {
	let clockPreferences=ClockPreferencesStorage.sharedInstance
	var menu: AlarmsMenu
	init(menu: AlarmsMenu) {
		self.menu=menu
		menu.alarmMenuDelegate=self
		updateClockMenuUI()
	}
	func addAlarmClicked() {
		//AlarmsWindowController.alarmsObject.showAlarms()
		/*guard let alarmsViewController=AlarmsWindowController.alarmsObject.contentViewController as? AlarmsViewController else {
			return
		}
		alarmsViewController.showAddAlarmViewController()*/
		EditableAlarmWindowController.newAlarmConfigurer.showNewAlarmConfigurer()
	}
	func showAlarmsClicked() {
		AlarmsWindowController.alarmsObject.showAlarms()
	}
}
