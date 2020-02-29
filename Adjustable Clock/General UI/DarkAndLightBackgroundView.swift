//
//  DarkAndLightBackgroundView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/18/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class DarkAndLightBackgroundView: NSView, BackgroundColorView {
	var backgroundColor=NSColor.systemGray
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		self.wantsLayer=true
					var backgroundColorCopy=NSColor.labelColor
					if hasDarkAppearance && backgroundColor != NSColor.labelColor {
						//backgroundColorCopy=backgroundColor.blended(withFraction: 0.5, of: NSColor.black) ?? NSColor.white
						layer?.backgroundColor=backgroundColor.cgColor
					} else if !hasDarkAppearance && backgroundColor != NSColor.labelColor {
						layer?.backgroundColor=backgroundColor.cgColor
					} else {
						backgroundColor=NSColor.black
						backgroundColor.setFill()
					}
		}
}
