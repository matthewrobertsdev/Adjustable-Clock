//
//  NSViewDetectDarkModeExtension.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/17/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
//credit to Erik Aigner for this code snippet
// https://stackoverflow.com/users/187676/erik-aigner
// https://stackoverflow.com/questions/25207077/how-to-detect-if-os-x-is-in-dark-mode
import AppKit
extension NSView {
    var hasDarkAppearance: Bool {
        if #available(OSX 10.14, *) {
			switch NSApp.effectiveAppearance.name {
			case .darkAqua, .vibrantDark, .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark:
                return true
			default:
                return false
            }
        } else {
			switch effectiveAppearance.name {
			case .vibrantDark:
                return true
			default:
                return false
            }
        }
    }
}
