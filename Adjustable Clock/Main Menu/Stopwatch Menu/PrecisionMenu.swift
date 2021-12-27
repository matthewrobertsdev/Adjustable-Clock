//
//  PrecisionMenu.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/26/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Cocoa

class PrecisionMenu: NSMenu {
	weak var precisionMenuDelegate: PrecisionMenuDelegate!
	@IBOutlet weak var secondsPrecisionMenuItem: NSMenuItem!
	@IBOutlet weak var tenthsOfSecondsPrecisionMenuItem: NSMenuItem!
	@IBAction func useSecondsPrecision(nsMenuItem: NSMenuItem) {
		precisionMenuDelegate.useSecondsClicked()
	}
	@IBAction func useTenthsOfSecondsPrecision(nsMenuItem: NSMenuItem) {
		precisionMenuDelegate.useTenthsOfSecondsClicked()
	}
}
