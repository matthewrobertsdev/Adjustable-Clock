//
//  InterfaceChangedView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 4/6/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class InterfaceChangedView: NSView {
	
	@objc dynamic var dark=true

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
}
