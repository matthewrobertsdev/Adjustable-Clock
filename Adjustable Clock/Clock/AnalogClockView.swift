//
//  AnalogClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/28/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import Cocoa
class AnalogClockView: NSView {
	var labels=[NSTextField]()
	var color=NSColor.labelColor
	var widthConstraint: NSLayoutConstraint!
	let minuteLayer = CAShapeLayer()
	override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setUp()
    }
    private func setUp() {
		wantsLayer=true
		for index in 0...11 {
			let textField=NSTextField(labelWithString: String(12-index))
			setUpLabel(label: textField)
		}
		widthConstraint=NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 237)
		NSLayoutConstraint.activate([
		widthConstraint
		])
		positionLabels()
		addMinuteHand()
		let lineWidth=frame.width/100
		//minuteLayer.transform=CATransform3DMakeRotation(CGFloat(Double.pi), bounds.midX, bounds.midY, 1)
    }
	func setMinuteHand(radians: CGFloat) {
		minuteLayer.transform=CATransform3DMakeRotation(CGFloat(radians), 0, 0, 1)
	}
	private func positionLabels() {
		for index in 0...11 {
			positionLabel(label: labels[index], twelfth: Double(index))
		}
	}
	private func positionLabel(label: NSTextField, twelfth: Double) {
		let firstConstant=bounds.size.height*(0.5-(0.35*CGFloat(sin(Double.pi/6*twelfth+Double.pi/2))))
		let secondConstant = -bounds.size.height*(0.5-(0.35*CGFloat(cos(Double.pi/6*twelfth+Double.pi/2))))
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: firstConstant),
			NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: secondConstant)
		])
	}
	private func setUpLabel(label: NSTextField) {
		label.font=NSFont.systemFont(ofSize: 20)
		label.translatesAutoresizingMaskIntoConstraints = false
		addSubview(label)
		label.sizeToFit()
		labels.append(label)
	}
	private func addMinuteHand() {
		minuteLayer.frame = bounds
		let minuteHand = CGMutablePath()
		let lineWidth=frame.width/100
		minuteHand.move(to: CGPoint(x: bounds.midX-lineWidth/2, y: bounds.midY-lineWidth/2))
		minuteHand.addLine(to: CGPoint(x: bounds.midX-lineWidth/2, y: bounds.height*0.9-lineWidth/2))
		minuteLayer.path = minuteHand
		minuteLayer.lineWidth = lineWidth
		minuteLayer.lineCap = CAShapeLayerLineCap.round
		layer?.addSublayer(minuteLayer)
	}
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		for label in labels { label.textColor=color }
		minuteLayer.strokeColor=color.cgColor
		let origin=CGPoint(x: bounds.width*0.05, y: bounds.height*0.05)
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
