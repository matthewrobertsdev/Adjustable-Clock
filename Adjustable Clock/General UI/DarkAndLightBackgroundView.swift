//
//  DarkAndLightBackgroundView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/18/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class DarkAndLightBackgroundView: NSView, BackgroundColorView {
	var backgroundColor=NSColor.systemGray
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		self.wantsLayer=true
		if hasDarkAppearance(view: self) &&
		backgroundColor != NSColor.labelColor {
			if backgroundColor==NSColor.white {
				if #available(OSX 10.13, *) {
					backgroundColor=NSColor(named: "WhiteBackground") ?? NSColor.systemGray
				}
			}
			if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.custom &&
				!ClockPreferencesStorage.sharedInstance.colorForForeground {
				backgroundColor=ClockPreferencesStorage.sharedInstance.customColor.blended(withFraction: 0.4, of: NSColor.black)
					?? NSColor.systemGray
			}
			layer?.backgroundColor=backgroundColor.cgColor
			if ClockPreferencesStorage.sharedInstance.useGradients {
				applyGradient()
			}
		} else if !hasDarkAppearance(view: self) && backgroundColor != NSColor.labelColor {
			if backgroundColor==NSColor.black {
				if #available(OSX 10.13, *) {
					backgroundColor=NSColor(named: "BlackBackground") ?? NSColor.systemGray
				}
			}
			if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.custom &&
				!ClockPreferencesStorage.sharedInstance.colorForForeground {
				backgroundColor=ClockPreferencesStorage.sharedInstance.customColor
			}
			layer?.backgroundColor=backgroundColor.cgColor
			if ClockPreferencesStorage.sharedInstance.useGradients {
				applyGradient()
			}
		} else {
			backgroundColor=NSColor.black
			backgroundColor.setFill()
			if ClockPreferencesStorage.sharedInstance.useGradients {
				applyGradient()
			}
		}
	}
	func applyGradient() {
		let darkerConstant = hasDarkAppearance(view: self) ? 0.5 : 0.2
		let lighterConstant = hasDarkAppearance(view: self) ? 0.2 : 0.5
		let darkerColor = backgroundColor.blended(withFraction: darkerConstant, of: NSColor.black) ?? backgroundColor
		let lighterColor = backgroundColor.blended(withFraction: lighterConstant, of: NSColor.white) ?? backgroundColor
		let gradient = NSGradient(colors: [darkerColor, backgroundColor, lighterColor])
		gradient?.draw(from: NSPoint(x: self.frame.width/2, y: 0), to: NSPoint(x: self.frame.width/2, y: self.frame.height))
	}
}
