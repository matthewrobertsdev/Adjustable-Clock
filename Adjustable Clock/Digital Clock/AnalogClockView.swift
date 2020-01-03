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
		guard let cgContext=NSGraphicsContext.current?.cgContext else {
				return
		}
		for hour in 0...12 {
			drawDash(cgContext: cgContext, angle: CGFloat(2*Double.pi*Double(hour)/Double(12)), startProportion: 0)
		}
		for minute in 0...60 {
			drawDash(cgContext: cgContext, angle: CGFloat(2*Double.pi*Double(minute)/60), startProportion: 0.6)
		}
    }
	func drawDash(cgContext: CGContext, angle: CGFloat, startProportion: CGFloat) {
		let line = CGMutablePath()
		let xStart=cos(angle)*frame.width*(0.4+(startProportion*0.05))+frame.width/2
		let yStart=sin(angle)*frame.height*(0.4+(startProportion*0.05))+frame.height/2
		line.move(to: CGPoint(x: xStart, y: yStart))
		let xEnd=cos(angle)*frame.width*0.45+frame.width/2
		let yEnd=sin(angle)*frame.height*0.45+frame.height/2
		line.addLine(to: CGPoint(x: xEnd, y: yEnd))
		line.closeSubpath()
		cgContext.addPath(line)
		cgContext.setStrokeColor(color.cgColor)
		cgContext.setLineWidth(frame.width/150+1)
		cgContext.strokePath()
	}
}
