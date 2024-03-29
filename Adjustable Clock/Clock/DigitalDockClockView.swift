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
	let notifcationCenter=NotificationCenter.default
	var dark=false {
		didSet {
			if dark {
				notifcationCenter.post(name: NSNotification.Name.didChangToDarkMode, object: nil)
			} else {
				notifcationCenter.post(name: NSNotification.Name.didChangToLightMode, object: nil)
			}
		}
	}
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
		let contentLeading=NSLayoutConstraint(item: contentStackView, attribute: .leading, relatedBy: .equal,
											  toItem: self, attribute: .leading, multiplier: 1, constant: 0)
		let contentTrailing=NSLayoutConstraint(item: contentStackView, attribute: .trailing, relatedBy: .equal,
											   toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
		let contentCenterY=NSLayoutConstraint(item: contentStackView, attribute: .centerY, relatedBy: .equal,
											  toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
		contentHeight=NSLayoutConstraint(item: contentStackView, attribute: .height, relatedBy: .equal,
										 toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
		NSLayoutConstraint.activate([contentLeading, contentTrailing, contentCenterY, contentHeight])
		contentStackView.alignment = .centerX
		contentStackView.addArrangedSubview(digitalClock)
		digitalClock.translatesAutoresizingMaskIntoConstraints=false
		digitalClock.font=NSFont.userFont(ofSize: 50)
		let digitalClockX=NSLayoutConstraint(item: digitalClock, attribute: .centerX, relatedBy: .equal,
											 toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([digitalClockX])
	}
	func addSeconds() {
		contentStackView.addArrangedSubview(digitalSeconds)
		digitalSeconds.translatesAutoresizingMaskIntoConstraints=false
		let digitalSecondsX=NSLayoutConstraint(item: digitalClock, attribute: .centerX, relatedBy: .equal,
											   toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
		digitalSeconds.font=NSFont.userFont(ofSize: 50)
		digitalSeconds.isHidden=false
		contentHeight.isActive=false
		contentHeight=NSLayoutConstraint(item: contentStackView, attribute: .height, relatedBy: .equal,
										 toItem: self, attribute: .height, multiplier: 0.93, constant: 0)
		NSLayoutConstraint.activate([contentHeight, digitalSecondsX])
	}
	func removeSeconds() {
		digitalSeconds.isHidden=true
		contentHeight.isActive=false
		contentHeight=NSLayoutConstraint(item: contentStackView, attribute: .height, relatedBy: .equal,
										 toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
		NSLayoutConstraint.activate([contentHeight])
	}
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		var path: NSBezierPath
		if displaySeconds {
			path=NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: frame.size.width,
												  height: frame.height), xRadius: 30, yRadius: 30)
		} else {
			path=NSBezierPath(roundedRect: NSRect(x: 0, y: 0.096*frame.height, width: frame.size.width,
												  height: 0.808*frame.height), xRadius: 25, yRadius: 25)
		}
		if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.custom {
			if !hasDarkAppearance(view: self)
				||  ClockPreferencesStorage.sharedInstance.colorForForeground { backgroundColor =
				ClockPreferencesStorage.sharedInstance.customColor
			} else {
				backgroundColor =
					ClockPreferencesStorage.sharedInstance.customColor.blended(withFraction: 0.4, of: NSColor.black)
					?? NSColor.systemGray
			}
		} else if hasDarkAppearance(view: self) && !ClockPreferencesStorage.sharedInstance.colorForForeground {
			backgroundColor=ColorModel.sharedInstance.darkColorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice]
				?? NSColor.systemGray
		} else {
			backgroundColor=ColorModel.sharedInstance.lightColorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice]
				?? NSColor.systemGray
		}
		if hasDarkAppearance(view: self) && dark==false {
			dark=true
		} else if !hasDarkAppearance(view: self) && dark==true {
			dark=false
		}
		if !ClockPreferencesStorage.sharedInstance.colorForForeground {
			if hasDarkAppearance(view: self) {
				digitalClock.textColor=NSColor.white
				digitalSeconds.textColor=NSColor.white
				if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.white {
					digitalClock.textColor=NSColor.black
					digitalSeconds.textColor=NSColor.black
				}
			} else {
				digitalClock.textColor=NSColor.black
				digitalSeconds.textColor=NSColor.black
				if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.black {
					digitalClock.textColor=NSColor.white
					digitalSeconds.textColor=NSColor.white
				}
			}
			if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.systemColor {
				if hasDarkAppearance(view: self) {
					backgroundColor=NSColor(named: "DarkSystemColor") ?? NSColor.textBackgroundColor
				} else {
					backgroundColor=NSColor(named: "LightSystemColor") ?? NSColor.textBackgroundColor
				}
			}
		} else {
			digitalClock.textColor=NSColor.black
			digitalSeconds.textColor=NSColor.black
			if ClockPreferencesStorage.sharedInstance.colorForForeground && ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.black {
				backgroundColor=NSColor.systemGray
			}
		}
		backgroundColor.setFill()
		path.fill()
	}
}

extension Notification.Name {
	static let didChangToDarkMode=Notification.Name(rawValue: "DidChangToDarkMode")
	static let didChangToLightMode=Notification.Name(rawValue: "DidChangToLightMode")
}
