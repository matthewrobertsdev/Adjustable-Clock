//
//  ClockColorController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/9/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
class ClockColorController {
	private var visualEffectView: NSVisualEffectView
	private var view: NSView
	private var digitalClock: NSTextField
	private var animatedDay: NSTextField
	private var analogClock: AnalogClockView
	init(visualEffectView: NSVisualEffectView, view: NSView, digitalClock: NSTextField, animatedDay: NSTextField, analogClock: AnalogClockView) {
		self.visualEffectView=visualEffectView
		self.view=view
		self.digitalClock=digitalClock
		self.animatedDay=animatedDay
		self.analogClock=analogClock
	}
	func applyColorScheme() {
		var contrastColor: NSColor
		let clockNSColors=ColorDictionary()
		self.view.wantsLayer=true
		if ClockPreferencesStorage.sharedInstance.colorChoice=="custom"{
			contrastColor=ClockPreferencesStorage.sharedInstance.customColor
		} else {
			contrastColor =
				clockNSColors.colorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
		}
		if ClockPreferencesStorage.sharedInstance.colorForForeground==false {
			visualEffectView.isHidden=true
			digitalClock.textColor=NSColor.labelColor
			animatedDay.textColor=NSColor.labelColor
			if contrastColor==NSColor.black {
				contrastColor=NSColor.systemGray
			}
			if #available(OSX 10.14, *) {
				if let uiName=NSApp?.effectiveAppearance.name {
					if uiName==NSAppearance.Name.darkAqua||uiName==NSAppearance.Name.accessibilityHighContrastDarkAqua||uiName==NSAppearance.Name.accessibilityHighContrastVibrantDark {
						if contrastColor==NSColor.white {
							contrastColor=NSColor.systemGray
						}
					}
				}
			}
			self.view.layer?.backgroundColor=contrastColor.cgColor
			analogClock.color=NSColor.labelColor
			analogClock.setNeedsDisplay(analogClock.bounds)
		} else {
			visualEffectView.isHidden=false
			digitalClock.textColor=contrastColor
			animatedDay.textColor=contrastColor
			analogClock.color=contrastColor
			analogClock.setNeedsDisplay(analogClock.bounds)
			self.view.layer?.backgroundColor = NSColor.labelColor.cgColor
		}
	}
}
