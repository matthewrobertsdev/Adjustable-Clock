//
//  PreferencesModel.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 6/12/18.
//  Copyright © 2018 Celeritas Apps. All rights reserved.
//

import AppKit

class PreferenceModel{
    var standardColorOrder: [String]!
    var standardColorOrderV2: [String]!
    var standardColors: [String:(NSColor,NSColor)]!
    
    init(){
        let colorOrders=ColorOrders()
        standardColorOrder=colorOrders.standardColorsOrder
        let clockNSColors=ClockNSColors()
        standardColors=clockNSColors.standardColors
        standardColorOrderV2=colorOrders.standardColorsOrderV2
    }
}
