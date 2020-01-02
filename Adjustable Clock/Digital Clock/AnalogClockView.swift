//
//  AnalogClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/28/19.
//  Copyright © 2019 Celeritas Apps. All rights reserved.
//
import Cocoa
class AnalogClockView: NSView {
	@IBOutlet weak var twelfthLabel: NSTextField!
	@IBOutlet weak var myConstraint : NSLayoutConstraint!
	@IBOutlet weak var funView: NSView!
	@IBOutlet weak var myConstraint1 : NSLayoutConstraint!
	@IBOutlet weak var myConstraint2 : NSLayoutConstraint!
	
	var color=NSColor.labelColor
	var done=false
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		funView.wantsLayer=true
		funView.layer?.backgroundColor=NSColor.blue.cgColor
		let origin=CGPoint(x: frame.width*0.05, y: frame.height*0.05)
		let path=NSBezierPath(ovalIn: NSRect(origin: origin, size: CGSize(width: frame.width*0.9, height: frame.height*0.9)))
		color.setStroke()
		path.lineWidth=CGFloat(frame.width/150+1)
		path.stroke()
		guard let cgContext=NSGraphicsContext.current?.cgContext else {
				return
		}
		var numHours=12
		if ClockPreferencesStorage.sharedInstance.use24hourClock {
			numHours=24
		}
		for hour in 0...numHours {
			drawDash(cgContext: cgContext, angle: CGFloat(2*Double.pi*Double(hour)/Double(numHours)), startProportion: 0)
		}
		for minute in 0...60 {
			drawDash(cgContext: cgContext, angle: CGFloat(2*Double.pi*Double(minute)/60), startProportion: 0.6)
		}
		self.myConstraint.constant = frame.width/2
		//if(!done){
			//self.twelfthLabel.scaleUnitSquare(to: NSSize(width: frame.width/(twelfthLabel.bounds.width*5), height: frame.width/(twelfthLabel.bounds.width*5)))
		//twelfthLabel.setBoundsSize(NSSize(width: 2, height: 2))
			done=true
		//}
		let rect=NSRect(origin: CGPoint(x: frame.width/2, y:self.twelfthLabel.bounds.width/2), size: CGSize(width: frame.width/2, height: frame.height/2))
		self.twelfthLabel.bounds=rect
		twelfthLabel.scaleUnitSquare(to: NSSize(width: frame.width/100, height: frame.width/100))
		twelfthLabel.setNeedsDisplay(rect)
		self.myConstraint1.constant = frame.width
		self.myConstraint2.constant = frame.height
		//twelfthLabel.layout()
		//self.funView.layout()
		//funView.heightAnchor.constraint(equalToConstant: frame.height/2)
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
