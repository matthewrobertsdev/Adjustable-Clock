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
	let digitalSeconds=NSTextField(labelWithString: "--")
	var contentHeight: NSLayoutConstraint!
	var displaySeconds=false
	var backgroundColor=NSColor.systemGray
	@objc dynamic var dark=false
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
		contentStackView.spacing=CGFloat(0)
		let contentLeading=NSLayoutConstraint(item: contentStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
		let contentTrailing=NSLayoutConstraint(item: contentStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
		let contentCenterY=NSLayoutConstraint(item: contentStackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
		contentHeight=NSLayoutConstraint(item: contentStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
		NSLayoutConstraint.activate([contentLeading, contentTrailing, contentCenterY, contentHeight])
		contentStackView.alignment = .centerX
		contentStackView.addArrangedSubview(digitalClock)
		digitalClock.translatesAutoresizingMaskIntoConstraints=false
		digitalClock.font=NSFont.userFont(ofSize: 50)
		let digitalClockX=NSLayoutConstraint(item: digitalClock, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([digitalClockX])
	}
	func addSeconds() {
		contentStackView.addArrangedSubview(digitalSeconds)
		digitalSeconds.translatesAutoresizingMaskIntoConstraints=false
		let digitalSecondsX=NSLayoutConstraint(item: digitalClock, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
		digitalSeconds.font=NSFont.userFont(ofSize: 50)
		digitalSeconds.isHidden=false
		contentHeight.isActive=false
		contentHeight=NSLayoutConstraint(item: contentStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.93, constant: 0)
		NSLayoutConstraint.activate([contentHeight, digitalSecondsX])
	}
	func removeSeconds() {
		digitalSeconds.isHidden=true
		contentHeight.isActive=false
		contentHeight=NSLayoutConstraint(item: contentStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
		NSLayoutConstraint.activate([contentHeight])
	}
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		var path: NSBezierPath
		let radius: CGFloat=15.0
		if displaySeconds {
			path=NSBezierPath(roundedRect: NSRect(x: 0, y: 0.035*frame.height, width: frame.size.width, height: 0.93*frame.height), xRadius: radius, yRadius: radius)
		} else {
			path=NSBezierPath(roundedRect: NSRect(x: 0, y: 0.25*frame.height, width: frame.size.width, height: 0.5*frame.height), xRadius: radius, yRadius: radius)
		}
		let clockNSColors=ColorDictionary()
		if ClockPreferencesStorage.sharedInstance.colorChoice=="custom" {
		backgroundColor=ClockPreferencesStorage.sharedInstance.customColor
		} else if hasDarkAppearance && !ClockPreferencesStorage.sharedInstance.colorForForeground {
		 backgroundColor=clockNSColors.darkColorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
		} else {
			backgroundColor=clockNSColors.lightColorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
		}
		if hasDarkAppearance && dark==false {
			dark=true
		} else if !hasDarkAppearance && dark==true {
			dark=false
		}
		if hasDarkAppearance && backgroundColor != NSColor.labelColor {
			//backgroundColorCopy=backgroundColor.blended(withFraction: 0.5, of: NSColor.black) ?? NSColor.white
			backgroundColor.setFill()
		} else if !hasDarkAppearance && backgroundColor != NSColor.labelColor {
			backgroundColor.setFill()
		} else {
			backgroundColor=NSColor.black
			backgroundColor.setFill()
		}
		path.fill()
	}
}
