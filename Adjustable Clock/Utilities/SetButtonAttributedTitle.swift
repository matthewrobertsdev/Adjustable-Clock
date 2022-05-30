//
//  SetButtonAttributedTitle.swift
//  Clock Suite
//
//  Created by Matt Roberts on 5/30/22.
//  Copyright © 2022 Matt Roberts. All rights reserved.
//

import AppKit
func setButtonTitle(button: NSButton, title: String) {
	if !ClockPreferencesStorage.sharedInstance.colorForForeground && ClockPreferencesStorage.sharedInstance.colorChoice == .white{
		let attributedTitle = NSAttributedString(string: title,
												  attributes: [NSAttributedString.Key.foregroundColor: NSColor.black])
		button.attributedTitle=attributedTitle
	} else {
		let attributedTitle = NSAttributedString(string: title,
												 attributes: [NSAttributedString.Key.foregroundColor: NSColor.labelColor])
		button.attributedTitle=attributedTitle
	}
}
