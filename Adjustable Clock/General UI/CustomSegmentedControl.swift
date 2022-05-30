//
//  CustomSegmentedControl.swift
//  Clock Suite
//
//  Created by Matt Roberts on 5/30/22.
//  Copyright © 2022 Matt Roberts. All rights reserved.
//

import Cocoa

class CustomSegmentedControl: NSSegmentedControl {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		if isDarkMode() && !ClockPreferencesStorage.sharedInstance.colorForForeground && ClockPreferencesStorage.sharedInstance.colorChoice == .white{
			wantsLayer=true
			layer?.backgroundColor=NSColor.black.cgColor
			layer?.cornerRadius=7.5
		} else {
			layer?.backgroundColor=NSColor.clear.cgColor
		}
    }
}
