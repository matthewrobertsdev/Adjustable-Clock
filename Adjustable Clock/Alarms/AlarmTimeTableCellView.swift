//
//  AlarmTimeTableCellView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class AlarmTimeTableCellView: NSTableCellView {
	@IBOutlet weak var alarmTimeTextField: NSTextField!
	@IBOutlet weak var alarmRepeatTextField: NSTextField!
	override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
}
