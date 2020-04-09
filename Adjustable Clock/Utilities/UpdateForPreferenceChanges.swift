//
//  UpdateForPrenerfenceChanges.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 4/8/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

func updateClock() {
	if let app=NSApp.delegate as? AppDelegate {
		app.showClock()
		if let viewController=app.clockWindowController?.contentViewController as? ClockViewController {
			viewController.updateClock()
		}
	}
}
