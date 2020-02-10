//
//  TimersMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Foundation

class TimersMenuController: TimerMenuDelegate {
	var menu: TimersMenu
	init(menu: TimersMenu) {
		self.menu=menu
		menu.timersMenuDelegate=self
		updateClockMenuUI()
	}
	func showTimerOneClicked() {
		
	}
	
	func showTimerTwoClicked() {
		
	}
	
	func showTimerThreeClicked() {
		
	}
	
	func showTimersClicked() {
		TimersWindowController.timersObject.showTimers()
	}
}
