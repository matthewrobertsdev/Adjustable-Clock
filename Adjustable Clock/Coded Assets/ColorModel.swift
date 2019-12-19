//
//  ColorModel.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 6/2/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Cocoa

/*
Color Choice
    for keys for easily referring to colors or saving a choice
    strings that act as keys for selecting colors
Clock Colors
    for use as colors for the app
    NSColors that have values for currently used colors
Clock Dictionary
    for accessing an NSColor by a color choice string
    color choices act as keys for NSColors
Color Arrays
    for sequential order
    color choice arrays that give a sequential order to the color choices
 */



//standard colors and custom colors
//string "keys" are convenient for UserDefaults
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
    
}



//NSColors with values for current standard colors
class ClockColors{
    //mercury
	static let mercuryNSColor=NSColor.systemGray//NSColor(calibratedRed: 232/255, green: 232/255, blue: 232/255, alpha: 1)
    //red
	static let salmonNSColor=NSColor.systemRed//NSColor(calibratedRed: 1, green: 114/255, blue: 110/255, alpha: 1)
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



//color choice strings act as keys for NSColors
class ColorDictionary{
    
    //name-color dictionary
    //name for identification
    //color for actual color values
    var colorsDictionary=[String:NSColor]()
    
    //init should make the dictionary
    init(){
        makeColorDictionary()
    }
    
    //actually pair the keys with the colors
    func makeColorDictionary(){
        colorsDictionary[ColorChoice.gray]=ClockColors.mercuryNSColor
        colorsDictionary[ColorChoice.white]=NSColor.white
        colorsDictionary[ColorChoice.red]=ClockColors.salmonNSColor
        colorsDictionary[ColorChoice.orange]=ClockColors.tangurineNSColor
        colorsDictionary[ColorChoice.yellow]=ClockColors.lemonNSColor
        colorsDictionary[ColorChoice.green]=ClockColors.springNSColor
        colorsDictionary[ColorChoice.blue]=ClockColors.aquaNSColor
        colorsDictionary[ColorChoice.purple]=ClockColors.grapeNSColor
    }
    
}



//just an array of color choices so that the colors can be displayed in an order
class ColorArrays{
    
    //an array of color choice strings
    var standardColorsArray=[String]()
    
    //init should make the array
    init(){
        makeStandardColorArray()
    }
    
    //put color choice strings in the standard order
    func makeStandardColorArray(){
        standardColorsArray.append(ColorChoice.gray)
        standardColorsArray.append(ColorChoice.white)
        standardColorsArray.append(ColorChoice.red)
        standardColorsArray.append(ColorChoice.orange)
        standardColorsArray.append(ColorChoice.yellow)
        standardColorsArray.append(ColorChoice.green)
        standardColorsArray.append(ColorChoice.blue)
        standardColorsArray.append(ColorChoice.purple)
        standardColorsArray.append(ColorChoice.custom)
    }
    
}
