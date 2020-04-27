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
			if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.custom && !ClockPreferencesStorage.sharedInstance.colorForForeground{
				print("should be dark")
				backgroundColor=ClockPreferencesStorage.sharedInstance.customColor.blended(withFraction: 0.4, of: NSColor.black) ?? NSColor.systemGray
			}
			layer?.backgroundColor=backgroundColor.cgColor
		} else if !hasDarkAppearance(view: self) && backgroundColor != NSColor.labelColor {
			if backgroundColor==NSColor.black {
				if #available(OSX 10.13, *) {
					backgroundColor=NSColor(named: "BlackBackground") ?? NSColor.systemGray
				}
			}
			if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.custom && !ClockPreferencesStorage.sharedInstance.colorForForeground{
				print("should be light")
				backgroundColor=ClockPreferencesStorage.sharedInstance.customColor
			}
			layer?.backgroundColor=backgroundColor.cgColor
		} else {
			backgroundColor=NSColor.black
			backgroundColor.setFill()
		}
	}
}
