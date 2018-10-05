//
//  ClockColorsV2.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 6/2/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Cocoa

//these colors are paired
//an easier model might be too have individual colors,
//but for this pairing was (for now at least) considered desirable
//also designed to work with user defaults,
//this was one reason for pairing,
//but another kind of storage could have been used


struct ColorChoice{
    
    static let gray="gray"
    static let white="white"
    static let red="red"
    static let orange="orange"
    static let yellow="yellow"
    static let green="green"
    static let blue="blue"
    static let purple="purple"
    static let custom="custom"
    
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
}

class ClockNSColors{
    var standardColor=[String:NSColor]()
    
    init(){
        makeStandardColors()
    }
    
    func makeStandardColors(){
        standardColor[ColorChoice.gray]=ClockNSColors.mercuryNSColor
            standardColor[ColorChoice.white]=NSColor.white
        standardColor[ColorChoice.red]=ClockNSColors.salmonNSColor
        standardColor[ColorChoice.orange]=ClockNSColors.tangurineNSColor
        standardColor[ColorChoice.yellow]=ClockNSColors.lemonNSColor
        standardColor[ColorChoice.green]=ClockNSColors.springNSColor
        standardColor[ColorChoice.blue]=ClockNSColors.aquaNSColor
        standardColor[ColorChoice.purple]=ClockNSColors.grapeNSColor
    }
    
    //mercury
    static let mercuryNSColor=NSColor(calibratedRed: 232/255, green: 232/255, blue: 232/255, alpha: 1)
    //red
    static let salmonNSColor=NSColor(calibratedRed: 1, green: 114/255, blue: 110/255, alpha: 1)
    //orange
    static let tangurineNSColor=NSColor(calibratedRed: 255/255, green: 136/255, blue: 2/255, alpha: 1)
    //yellow
    static let lemonNSColor=NSColor(calibratedRed: 255/255, green: 250/255, blue: 3/255, alpha: 1)
    //green
    static let springNSColor=NSColor(calibratedRed: 5/255, green: 248/255, blue: 2/255, alpha: 1)
    //blue
    static let aquaNSColor=NSColor(calibratedRed: 0, green: 144/255, blue: 1, alpha: 1)
    //purple
    static let grapeNSColor=NSColor(calibratedRed: 137/255, green: 49/255, blue: 255/255, alpha: 1)
    //darkGray
    static let darkGrayNSColor=NSColor(calibratedRed: 111/255, green: 111/255, blue: 111/255, alpha: 1)
}

class ColorOrders{
    var standardColorsOrder=[String]()
    
    init(){
        makeStandardColorOrder()
    }
    
    func makeStandardColorOrder(){
        standardColorsOrder.append(ColorChoice.gray)
        standardColorsOrder.append(ColorChoice.white)
        standardColorsOrder.append(ColorChoice.red)
        standardColorsOrder.append(ColorChoice.orange)
        standardColorsOrder.append(ColorChoice.yellow)
        standardColorsOrder.append(ColorChoice.green)
        standardColorsOrder.append(ColorChoice.blue)
        standardColorsOrder.append(ColorChoice.purple)
        standardColorsOrder.append(ColorChoice.custom)
    }
    
}
