//
//  AlarmStatusTableCellView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import Cocoa

class AlarmStatusTableCellView: NSTableCellView {
	@IBOutlet weak var alarmStatusSegmentedControl: NSSegmentedControl!
	override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
}
