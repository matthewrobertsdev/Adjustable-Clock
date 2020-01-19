//
//  NSViewDetectDarkModeExtension.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/17/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
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