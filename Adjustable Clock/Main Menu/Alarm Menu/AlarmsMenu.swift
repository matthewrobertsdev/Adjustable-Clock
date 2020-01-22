//
//  AlarmsMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/20/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class AlarmsMenu: NSMenu {
	var alarmMenuDelegate: AlarmMenuDelegate!
	@IBAction func showAlarms(nsMenuItem: NSMenuItem){
		alarmMenuDelegate.showAlarmsClicked()
	}
}