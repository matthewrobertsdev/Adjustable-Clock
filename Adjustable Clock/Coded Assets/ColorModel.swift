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
	static let black="black"
    static let gray="gray"
    static let white="white"
    static let red="red"
    static let orange="orange"
    static let yellow="yellow"
    static let green="green"
    static let blue="blue"
	static let indigo="indigo"
    static let purple="purple"
	static let pink="pink"
	static let brown="brown"
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
		colorsDictionary=[ColorChoice.black:NSColor.black,
			ColorChoice.gray:NSColor.systemGray,
			ColorChoice.white:NSColor.white,
			ColorChoice.red:NSColor.systemRed,
			ColorChoice.orange:NSColor.systemOrange,
			ColorChoice.yellow:NSColor.systemYellow,
			ColorChoice.green:NSColor.systemGreen,
			ColorChoice.blue:NSColor.systemBlue,
			ColorChoice.purple:NSColor.systemPurple,
			ColorChoice.pink:NSColor.systemPink,
			ColorChoice.brown:NSColor.systemBrown]
    }
}
//just an array of color choices so that the colors can be displayed in an order
class ColorArrays{
    //an array of color choice strings
    var colorArray=[String]()
    //init should make the array
    init(){
        makeColorArray()
    }
    //put color choice strings in the standard order
    func makeColorArray(){
		colorArray.append(ColorChoice.black)
        colorArray.append(ColorChoice.gray)
		colorArray.append(ColorChoice.white)
        colorArray.append(ColorChoice.red)
        colorArray.append(ColorChoice.orange)
        colorArray.append(ColorChoice.yellow)
        colorArray.append(ColorChoice.green)
        colorArray.append(ColorChoice.blue)
        colorArray.append(ColorChoice.purple)
		colorArray.append(ColorChoice.pink)
		colorArray.append(ColorChoice.brown)
        colorArray.append(ColorChoice.custom)
    }
}
