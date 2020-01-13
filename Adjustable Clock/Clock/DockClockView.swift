//
//  DockClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/12/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class DockClockView: NSView {
	var foregorundColor=NSColor.labelColor
	var backgroundColor=NSColor.labelColor
	override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
		
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setUp()
    }
    private func setUp() {
		let leadingConstraint=NSLayoutConstraint(item: visualEffectView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
		let trailingConstraint=NSLayoutConstraint(item: visualEffectView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
		let topConstraint=NSLayoutConstraint(item: visualEffectView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
		let bottomConstraint=NSLayoutConstraint(item: visualEffectView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
	}
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let origin=CGPoint(x: bounds.width*0.05, y: bounds.height*0.05)
		let path=NSBezierPath(ovalIn: NSRect(origin: origin, size: CGSize(width: frame.width*0.9, height: frame.height*0.9)))
		foregorundColor.setStroke()
		path.lineWidth=CGFloat(frame.width/20)
		path.stroke()
		backgroundColor.setFill()
		path.fill()
    }
}
