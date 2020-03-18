//
//  ColorfulViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/5/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class ColorfulViewController: NSViewController {
	let visualEffectView=NSVisualEffectView()
	let backgroundView=DarkAndLightBackgroundView()
	var textColor=NSColor.labelColor
    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(backgroundView, positioned: .below, relativeTo: view)
		backgroundView.translatesAutoresizingMaskIntoConstraints=false
		let backgroundLeading=NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		let backgroundTrailing=NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		let backgroundTop=NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let backgroundBottom=NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([backgroundLeading, backgroundTrailing, backgroundTop, backgroundBottom])
		view.addSubview(visualEffectView, positioned: .above, relativeTo: backgroundView)
		visualEffectView.translatesAutoresizingMaskIntoConstraints=false
		let visualEffectLeading=NSLayoutConstraint(item: visualEffectView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		let visualEffectTrailing=NSLayoutConstraint(item: visualEffectView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		let visualEffectTop=NSLayoutConstraint(item: visualEffectView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let visualEffectBottom=NSLayoutConstraint(item: visualEffectView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([visualEffectLeading, visualEffectTrailing, visualEffectTop, visualEffectBottom])
		visualEffectView.blendingMode = .behindWindow
		visualEffectView.material = .popover
		visualEffectView.appearance=NSAppearance(named: NSAppearance.Name.vibrantDark)
	}
	func applyColorScheme(views: [ColorView], labels: [NSTextField]) {
		visualEffectView.material = .dark
		var contrastColor: NSColor
		let clockNSColors=ColorDictionary()
			backgroundView.wantsLayer=true
		if ClockPreferencesStorage.sharedInstance.colorChoice=="custom"{
			contrastColor=ClockPreferencesStorage.sharedInstance.customColor
		} else {
			contrastColor =
				clockNSColors.colorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
		}
		if ClockPreferencesStorage.sharedInstance.colorForForeground==false {
			visualEffectView.isHidden=true
			for label in labels {
				label.textColor=NSColor.labelColor
			}
			textColor=NSColor.labelColor
			if !isDarkMode() &&
				contrastColor==NSColor.black {
				if #available(OSX 10.13, *) {
					contrastColor=NSColor(named: "BlackBackground") ?? NSColor.systemGray
				}
					backgroundView.backgroundColor=contrastColor
					backgroundView.setNeedsDisplay(backgroundView.bounds)
			} else if isDarkMode() {
				if contrastColor==NSColor.white {
					if #available(OSX 10.13, *) {
						contrastColor=NSColor(named: "WhiteBackground") ?? NSColor.systemGray
					}
				}
					backgroundView.backgroundColor=contrastColor
					backgroundView.setNeedsDisplay(backgroundView.bounds)
			} else {
					backgroundView.backgroundColor=contrastColor
					backgroundView.setNeedsDisplay(backgroundView.bounds)
			}
			for aView in views {
				aView.color=NSColor.labelColor
				aView.setNeedsDisplay(aView.bounds)
			}
		} else {
			visualEffectView.isHidden=false
			if contrastColor==NSColor.textBackgroundColor {
				contrastColor=NSColor.labelColor
				if !isDarkMode() {
					visualEffectView.material = .light
				} else {
					visualEffectView.material = .dark
				}
			} else if contrastColor==NSColor.labelColor || contrastColor==NSColor.black {
				if !isDarkMode() {
					visualEffectView.material = .light
				} else {
					visualEffectView.material = .dark
				}
			}else {
				visualEffectView.material = .dark
			}
			textColor=contrastColor
				for label in labels {
					label.textColor=contrastColor
				}
				for aView in views {
					aView.color=contrastColor
					aView.setNeedsDisplay(aView.bounds)
				}
		}
		self.view.setNeedsDisplay(view.bounds)
	}
}
