//
//  AlarmsColorController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/21/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class AlarmsColorController {
	private var visualEffectView: NSVisualEffectView
	private var view: DarkAndLightBackgroundView
	init(visualEffectView: NSVisualEffectView, view: DarkAndLightBackgroundView) {
		self.visualEffectView=visualEffectView
		self.view=view
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
			if !isDarkMode() && contrastColor==NSColor.black {
				if #available(OSX 10.13, *) {
					contrastColor=NSColor(named: "BlackBackground") ?? NSColor.systemGray
				}
				self.view.contrastColor=contrastColor
			} else if isDarkMode() {
				if contrastColor==NSColor.white {
					if #available(OSX 10.13, *) {
						contrastColor=NSColor(named: "WhiteBackground") ?? NSColor.systemGray
					}
				}
				self.view.contrastColor=contrastColor
			} else {
				self.view.contrastColor=contrastColor ?? NSColor.clear
			}
		} else {
			visualEffectView.isHidden=false
			self.view.contrastColor = NSColor.labelColor
		}
		self.view.setNeedsDisplay(view.bounds)
	}
}

