//
//  Architecture and Pseudocode.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 7/2/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Foundation

/*
 Loading and Saving State
    Load window position and origin
 Digital Clock Window and Content
    LoadUserPreferences
 
    Window
        Load Window
        UpdateClock
        Resize
            resize text
            new aspect ratio
        Close
            Save if not fullscreen
    Content
        updateClockModel()
        applyColorScheme()
        applyFloatState()
        animateClock()
        resizeClock()
 Main Menu
    updateUI
    change ClockPreferences Storage and updateForPreferences
        updateClock
        updateClockMenuUI
        updatePreferencesUI
 Preferences Stuff
    updateUI
    change ClockPreferences Storage and updateForPreferences
        updateClock
        updateClockMenuUI
        updatePreferencesUI
    resetPreferences
    ClockPreferencesStorage
        loadPreferences
 Utilities
    Check if clock window exists
    Check if prefrences window exists
 Coded Assets
    Color Orders
    Clock Colors
 */
