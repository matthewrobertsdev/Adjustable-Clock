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
	let preferences=GeneralPreferencesStorage.sharedInstance
	@objc var objectToObserve=AlarmCenter.sharedInstance
	var observation: NSKeyValueObservation?
	init(menu: GeneralMenu) {
		self.menu=menu
		super.init()
		menu.generalMenuDelegate=self
		observation = observe(
			\.objectToObserve.activeAlarms,
            options: []
        ) { _, _ in
			self.showPreventsSleep()
		}
		updateUI()
	}
	func use24HoursClicked() {
		GeneralPreferencesStorage.sharedInstance.changeAndSaveUseAmPM()
		ClockWindowController.clockObject.updateClockToPreferencesChange()
		DockClockController.dockClockObject.updateModelToPreferencesChange()
		updateUI()
	}
	func updateUI() {
		if preferences.use24Hours {
			menu.use24HoursMenuItem.state=NSControl.StateValue.on
		} else {
			menu.use24HoursMenuItem.state=NSControl.StateValue.off
		}
		menu.preventingSleepMenuItem.isEnabled=false
		showPreventsSleep()
		menu.analogNoSecondsMenuItem.state=NSControl.StateValue.off
		menu.analogWithSecondsMenuItem.state=NSControl.StateValue.off
		menu.digitalNoSecondsMenuItem.state=NSControl.StateValue.off
		menu.digitalWithSecondsMenuItem.state=NSControl.StateValue.off
		menu.justColorsMenuItem.state=NSControl.StateValue.off
		switch preferences.dockClock {
		case preferences.useAnalogNoSeconds:
			menu.analogNoSecondsMenuItem.state=NSControl.StateValue.on
		case preferences.useAnalogWithSeconds:
			menu.analogWithSecondsMenuItem.state=NSControl.StateValue.on
		case preferences.useDigitalNoSeconds:
			menu.digitalNoSecondsMenuItem.state=NSControl.StateValue.on
		case preferences.useDigitalWithSeconds:
			menu.digitalWithSecondsMenuItem.state=NSControl.StateValue.on
		case preferences.useJustColors:
			menu.justColorsMenuItem.state=NSControl.StateValue.on
		default:
			break
		}
	}
	func showPreventsSleep() {
		if AlarmCenter.sharedInstance.activeAlarms>0 {
			menu.preventingSleepMenuItem.title="Preventing Sleep"
		} else {
			menu.preventingSleepMenuItem.title="Can Sleep"
		}
	}
	func analogClockNoSecondsClicked() {
		preferences.updateDockClockPreferences(mode: preferences.useAnalogNoSeconds)
		updateDockClockChoice()
	}
	func analogClockWithSecondsClicked() {
		preferences.updateDockClockPreferences(mode: preferences.useAnalogWithSeconds)
		updateDockClockChoice()
	}
	func digitalClockNoSecondsClicked() {
		preferences.updateDockClockPreferences(mode: preferences.useDigitalNoSeconds)
		updateDockClockChoice()
	}
	func digitalClockWithSecondsClicked() {
		preferences.updateDockClockPreferences(mode: preferences.useDigitalWithSeconds)
		updateDockClockChoice()
	}
	func justColorsClicked() {
		preferences.updateDockClockPreferences(mode: preferences.useJustColors)
		updateDockClockChoice()
	}
	func updateDockClockChoice() {
		updateUI()
		preferences.updateModelToPreferences()
		DockClockController.dockClockObject.updateModelToPreferencesChange()
		DockClockController.dockClockObject.updateClockForPreferencesChange()
	}
}
