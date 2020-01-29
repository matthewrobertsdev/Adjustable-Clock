//
//  GenericTableCellView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/24/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class GenericTableCellView: NSTableCellView {
	@IBOutlet weak var genericTextField: NSTextField!
	override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
	}
}
