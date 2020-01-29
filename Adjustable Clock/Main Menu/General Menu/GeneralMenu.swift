//
//  GeneralMenu.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/29/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class GeneralMenu: NSMenu {
	weak var generalMenuDelegate: GeneralMenuDelegate!
	@IBOutlet weak var preventingSleepMenuItem: NSMenuItem!
	@IBOutlet weak var use24HoursMenuItem: NSMenuItem!
	@IBAction func use24Hour(nsMenuItem: NSMenuItem) {
		generalMenuDelegate.use24HoursClicked()
	}
}