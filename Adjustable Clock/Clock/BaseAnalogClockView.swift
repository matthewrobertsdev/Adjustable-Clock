//
//  BaseAnalogClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/12/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class BaseAnalogClockView: NSView, ColorView {
	var color=NSColor.labelColor
	var lineWidth=CGFloat(10)
	func drawDash(cgContext: CGContext, angle: CGFloat, start: CGFloat, startProportion: CGFloat, end: CGFloat) {
		let line = CGMutablePath()
		let xStart=cos(angle)*frame.width*(start+(startProportion*0.05))+frame.width/2
		let yStart=sin(angle)*frame.height*(start+(startProportion*0.05))+frame.height/2
		line.move(to: CGPoint(x: xStart, y: yStart))
		let xEnd=cos(angle)*frame.width*end+frame.width/2
		let yEnd=sin(angle)*frame.height*end+frame.height/2
		line.addLine(to: CGPoint(x: xEnd, y: yEnd))
		line.closeSubpath()
		cgContext.addPath(line)
		cgContext.setStrokeColor(color.cgColor)
		cgContext.setLineWidth(lineWidth)
		cgContext.strokePath()
	}
}
