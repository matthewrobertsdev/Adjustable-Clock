//
//  MagnifierScrollView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/9/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class MagnifierScrollView: NSScrollView {
	
	override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
	override func scrollWheel(with event: NSEvent) {
		
	}
}
