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
		print("trying to apply")
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
			if DockClockController.dockClockObject.dockClockView.hasDarkAppearance {
				if contrastColor==NSColor.white {
					contrastColor=NSColor.systemGray
				}
				self.view.contrastColor=contrastColor.blended(withFraction: 0.5, of: NSColor.black) ?? NSColor.clear
					analogClock.color=NSColor.labelColor
					analogClock.setNeedsDisplay(analogClock.bounds)
			} else {
				self.view.contrastColor=contrastColor ?? NSColor.clear
				analogClock.color=NSColor.labelColor
				analogClock.setNeedsDisplay(analogClock.bounds)
			}
		} else {
			visualEffectView.isHidden=false
			digitalClock.textColor=contrastColor
			animatedDay.textColor=contrastColor
			analogClock.color=contrastColor
			analogClock.setNeedsDisplay(analogClock.bounds)
			self.view.contrastColor = NSColor.labelColor
		}
		self.view.draw(view.bounds)
		print("Changed color")
	}
}
