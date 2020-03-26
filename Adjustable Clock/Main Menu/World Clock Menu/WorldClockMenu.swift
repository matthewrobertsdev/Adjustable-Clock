//
//  WorldClockMenu.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/13/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class WorldClockMenu: NSMenu {
	weak var worldClockMenuDelegate: WorldClockMenuDelegate!
	@IBAction func showWorldClockClciked(nsMenuItem: NSMenuItem) {
		worldClockMenuDelegate.showWorldClockClicked()
	}
}
