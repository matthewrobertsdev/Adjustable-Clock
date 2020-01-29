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
		//let origin=CGPoint(x: 0, y: 0)
		//let path=NSBezierPath(roundedRect: NSRect(origin: origin, size: CGSize(width: frame.size.width, height: frame.size.height)), xRadius: 0, yRadius: 0)
					var backgroundColorCopy=NSColor.labelColor
					if hasDarkAppearance && contrastColor != NSColor.labelColor {
						backgroundColorCopy=contrastColor.blended(withFraction: 0.5, of: NSColor.black) ?? NSColor.white
						//backgroundColorCopy.setFill()
						layer?.backgroundColor=backgroundColorCopy.cgColor
					} else if !hasDarkAppearance && contrastColor != NSColor.labelColor {
						//contrastColor.setFill()
						layer?.backgroundColor=contrastColor.cgColor
					} else {
						backgroundColorCopy=NSColor.black
						backgroundColorCopy.setFill()
					}
					//path.fill()
		}
}
