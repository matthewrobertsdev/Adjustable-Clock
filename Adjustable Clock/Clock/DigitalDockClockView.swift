//
//  DigitalDockClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/30/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
class DigitalDockClockView: NSView {
	let contentView=NSView()
	let digitalClock=NSTextField(labelWithString: "12:00")
	override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setUp()
    }
	private func setUp() {
		addSubview(contentView)
		contentView.wantsLayer=true
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.layer?.backgroundColor=NSColor.white.cgColor
		let contentLeading=NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
		let contentTrailing=NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
		let contentCenterY=NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
		let contentHeight=NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
		NSLayoutConstraint.activate([contentLeading, contentTrailing, contentCenterY, contentHeight])
		contentView.addSubview(digitalClock)
		digitalClock.translatesAutoresizingMaskIntoConstraints=false
		digitalClock.font=NSFont.userFont(ofSize: 50)
		let digitalClockX=NSLayoutConstraint(item: digitalClock, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
		let digitalClockY=NSLayoutConstraint(item: digitalClock, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([digitalClockX, digitalClockY])
	}
}
