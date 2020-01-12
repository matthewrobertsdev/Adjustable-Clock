//
//  DockClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/12/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class DockClockView: NSView {
	var color=NSColor.labelColor
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let origin=CGPoint(x: bounds.width*0.05, y: bounds.height*0.05)
		let path=NSBezierPath(ovalIn: NSRect(origin: origin, size: CGSize(width: frame.width*0.9, height: frame.height*0.9)))
		color.setStroke()
		path.lineWidth=CGFloat(frame.width/50)
		path.stroke()
		color.setFill()
		path.fill()
    }
}
