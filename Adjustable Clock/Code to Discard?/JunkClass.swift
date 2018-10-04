//
//  JunkClass.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 10/4/18.
//  Copyright © 2018 Celeritas Apps. All rights reserved.
//

//var standardColorsOrderV2=[String]()

//not sure about this
//var colorTitleDictioary=[String: String]()

/*
 func makeStandardColorOrder(){
 standardColorsOrder.append(ClockNSColors.blackOnMercury)
 standardColorsOrder.append(ClockNSColors.blackOnWhite)
 standardColorsOrder.append(ClockNSColors.blackOnSalmon)
 standardColorsOrder.append(ClockNSColors.blackOnTangurine)
 standardColorsOrder.append(ClockNSColors.blackOnLemon)
 standardColorsOrder.append(ClockNSColors.blackOnSpring)
 standardColorsOrder.append(ClockNSColors.blackOnAqua)
 standardColorsOrder.append(ClockNSColors.blackOnGrape)
 
 standardColorsOrder.append(ClockNSColors.mercuryOnBlack)
 standardColorsOrder.append(ClockNSColors.whiteOnBlack)
 standardColorsOrder.append(ClockNSColors.salmonOnBlack)
 standardColorsOrder.append(ClockNSColors.tangurineOnBlack)
 standardColorsOrder.append(ClockNSColors.lemonOnBlack)
 standardColorsOrder.append(ClockNSColors.springOnBlack)
 standardColorsOrder.append(ClockNSColors.aquaOnBlack)
 standardColorsOrder.append(ClockNSColors.grapeOnBlack)
 }
 */

/*
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
 */

/*
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
 */
