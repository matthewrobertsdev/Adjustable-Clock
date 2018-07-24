//
//  PreferencesVCModel.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 6/7/18.
//  Copyright © 2018 Celeritas Apps. All rights reserved.
//


/*
 color order--just strings (or enums)
 */

import Foundation

class ColorOrders{
    var standardColorsOrder=[String]()
    var standardColorsOrderV2=[String]()
    
    //not sure about this
    var colorTitleDictioary=[String: String]()
    
    init(){
        makeStandardColorOrder()
        makeStandardColorOrderV2()
    }
    
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
    
    func makeStandardColorOrderV2(){
        standardColorsOrderV2.append(ColorChoice.gray)
        standardColorsOrderV2.append(ColorChoice.white)
        standardColorsOrderV2.append(ColorChoice.red)
        standardColorsOrderV2.append(ColorChoice.orange)
        standardColorsOrderV2.append(ColorChoice.yellow)
        standardColorsOrderV2.append(ColorChoice.green)
        standardColorsOrderV2.append(ColorChoice.blue)
        standardColorsOrderV2.append(ColorChoice.purple)
        standardColorsOrderV2.append(ColorChoice.custom)
    }

}
