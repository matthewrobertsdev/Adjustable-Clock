//
//  DarkAndLightBackgroundView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/18/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class DarkAndLightBackgroundView: NSView {
	var contrastColor=NSColor.systemGray
	@objc dynamic var dark=false
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		if hasDarkAppearance && dark==false {
			dark=true
		} else if !hasDarkAppearance && dark==true {
			dark=false
		}
		self.wantsLayer=true
					var backgroundColorCopy=NSColor.labelColor
					if hasDarkAppearance && contrastColor != NSColor.labelColor {
						backgroundColorCopy=contrastColor.blended(withFraction: 0.5, of: NSColor.black) ?? NSColor.white
						layer?.backgroundColor=backgroundColorCopy.cgColor
					} else if !hasDarkAppearance && contrastColor != NSColor.labelColor {
						layer?.backgroundColor=contrastColor.cgColor
					} else {
						backgroundColorCopy=NSColor.black
						backgroundColorCopy.setFill()
					}
		}
}
