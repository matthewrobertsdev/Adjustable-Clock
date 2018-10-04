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
    
    var standardColors=[String:(NSColor,NSColor)]()
    var standardColorsV2=[String:NSColor]()
    
    init(){
        if #available(OSX 10.13, *) {
            standardColors[ClockNSColors.blackOnMercury]=(NSColor(named: NSColor.Name(rawValue: "Black")),NSColor(named: NSColor.Name(rawValue: "Mercury"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.aquaOnBlack]=(NSColor(named: NSColor.Name(rawValue: "Aqua")),NSColor(named: NSColor.Name(rawValue: "Black"))) as? (NSColor, NSColor)
            
            
            standardColors[ClockNSColors.whiteOnBlack]=(NSColor(named: NSColor.Name(rawValue: "White")),NSColor(named: NSColor.Name(rawValue: "Black"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.mercuryOnBlack]=(NSColor(named: NSColor.Name(rawValue: "Mercury")),NSColor(named: NSColor.Name(rawValue: "Black"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.salmonOnBlack]=(NSColor(named: NSColor.Name(rawValue: "Salmon")),NSColor(named: NSColor.Name(rawValue: "Black"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.tangurineOnBlack]=(NSColor(named: NSColor.Name(rawValue: "Tangurine")),NSColor(named: NSColor.Name(rawValue: "Black"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.lemonOnBlack]=(NSColor(named: NSColor.Name(rawValue: "Lemon")),NSColor(named: NSColor.Name(rawValue: "Black"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.springOnBlack]=(NSColor(named: NSColor.Name(rawValue: "Spring")),NSColor(named: NSColor.Name(rawValue: "Black"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.grapeOnBlack]=(NSColor(named: NSColor.Name(rawValue: "Grape")),NSColor(named: NSColor.Name(rawValue: "Black"))) as? (NSColor, NSColor)
            
            
            
            standardColors[ClockNSColors.blackOnWhite]=(NSColor(named: NSColor.Name(rawValue: "Black")),NSColor(named: NSColor.Name(rawValue: "White"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.blackOnSalmon]=(NSColor(named: NSColor.Name(rawValue: "Black")),NSColor(named: NSColor.Name(rawValue: "Salmon"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.blackOnTangurine]=(NSColor(named: NSColor.Name(rawValue: "Black")),NSColor(named: NSColor.Name(rawValue: "Tangurine"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.blackOnLemon]=(NSColor(named: NSColor.Name(rawValue: "Black")),NSColor(named: NSColor.Name(rawValue: "Lemon"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.blackOnSpring]=(NSColor(named: NSColor.Name(rawValue: "Black")),NSColor(named: NSColor.Name(rawValue: "Spring"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.blackOnAqua]=(NSColor(named: NSColor.Name(rawValue: "Black")),NSColor(named: NSColor.Name(rawValue: "Aqua"))) as? (NSColor, NSColor)
            
            standardColors[ClockNSColors.blackOnGrape]=(NSColor(named: NSColor.Name(rawValue: "Black")),NSColor(named: NSColor.Name(rawValue: "Grape"))) as? (NSColor, NSColor)
            
        } else {
            // Fallback on earlier versions
            standardColors[ClockNSColors.blackOnMercury] =
                (NSColor.black, ClockNSColors.mercuryNSColor)
            
            standardColors[ClockNSColors.aquaOnBlack] =
                (ClockNSColors.aquaNSColor, NSColor.black)
            
            
            standardColors[ClockNSColors.whiteOnBlack] =
                (NSColor.white, NSColor.black)
            
            standardColors[ClockNSColors.mercuryOnBlack] =
                (ClockNSColors.mercuryNSColor, NSColor.black)
            
            standardColors[ClockNSColors.salmonOnBlack] =
                (ClockNSColors.salmonNSColor, NSColor.black)
            
            standardColors[ClockNSColors.tangurineOnBlack] =
                (ClockNSColors.tangurineNSColor, NSColor.black)
            
            standardColors[ClockNSColors.lemonOnBlack] =
                (ClockNSColors.lemonNSColor, NSColor.black)
            
            standardColors[ClockNSColors.springOnBlack] =
                (ClockNSColors.springNSColor, NSColor.black)
            
            standardColors[ClockNSColors.grapeOnBlack] =
                (ClockNSColors.grapeNSColor, NSColor.black)
            
            
            standardColors[ClockNSColors.blackOnWhite] =
                (NSColor.black, NSColor.white)
            
            standardColors[ClockNSColors.blackOnSalmon] =
                (NSColor.black, ClockNSColors.salmonNSColor)
            
            standardColors[ClockNSColors.blackOnTangurine] =
                (NSColor.black, ClockNSColors.tangurineNSColor)
            
            standardColors[ClockNSColors.blackOnLemon] =
                (NSColor.black, ClockNSColors.lemonNSColor)
            
            standardColors[ClockNSColors.blackOnSpring] =
                (NSColor.black, ClockNSColors.springNSColor)
            
            standardColors[ClockNSColors.blackOnAqua] =
                (NSColor.black, ClockNSColors.aquaNSColor)
            
            standardColors[ClockNSColors.blackOnGrape] =
                (NSColor.black, ClockNSColors.grapeNSColor)

        }
        
        makeStandardColorsV2()
    }
    
    func makeStandardColorsV2(){
        standardColorsV2[ColorChoice.gray]=ClockNSColors.mercuryNSColor
            standardColorsV2[ColorChoice.white]=NSColor.white
        standardColorsV2[ColorChoice.red]=ClockNSColors.salmonNSColor
        standardColorsV2[ColorChoice.orange]=ClockNSColors.tangurineNSColor
        standardColorsV2[ColorChoice.yellow]=ClockNSColors.lemonNSColor
        standardColorsV2[ColorChoice.green]=ClockNSColors.springNSColor
        standardColorsV2[ColorChoice.blue]=ClockNSColors.aquaNSColor
        standardColorsV2[ColorChoice.purple]=ClockNSColors.grapeNSColor
    }
    
    static let blackOnMercury="blackOnMercury"
    static let aquaOnBlack="aquaOnBlack"
    
    static let whiteOnBlack="whiteOnBlack"
    static let mercuryOnBlack="murcuryOnBlack"
    static let salmonOnBlack="salmonOnBlack"
    static let tangurineOnBlack="tangurineOnBlack"
    static let lemonOnBlack="lemonOnBlack"
    static let springOnBlack="springOnBlack"
    static let grapeOnBlack="grapeOnBlack"
    
    static let blackOnWhite="blackOnWhite"
    static let blackOnSalmon="blackOnSalmon"
    static let blackOnTangurine="blackOnTangurine"
    static let blackOnLemon="blackOnLemon"
    static let blackOnSpring="blackOnSpring"
    static let blackOnAqua="blackOnAqua"
    static let blackOnGrape="blackOnGrape"
    
    static let gray="gray"
    static let white="white"
    static let red="red"
    static let orange="orange"
    static let yellow="yellow"
    static let green="green"
    static let blue="blue"
    static let purple="purple"
    
    
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
    
    static let darkGrayNSColor=NSColor(calibratedRed: 111/255, green: 111/255, blue: 111/255, alpha: 1)
}
