//
//  ClockMenuController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 9/30/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import AppKit

class ClocksMenuController: ClocksMenuDelegate {
    var menu: ClocksMenu
    init(menu: ClocksMenu) {
        self.menu=menu
        menu.autoenablesItems=false
        menu.clocksMenuDelegate=self
    }
    
    func showClockClicked() {
        ClockWindowController.clockObject.showClock()
    }
}
