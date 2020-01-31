//
//  DigitalDockClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/30/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
class DigitalDockClockView: NSView {
	let contentStackView=NSStackView()
	let digitalClock=NSTextField(labelWithString: "--:--")
	override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setUp()
    }
	private func setUp() {
		addSubview(contentStackView)
		contentStackView.wantsLayer=true
		contentStackView.translatesAutoresizingMaskIntoConstraints = false
		contentStackView.layer?.backgroundColor=NSColor.white.cgColor
		let contentLeading=NSLayoutConstraint(item: contentStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
		let contentTrailing=NSLayoutConstraint(item: contentStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
		let contentCenterY=NSLayoutConstraint(item: contentStackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
		let contentHeight=NSLayoutConstraint(item: contentStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
		NSLayoutConstraint.activate([contentLeading, contentTrailing, contentCenterY, contentHeight])
		contentStackView.alignment = .centerX
		contentStackView.addArrangedSubview(digitalClock)
		digitalClock.translatesAutoresizingMaskIntoConstraints=false
		digitalClock.font=NSFont.userFont(ofSize: 50)
		let digitalClockX=NSLayoutConstraint(item: digitalClock, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
		let digitalClockY=NSLayoutConstraint(item: digitalClock, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([digitalClockX, digitalClockY])
	}
}
