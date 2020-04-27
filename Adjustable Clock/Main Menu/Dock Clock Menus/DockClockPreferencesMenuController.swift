//
//  GeneralMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/29/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class DockClockPreferencesMenuController: DockClockMenuDelegate {
	var menu: DockClockPreferencesMenu
	let preferences=GeneralPreferencesStorage.sharedInstance
	init(menu: DockClockPreferencesMenu) {
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
			break
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
		updateDockClockMenu()
		preferences.updateModelToPreferences()
		DockClockController.dockClockObject.updateModelToPreferencesChange()
		DockClockController.dockClockObject.updateClockForPreferencesChange()
	}
	func updateDockClockMenu() {
		guard let appObject=NSApp.delegate as? AppDelegate else {
			return
		}
		appObject.dockClockMenuController?.updateUI()
	}
}
