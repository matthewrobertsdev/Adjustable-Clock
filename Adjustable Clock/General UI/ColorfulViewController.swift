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
		let backgroundLeading=NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal,
												 toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		let backgroundTrailing=NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal,
												  toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		let backgroundTop=NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal,
											 toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let backgroundBottom=NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal,
												toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([backgroundLeading, backgroundTrailing, backgroundTop, backgroundBottom])
		view.addSubview(visualEffectView, positioned: .above, relativeTo: backgroundView)
		visualEffectView.translatesAutoresizingMaskIntoConstraints=false
		let visualEffectLeading=NSLayoutConstraint(item: visualEffectView, attribute: .leading, relatedBy: .equal,
												   toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		let visualEffectTrailing=NSLayoutConstraint(item: visualEffectView, attribute: .trailing, relatedBy: .equal,
													toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		let visualEffectTop=NSLayoutConstraint(item: visualEffectView, attribute: .top, relatedBy: .equal,
											   toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let visualEffectBottom=NSLayoutConstraint(item: visualEffectView, attribute: .bottom, relatedBy: .equal,
												  toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([visualEffectLeading, visualEffectTrailing, visualEffectTop, visualEffectBottom])
		visualEffectView.blendingMode = .behindWindow
		visualEffectView.material = .popover
		visualEffectView.appearance=NSAppearance(named: NSAppearance.Name.vibrantDark)
	}
	// swiftlint:disable:next cyclomatic_complexity
	func applyColorScheme(views: [ColorView], labels: [NSTextField]) {
		visualEffectView.material = .underWindowBackground
		var contrastColor: NSColor
			backgroundView.wantsLayer=true
		if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.custom {
			contrastColor=ClockPreferencesStorage.sharedInstance.customColor
		} else if ClockPreferencesStorage.sharedInstance.colorForForeground && !ClockPreferencesStorage.sharedInstance.useNightMode {
			contrastColor =
			ColorModel.sharedInstance.lightColorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice]
				?? ColorModel.sharedInstance.lightColorsDictionary[ColorChoice.systemColor] ?? NSColor.systemGray
		} else {
			contrastColor =
				ColorModel.sharedInstance.colorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice]
				?? ColorModel.sharedInstance.colorsDictionary[ColorChoice.systemColor] ?? NSColor.systemGray
		}
		if ClockPreferencesStorage.sharedInstance.colorForForeground {
			if !GeneralPreferencesStorage.sharedInstance.usesTranslucentBackground {
				visualEffectView.isHidden=true
				backgroundView.backgroundColor=NSColor(named: "SystemDarkBackground") ?? NSColor.darkGray
				backgroundView.setNeedsDisplay(backgroundView.bounds)
			} else {
			visualEffectView.isHidden=false
			}
			if ClockPreferencesStorage.sharedInstance.colorForForeground
				&& ClockPreferencesStorage.sharedInstance.colorChoice == ColorChoice.systemColor && ClockPreferencesStorage.sharedInstance.useNightMode {
				contrastColor=NSColor(named: "MatchingColor") ?? NSColor.labelColor
			}
			if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.custom && ClockPreferencesStorage.sharedInstance.useNightMode && ColorsMenuController.dark {
				contrastColor=contrastColor.blended(withFraction: 0.4, of: NSColor.black) ?? NSColor.systemGray
			}
			if ClockPreferencesStorage.sharedInstance.colorChoice == .black {
				backgroundView.backgroundColor=NSColor(named: "LightDarkBackground") ?? NSColor.darkGray
			}
			textColor=contrastColor
				for label in labels {
					label.textColor=contrastColor
				}
				for aView in views {
					aView.color=contrastColor
					aView.setNeedsDisplay(aView.bounds)
				}
		} else {
			var labelColor=NSColor.labelColor
			if ClockPreferencesStorage.sharedInstance.colorChoice == .black {
				labelColor=NSColor.white
			} else if ClockPreferencesStorage.sharedInstance.colorChoice == .white {
				labelColor=NSColor.black
			} else if ClockPreferencesStorage.sharedInstance.useNightMode {
				labelColor=NSColor.black
				if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.black {
					labelColor=NSColor(named: "DarkLabel") ?? NSColor.labelColor
				}
			}
			//labelColor=NSColor.white
			visualEffectView.isHidden=true
			for label in labels {
				label.textColor=labelColor
			}
			textColor=labelColor
			if !isDarkMode() &&
				contrastColor==NSColor.black {
				contrastColor=NSColor(named: "BlackBackground") ?? NSColor.systemGray
					backgroundView.backgroundColor=contrastColor
					backgroundView.setNeedsDisplay(backgroundView.bounds)
			} else if isDarkMode() {
				if contrastColor==NSColor.white {
					contrastColor=NSColor(named: "WhiteBackground") ?? NSColor.systemGray
				}
					backgroundView.backgroundColor=contrastColor
					backgroundView.setNeedsDisplay(backgroundView.bounds)
			} else {
					backgroundView.backgroundColor=contrastColor
					backgroundView.setNeedsDisplay(backgroundView.bounds)
			}
			for aView in views {
				aView.color=labelColor
				aView.setNeedsDisplay(aView.bounds)
			}
		}
		self.view.setNeedsDisplay(view.bounds)
	}
}
