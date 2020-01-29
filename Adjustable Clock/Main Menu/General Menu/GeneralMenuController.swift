//
//  GeneralMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/29/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class GeneralMenuController: NSObject, GeneralMenuDelegate {
	var menu: GeneralMenu
	@objc var objectToObserve=AlarmCenter.sharedInstance
	var observation: NSKeyValueObservation?
	init(menu: GeneralMenu) {
		self.menu=menu
		super.init()
		menu.generalMenuDelegate=self
		observation = observe(
			\.objectToObserve.count,
            options: []
        ) { _, change in
			self.showPreventsSleep()
		}
		updateUI()
	}
	func use24HoursClicked() {
		ClockPreferencesStorage.sharedInstance.changeAndSaveUseAmPM()
		ClockWindowController.clockObject.updateClockToPreferencesChange()
		updateUI()
	}
	func updateUI() {
		if ClockPreferencesStorage.sharedInstance.use24hourClock {
			menu.use24HoursMenuItem.state=NSControl.StateValue.on
		} else {
			menu.use24HoursMenuItem.state=NSControl.StateValue.off
		}
		menu.preventingSleepMenuItem.isEnabled=false
		showPreventsSleep()
	}
	func showPreventsSleep(){
		if AlarmCenter.sharedInstance.count>0 {
			menu.preventingSleepMenuItem.title="Preventing Sleep"
		} else {
			menu.preventingSleepMenuItem.title="Can Sleep"
		}
	}
}