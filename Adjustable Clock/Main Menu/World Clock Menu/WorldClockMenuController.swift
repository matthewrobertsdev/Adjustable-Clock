//
//  WorldClockMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/13/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class WorldClockMenuController: WorldClockMenuDelegate {
	var menu: WorldClockMenu
	init(menu: WorldClockMenu) {
		self.menu=menu
		menu.worldClockMenuDelegate=self
		updateClockMenuUI()
	}
	func showWorldClockClicked() {
		WorldClockWindowController.worldClockObject.showWorldClock()
	}
}
