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
	private var view: DarkAndLightBackgroundView
	private var digitalClock: NSTextField
	private var animatedDay: NSTextField
	private var analogClock: AnalogClockView
	init(visualEffectView: NSVisualEffectView, view: DarkAndLightBackgroundView, digitalClock: NSTextField, animatedDay: NSTextField, analogClock: AnalogClockView) {
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
			if !isDarkMode() &&
				contrastColor==NSColor.black {
				if #available(OSX 10.13, *) {
					contrastColor=NSColor(named: "BlackBackground") ?? NSColor.systemGray
				}
				self.view.backgroundColor=contrastColor
				analogClock.color=NSColor.labelColor
				analogClock.setNeedsDisplay(analogClock.bounds)
			} else if isDarkMode() {
				if contrastColor==NSColor.white {
					if #available(OSX 10.13, *) {
						contrastColor=NSColor(named: "WhiteBackground") ?? NSColor.systemGray
					}
				}
				self.view.backgroundColor=contrastColor
					analogClock.color=NSColor.labelColor
					analogClock.setNeedsDisplay(analogClock.bounds)
			} else {
				self.view.backgroundColor=contrastColor
				analogClock.color=NSColor.labelColor
				analogClock.setNeedsDisplay(analogClock.bounds)
			}
		} else {
			visualEffectView.isHidden=false
			digitalClock.textColor=contrastColor
			animatedDay.textColor=contrastColor
			analogClock.color=contrastColor
			if ClockPreferencesStorage.sharedInstance.colorForForeground { analogClock.setNeedsDisplay(analogClock.bounds)
			}
			self.view.backgroundColor = NSColor.labelColor
		}
		self.view.setNeedsDisplay(view.bounds)
	}
}
