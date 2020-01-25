//
//  AlarmsColorController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/21/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
class AlarmsColorController {
	private var visualEffectView: NSVisualEffectView
	private var view: DarkAndLightBackgroundView
	private var titleTextField: NSTextField
	private var notifierTextField: NSTextField
	private var tableView: NSTableView
	var textColor=NSColor.labelColor
	init(visualEffectView: NSVisualEffectView, view: DarkAndLightBackgroundView, titleTextField: NSTextField, notifierTextField: NSTextField, tableView: NSTableView) {
		self.visualEffectView=visualEffectView
		self.view=view
		self.titleTextField=titleTextField
		self.notifierTextField=notifierTextField
		self.tableView=tableView
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
			titleTextField.textColor=NSColor.labelColor
			if !isDarkMode() && contrastColor==NSColor.black {
				if #available(OSX 10.13, *) {
					contrastColor=NSColor(named: "BlackBackground") ?? NSColor.systemGray
				}
			} else if isDarkMode() {
				if contrastColor==NSColor.white {
					if #available(OSX 10.13, *) {
						contrastColor=NSColor(named: "WhiteBackground") ?? NSColor.systemGray
					}
				}
			}
			textColor=NSColor.labelColor
			notifierTextField.textColor=NSColor.labelColor
			textColor=NSColor.labelColor
			self.view.contrastColor=contrastColor
		} else {
			visualEffectView.isHidden=false
			titleTextField.textColor=contrastColor
			notifierTextField.textColor=contrastColor
			textColor=contrastColor
		}
		self.view.setNeedsDisplay(view.bounds)
		tableView.reloadData()
	}
}
