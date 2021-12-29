//
//  PrecisionMenuController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/26/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Foundation
class PrecsionMenuController: PrecisionMenuDelegate {
	var precisionMenu: PrecisionMenu
	init(menu: PrecisionMenu) {
		precisionMenu=menu
		precisionMenu.autoenablesItems=false
		precisionMenu.precisionMenuDelegate=self
		updateUI()
	}
	func useSecondsClicked() {
		StopwatchPreferencesStorage.sharedInstance.setUseSecondsPrecision()
		updateForPreferencesChange()
	}
	func useTenthsOfSecondsClicked() {
		StopwatchPreferencesStorage.sharedInstance.setUseTenthsOfSecondsPrecision()
		updateForPreferencesChange()
	}
	func updateForPreferencesChange() {
		updateUI()
		StopwatchWindowController.stopwatchObject.updateForPreferencesChange()
	}
	func updateUI() {
		if StopwatchPreferencesStorage.sharedInstance.useSecondsPrecision {
			precisionMenu.secondsPrecisionMenuItem.state = .on
			precisionMenu.tenthsOfSecondsPrecisionMenuItem.state = .off
		} else {
			precisionMenu.secondsPrecisionMenuItem.state = .off
			precisionMenu.tenthsOfSecondsPrecisionMenuItem.state = .on
		}
	}
	func enableMenu(enabled: Bool) {
		precisionMenu.secondsPrecisionMenuItem.isEnabled=enabled
		precisionMenu.tenthsOfSecondsPrecisionMenuItem.isEnabled=enabled
	}
}
