//
//  DockClockMenuController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 4/25/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
class DockClockMenuController: DockClockMenuDelegate {
	var menu: DockClockMenu
	let preferences=GeneralPreferencesStorage.sharedInstance
	init(menu: DockClockMenu) {
		self.menu=menu
		menu.dockClockMenuDelegate=self
		updateUI()
	}
	func updateUI() {
		menu.analogNoSecondsMenuItem.state=NSControl.StateValue.off
		menu.analogWithSecondsMenuItem.state=NSControl.StateValue.off
		menu.digitalNoSecondsMenuItem.state=NSControl.StateValue.off
		menu.digitalWithSecondsMenuItem.state=NSControl.StateValue.off
		switch preferences.dockClock {
		case preferences.useAnalogNoSeconds:
			menu.analogNoSecondsMenuItem.state=NSControl.StateValue.on
		case preferences.useAnalogWithSeconds:
			menu.analogWithSecondsMenuItem.state=NSControl.StateValue.on
		case preferences.useDigitalNoSeconds:
			menu.digitalNoSecondsMenuItem.state=NSControl.StateValue.on
		case preferences.useDigitalWithSeconds:
			menu.digitalWithSecondsMenuItem.state=NSControl.StateValue.on
		default:
			menu.analogNoSecondsMenuItem.state=NSControl.StateValue.on
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
	func updateDockClockChoice() {
		updateUI()
		updateDockClockPreferencesMenu()
		preferences.updateModelToPreferences()
		DockClockController.dockClockObject.updateModelToPreferencesChange()
		DockClockController.dockClockObject.updateClockForPreferencesChange()
	}
	func updateDockClockPreferencesMenu() {
		guard let appObject=NSApp.delegate as? AppDelegate else {
			return
		}
		appObject.dockClockPreferencesController?.updateUI()
	}
}
