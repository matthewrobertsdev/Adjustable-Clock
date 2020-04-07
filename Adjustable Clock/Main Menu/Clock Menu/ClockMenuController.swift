//
//  ClockMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/20/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class ClockMenuController: ClockMenuDelegate {
    let clockPreferences=ClockPreferencesStorage.sharedInstance
	var menu: ClockMenu
	init(menu: ClockMenu) {
		self.menu=menu
		menu.clockMenuDelegate=self
		updateUserInterface()
	}
	func useDigitalClicked() {
		clockPreferences.changeAndSaveUseDigital()
		//ClockWindowController.clockObject.showClock()
		updateUserInterface()
	}
	func useAnalogClicked() {
		clockPreferences.changeAndSaveUseAnalog()
		//ClockWindowController.clockObject.showClock()
		updateUserInterface()
	}
	func floatClicked() {
		clockPreferences.changeAndSaveClockFloats()
        updateForPreferencesChange()
	}
	func showSecondsClicked() {
		clockPreferences.changeAndSaveUseSeconds()
        updateForPreferencesChange()
	}
	func showDateClicked() {
		clockPreferences.changeAndSaveShowDate()
        updateForPreferencesChange()
	}
	func showDayOfWeekClicked() {
		clockPreferences.changeAndSaveShowDofW()
        updateForPreferencesChange()
	}
	func useNumericalClicked() {
		clockPreferences.changeAndSaveUseNumericalDate()
        updateForPreferencesChange()
	}
	func showClockClicked() {
		//ClockWindowController.clockObject.showClock()
	}
	func updateForPreferencesChange() {
        updateUserInterface()
		//ClockWindowController.clockObject.updateClockToPreferencesChange()
    }
	func updateUserInterface() {
        if clockPreferences.fullscreen {
			menu.clockFloatsMenuItem.isEnabled=false
        } else {
            menu.clockFloatsMenuItem.isEnabled=true
        }
        if clockPreferences.clockFloats {
            menu.clockFloatsMenuItem.state=NSControl.StateValue.on
        } else {
			menu.clockFloatsMenuItem.state=NSControl.StateValue.off
        }
		if ClockPreferencesStorage.sharedInstance.useAnalog {
            menu.analogMenuItem.state=NSControl.StateValue.on
			menu.digitalMenuItem.state=NSControl.StateValue.off
        } else {
			menu.analogMenuItem.state=NSControl.StateValue.off
            menu.digitalMenuItem.state=NSControl.StateValue.on
        }
        if ClockPreferencesStorage.sharedInstance.showSeconds {
            menu.showSecondsMenuItem.state=NSControl.StateValue.on
        } else {
            menu.showSecondsMenuItem.state=NSControl.StateValue.off
        }
        if clockPreferences.showDate {
            menu.showDateMenuItem.state=NSControl.StateValue.on
            menu.useNumericalDateMenuItem.isEnabled=true
        } else {
            menu.showDateMenuItem.state=NSControl.StateValue.off
            menu.useNumericalDateMenuItem.isEnabled=false
        }
        if clockPreferences.showDayOfWeek {
            menu.showDayOfWeekMenuItem.state=NSControl.StateValue.on
        } else {
            menu.showDayOfWeekMenuItem.state=NSControl.StateValue.off
        }
        if clockPreferences.useNumericalDate {
            menu.useNumericalDateMenuItem.state=NSControl.StateValue.on
        } else {
            menu.useNumericalDateMenuItem.state=NSControl.StateValue.off
        }
    }
	func enableMenu(enabled: Bool) {
        menu.autoenablesItems=false
        menu.clockFloatsMenuItem.isEnabled=enabled
		menu.digitalMenuItem.isEnabled=enabled
		menu.analogMenuItem.isEnabled=enabled
        menu.showSecondsMenuItem.isEnabled=enabled
        menu.showDateMenuItem.isEnabled=enabled
		if clockPreferences.showDate {
            menu.useNumericalDateMenuItem.isEnabled=enabled
        } else {
            menu.useNumericalDateMenuItem.isEnabled=false
        }
		menu.showDayOfWeekMenuItem.isEnabled=enabled
    }
}
