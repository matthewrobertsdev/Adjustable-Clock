//
//  AnalogClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/28/19.
//  Copyright © 2019 Celeritas Apps. All rights reserved.
//
import Cocoa
class AnalogClockView: NSView {
	var color=NSColor.labelColor
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		let origin=CGPoint(x: frame.width*0.05, y: frame.height*0.05)
		let path=NSBezierPath(ovalIn: NSRect(origin: origin, size: CGSize(width: frame.width*0.9, height: frame.height*0.9)))
		color.setStroke()
		path.lineWidth=CGFloat(frame.width/150)
		path.stroke()
    }
}
