//
//  isDarkMode.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/18/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import AppKit
//credit to Erik Aigner for this code snippet
// https://stackoverflow.com/users/187676/erik-aigner
// https://stackoverflow.com/questions/25207077/how-to-detect-if-os-x-is-in-dark-mode
func isDarkMode() -> Bool {
	if #available(OSX 10.14, *) {
			switch NSAppearance.current.name {
			case .darkAqua, .vibrantDark, .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark:
                return true
            default:
                return false
            }
        } else {
		switch NSAppearance.current.name {
		case .vibrantDark:
			return true
		default:
			return false
		}
	}
}
