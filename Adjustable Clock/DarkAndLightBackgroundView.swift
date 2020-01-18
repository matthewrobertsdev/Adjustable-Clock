//
//  DarkAndLightBackgroundView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/18/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class DarkAndLightBackgroundView: NSView {

	var contrastColor=NSColor.clear
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		self.wantsLayer=true
				if hasDarkAppearance {
					if contrastColor==NSColor.white {
						contrastColor=NSColor.systemGray
					}
						self.layer?.backgroundColor=contrastColor.blended(withFraction: 0.5, of: NSColor.black)?.cgColor
				} else {
					self.layer?.backgroundColor=contrastColor.cgColor
				}
		}
}
