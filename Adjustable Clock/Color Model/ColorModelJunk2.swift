//
//  PreferencesModel.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 6/12/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
/*
import AppKit
 
 //case gray, white, red, orange, yellow, green, blue, purple
 /*
 case black
 case gray
 case white
 case red
 case orange
 case yellow
 case green
 case blue
 case purple
 */

class ColorModel{
    var standardColors: [String:NSColor]
    var standardColorOrder: [String]
    
    init(){
        let colorOrders=ColorOrders()
        standardColorOrder=colorOrders.standardColorsOrder
        let clockNSColors=ClockNSColors()
        standardColors=clockNSColors.standardColors
    }
}
 */
