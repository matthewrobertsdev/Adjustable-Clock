//
//  Analysis Master.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 6/18/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Foundation


/*
 ClockPreferencesStorage singleton
    --stores preferences
    --loads preferences
    --has keys
 Clock
    WC
    --loads preferences on windowDidLoad
    --calls updateClock() on windowDidLoad
    VC
    --has updateClock() method
    Model
    --has dateFormatters
    --has time info
    --has date info
    --has sizing info
 Preferences
    --loads prefrences
    --updates its own ui
    --calls updateClock() when prefences change
 
 
 
*/
