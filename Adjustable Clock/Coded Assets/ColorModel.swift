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
    static let labelColor="labelColor"
    static let red="red"
    static let orange="orange"
    static let yellow="yellow"
    static let green="green"
    static let blue="blue"
    static let purple="purple"
    static let custom="custom"
    
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
		colorsDictionary[ColorChoice.gray]=NSColor.systemGray
		colorsDictionary[ColorChoice.labelColor]=NSColor.labelColor
		colorsDictionary[ColorChoice.red]=NSColor.systemRed
		colorsDictionary[ColorChoice.orange]=NSColor.systemOrange
		colorsDictionary[ColorChoice.yellow]=NSColor.systemYellow
		colorsDictionary[ColorChoice.green]=NSColor.systemGreen
		colorsDictionary[ColorChoice.blue]=NSColor.systemBlue
		colorsDictionary[ColorChoice.purple]=NSColor.systemPurple
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
        standardColorsArray.append(ColorChoice.labelColor)
        standardColorsArray.append(ColorChoice.red)
        standardColorsArray.append(ColorChoice.orange)
        standardColorsArray.append(ColorChoice.yellow)
        standardColorsArray.append(ColorChoice.green)
        standardColorsArray.append(ColorChoice.blue)
        standardColorsArray.append(ColorChoice.purple)
        standardColorsArray.append(ColorChoice.custom)
    }
}
