//
//  AnalogClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/28/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import Cocoa
class AnalogClockView: BaseAnalogClockView {
	var hourLabels=[NSTextField]()
	var widthConstraint: NSLayoutConstraint!
	var hourLayer=CAShapeLayer()
	var minuteLayer=CAShapeLayer()
	var secondLayer=CAShapeLayer()
	var immutableBounds: NSRect!
	let amPmLabel=NSTextField(labelWithString: "")
	var worldClock=false
	override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setUp()
    }
    private func setUp() {
		lineWidth=CGFloat(frame.size.width/150+1)
		immutableBounds=bounds
		wantsLayer=true
		for index in 0...11 {
			let textField=NSTextField(labelWithString: String(12-index))
			setUpLabel(label: textField)
		}
		widthConstraint=NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 237)
		NSLayoutConstraint.activate([widthConstraint])
		positionLabels()
		amPmLabel.font=NSFont.systemFont(ofSize: 30)
		amPmLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(amPmLabel)
		let amPmXConstraint=NSLayoutConstraint(item: amPmLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
		let amPmYConstraint=NSLayoutConstraint(item: amPmLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: widthConstraint.constant*1.33)
		NSLayoutConstraint.activate([amPmXConstraint, amPmYConstraint])
    }
	func startHands(withSeconds: Bool) {
		clearHands()
		addHand(handLayer: hourLayer, lengthProportion: 0.75)
		addHand(handLayer: minuteLayer, lengthProportion: 0.8)
		if withSeconds {
			addHand(handLayer: secondLayer, lengthProportion: 0.7)
		}
	}
	func clearHands() {
		hourLayer.removeFromSuperlayer()
		hourLayer=CAShapeLayer()
		minuteLayer.removeFromSuperlayer()
		minuteLayer=CAShapeLayer()
		secondLayer.removeFromSuperlayer()
		secondLayer=CAShapeLayer()
	}
	func setHourHand(radians: CGFloat) {
		hourLayer.transform=CATransform3DMakeRotation(CGFloat(radians), 0, 0, 1)
	}
	func setMinuteHand(radians: CGFloat) {
		minuteLayer.transform=CATransform3DMakeRotation(CGFloat(radians), 0, 0, 1)
	}
	func setSecondHand(radians: CGFloat) {
		secondLayer.transform=CATransform3DMakeRotation(CGFloat(radians), 0, 0, 1)
	}
	func positionLabels() {
		for index in 0...11 {
			positionLabel(label: hourLabels[index], twelfth: Double(index))
		}
	}
	private func positionLabel(label: NSTextField, twelfth: Double) {
		var multiplier: CGFloat=2.0
		if worldClock {
			multiplier=1
		}
		let heightMultiplier=(0.5-(0.34*CGFloat(sin(Double.pi/6*twelfth+Double.pi/2)))-0.01)
		let firstConstant=widthConstraint.constant*multiplier*heightMultiplier
		let secondConstant =  -widthConstraint.constant*(0.5-(0.34*CGFloat(cos(Double.pi/6*twelfth+Double.pi/2))))
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: firstConstant),
			NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: secondConstant)
		])
	}
	private func setUpLabel(label: NSTextField) {
		label.font=NSFont.systemFont(ofSize: 30)
		label.translatesAutoresizingMaskIntoConstraints = false
		addSubview(label)
		label.sizeToFit()
		hourLabels.append(label)
	}
	private func addHand(handLayer: CAShapeLayer, lengthProportion: CGFloat) {
		handLayer.frame = bounds
		let hand = CGMutablePath()
		let lineWidth=frame.width/100
		hand.move(to: CGPoint(x: bounds.midX, y: bounds.midY))
		hand.addLine(to: CGPoint(x: bounds.midX, y: bounds.height*lengthProportion))
		handLayer.path = hand
		handLayer.lineWidth = lineWidth
		handLayer.lineCap = CAShapeLayerLineCap.round
		layer?.addSublayer(handLayer)
	}
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		for label in hourLabels { label.textColor=color }
		amPmLabel.textColor=color
		minuteLayer.strokeColor=color.cgColor
		hourLayer.strokeColor=color.cgColor
		secondLayer.strokeColor=color.cgColor
		let origin=CGPoint(x: bounds.width*0.05, y: bounds.height*0.05)
		let path=NSBezierPath(ovalIn: NSRect(origin: origin, size: CGSize(width: frame.width*0.9, height: frame.height*0.9)))
		color.setStroke()
		path.lineWidth=CGFloat(frame.width/150)
		path.stroke()
		guard let cgContext=NSGraphicsContext.current?.cgContext else {
				return
		}
		for hour in 1...12 {
			drawDash(cgContext: cgContext, angle: CGFloat(2*Double.pi*Double(hour)/Double(12)), start: 0.4, startProportion: 0, end: 0.45)
		}
		for minute in 1...60 {
			drawDash(cgContext: cgContext, angle: CGFloat(2*Double.pi*Double(minute)/60), start: 0.4, startProportion: 0.6, end: 0.45)
		}
    }
	func use1to12Hours() {
		for index in 0...11 {
			hourLabels[index].stringValue=String(12-index)
			hourLabels[index].sizeToFit()
		}
	}
	func use0to11Hours() {
		hourLabels[0].stringValue=String(0)
		for index in 1...11 {
			hourLabels[index].stringValue=String(12-index)
			hourLabels[index].sizeToFit()
		}
	}
	func use12to23Hours() {
		hourLabels[0].stringValue=String(12)
		for index in 1...11 {
			hourLabels[index].stringValue=String(24-index)
			hourLabels[index].sizeToFit()
		}
	}
}
