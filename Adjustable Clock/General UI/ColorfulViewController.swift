//
//  ColorfulViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/5/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class ColorfulViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
	func applyColorScheme(visualEffect: NSVisualEffectView, views: [ColorView], backgrounds: [BackgroundColorView], foregrounds: [ForegroundColorView], labels: [NSTextField]) {
		var contrastColor: NSColor
		let clockNSColors=ColorDictionary()
		for aView in backgrounds {
			aView.wantsLayer=true
		}
		if ClockPreferencesStorage.sharedInstance.colorChoice=="custom"{
			contrastColor=ClockPreferencesStorage.sharedInstance.customColor
		} else {
			contrastColor =
				clockNSColors.colorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
		}
		if ClockPreferencesStorage.sharedInstance.colorForForeground==false {
			visualEffect.isHidden=true
			for label in labels {
				label.textColor=NSColor.labelColor
			}
			if !isDarkMode() &&
				contrastColor==NSColor.black {
				if #available(OSX 10.13, *) {
					contrastColor=NSColor(named: "BlackBackground") ?? NSColor.systemGray
				}
				for aView in backgrounds {
					aView.backgroundColor=contrastColor
					aView.setNeedsDisplay(aView.bounds)
				}
				for aView in foregrounds {
					aView.foregroundColor=NSColor.labelColor
					aView.setNeedsDisplay(aView.bounds)
				}
			} else if isDarkMode() {
				if contrastColor==NSColor.white {
					if #available(OSX 10.13, *) {
						contrastColor=NSColor(named: "WhiteBackground") ?? NSColor.systemGray
					}
				}
				for aView in backgrounds {
					aView.backgroundColor=contrastColor
					aView.setNeedsDisplay(aView.bounds)
				}
			} else {
				for aView in backgrounds {
					aView.backgroundColor=contrastColor
					aView.setNeedsDisplay(aView.bounds)
				}
				for aView in foregrounds {
					aView.foregroundColor=NSColor.labelColor
					aView.setNeedsDisplay(aView.bounds)
				}
			}
			for aView in views {
				aView.color=NSColor.labelColor
				aView.setNeedsDisplay(aView.bounds)
			}
		} else {
			visualEffect.isHidden=false
			for label in labels {
				label.textColor=contrastColor
			}
			for aView in foregrounds {
				aView.foregroundColor=contrastColor
				aView.setNeedsDisplay(aView.bounds)
			}
			for aView in views {
				aView.color=contrastColor
				aView.setNeedsDisplay(aView.bounds)
			}
		}
		self.view.setNeedsDisplay(view.bounds)
	}
}
