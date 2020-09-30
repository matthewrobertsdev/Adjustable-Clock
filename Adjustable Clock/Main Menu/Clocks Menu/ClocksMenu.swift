//
//  ClocksMenu.swift
//  Clock Suite
//
//  Created by Matt Roberts on 9/30/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import Cocoa

class ClocksMenu: NSMenu {
    weak var clocksMenuDelegate: ClocksMenuDelegate!
    @IBOutlet weak var showClockMenuItem: NSMenuItem!
    @IBAction func showClock(nsMenuItem: NSMenuItem) {
        clocksMenuDelegate.showClockClicked()
    }
}
