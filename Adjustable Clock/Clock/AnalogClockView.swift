//
//  AnalogClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/28/19.
//  Copyright © 2019 Celeritas Apps. All rights reserved.
//
import Cocoa
class AnalogClockView: NSView {
	var labels=[NSTextField]()
	var color=NSColor.labelColor
	override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUpLabels()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setUpLabels()
    }

    private func setUpLabels() {
		let twelfthTextField=NSTextField(labelWithString: "12")
		let firstTextField=NSTextField(labelWithString: "1")
		let secondTextField=NSTextField(labelWithString: "2")
		setUpLabel(label: twelfthTextField)
		let top12=frame.size.height*(0.5-(0.35*CGFloat(sin(Double.pi/2))))
		NSLayoutConstraint.activate([
			twelfthTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
			NSLayoutConstraint(item: twelfthTextField, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: top12)
		])
		setUpLabel(label: firstTextField)
		let top1=frame.size.height*(0.5-(0.35*CGFloat(sin(Double.pi/3))))
		let trailing1 = -frame.size.height*(0.5-(0.35*CGFloat(cos(Double.pi/3))))
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: firstTextField, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: top1),
			NSLayoutConstraint(item: firstTextField, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: trailing1)
		])
		setUpLabel(label: secondTextField)
		let top2=frame.size.height*(0.5-(0.35*CGFloat(sin(Double.pi/6))))
		let trailing2 = -frame.size.height*(0.5-(0.35*CGFloat(cos(Double.pi/6))))
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: secondTextField, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: top2),
			NSLayoutConstraint(item: secondTextField, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: trailing2)
		])
    }
	private func setUpLabel(label: NSTextField){
		label.font=NSFont.systemFont(ofSize: 20)
		label.translatesAutoresizingMaskIntoConstraints = false
		addSubview(label)
		label.sizeToFit()
		labels.append(label)
	}
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		for label in labels{
			label.textColor=color
		}
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
		/*
		twelfthLabel.stringValue="12"
		twelfthLabel.sizeToFit()
		twelfthLabel.backgroundColor=NSColor.clear
		self.addSubview(twelfthLabel)
		
		NSLayoutConstraint.activate([twelfthLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			twelfthLabel.centerXAnchor.constraint(equalTo: centerXAnchor)])
*/
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
