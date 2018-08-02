//
//  ClockPreferencesModel.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 6/10/18.
//  Copyright © 2018 Celeritas Apps. All rights reserved.
//

import Cocoa

/*
 In charge of retrieving from disk, storing in RAM, and saving to disk user preferences.
 It is a singleton (Except for some string keys used for saving)
 */

class ClockPreferencesStorage{
    
    static let sharedInstance=ClockPreferencesStorage()
    
    private init(){
        
    }
    
    let userDefaults=UserDefaults()
    
    var clockFloats = false
    var fullscreen = false
    
    var colorChoice: String!
    var lightOnDark=false
    
    var showSeconds=false
    var use24hourClock=false
    
    var showDate=true
    var showDayOfWeek=true
    var useNumericalDate=false
    
    var customColor: NSColor!
    
    var redComponent: CGFloat!
    var greenComponent: CGFloat!
    var blueComponent: CGFloat!
    
    static let clockWindowFloatsKey="clockWindowFloats"
    static let showSeocndsKey="showSeconds"
    static let use24hourClockKey="use24hourClock"
    static let showDateKey="showDate"
    static let showDayOfWeekKey="showDayOfWeek"
    static let useNumericalDateKey="useNumericalDateKey"
    static let colorSchemeKey="colorScheme"
    static let colorChoiceKey="colorChoice"
    static let lightOnDarkKey="lightOnDark"
    static let customRedComponentKey="customRedComponentKey"
    static let customGreenComponentKey="customGreenComponentKey"
    static let customBlueComponentKey="customBlueComponentKey"
    
    func loadUserPreferences(){
        
        clockFloats=userDefaults.bool(forKey: ClockPreferencesStorage.clockWindowFloatsKey)
        
        ClockPreferencesStorage.sharedInstance.showSeconds=userDefaults.bool(forKey: ClockPreferencesStorage.showSeocndsKey)
        
        ClockPreferencesStorage.sharedInstance.use24hourClock=userDefaults.bool(forKey: ClockPreferencesStorage.use24hourClockKey)
        
        ClockPreferencesStorage.sharedInstance.showDate=userDefaults.bool(forKey: ClockPreferencesStorage.showDateKey)
        
        ClockPreferencesStorage.sharedInstance.showDayOfWeek=userDefaults.bool(forKey: ClockPreferencesStorage.showDayOfWeekKey)
        
        ClockPreferencesStorage.sharedInstance.useNumericalDate=userDefaults.bool(forKey: ClockPreferencesStorage.useNumericalDateKey)
        
        
        if let colorChoice=userDefaults.string(forKey: ClockPreferencesStorage.colorChoiceKey){
            ClockPreferencesStorage.sharedInstance.colorChoice=colorChoice
        }
        else{
            ClockPreferencesStorage.sharedInstance.colorChoice=ColorChoice.gray
        }
        
        ClockPreferencesStorage.sharedInstance.lightOnDark=userDefaults.bool(forKey: ClockPreferencesStorage.lightOnDarkKey)
        
        ClockPreferencesStorage.sharedInstance.redComponent=CGFloat(userDefaults.float(forKey: ClockPreferencesStorage.customRedComponentKey))
        
        ClockPreferencesStorage.sharedInstance.greenComponent=CGFloat(userDefaults.float(forKey: ClockPreferencesStorage.customGreenComponentKey))
        
        ClockPreferencesStorage.sharedInstance.blueComponent=CGFloat(userDefaults.float(forKey: ClockPreferencesStorage.customBlueComponentKey))
        
        let redComponent=ClockPreferencesStorage.sharedInstance.redComponent
        let blueComponent=ClockPreferencesStorage.sharedInstance.blueComponent
        let greenComponent=ClockPreferencesStorage.sharedInstance.greenComponent
        
        ClockPreferencesStorage.sharedInstance.customColor=NSColor(deviceRed: redComponent!, green: greenComponent!, blue: blueComponent!, alpha: 1)
        
    }
    
    func changeAndSaveUseAmPM(){
        print("should change hour mode")
        use24hourClock=(!use24hourClock)
        userDefaults.set(use24hourClock, forKey: ClockPreferencesStorage.use24hourClockKey)
    }
    func changeAndSaveUseSeconds(){
        print("should change show seconds")
        showSeconds=(!showSeconds)
        userDefaults.set(showSeconds, forKey: ClockPreferencesStorage.showSeocndsKey)
    }
    
    func changeAndSaveShowDate(){
        print("should change show date")
        showDate=(!showDate)
        userDefaults.set(showDate, forKey: ClockPreferencesStorage.showDateKey)
    }
    
    func changeAndSaveShowDofW(){
        print("should change show day of week")
        showDayOfWeek=(!showDayOfWeek)
        userDefaults.set(showDayOfWeek, forKey: ClockPreferencesStorage.showDayOfWeekKey)
    }
    
    func changeAndSaveUseNumericalDate(){
        print("should change use numerical date")
        useNumericalDate=(!useNumericalDate)
        userDefaults.set(useNumericalDate, forKey: ClockPreferencesStorage.useNumericalDateKey)
    }
    
    func changeAndSaveLonD(){
        print("should change light on dark")
        lightOnDark=(!lightOnDark)
        userDefaults.set(lightOnDark, forKey: ClockPreferencesStorage.lightOnDarkKey)
    }
    
    func changeAndSaveColorSceme(colorChoice: String){
        print("saving color "+colorChoice)
        self.colorChoice=colorChoice
        userDefaults.set(self.colorChoice, forKey: ClockPreferencesStorage.colorChoiceKey)
    }
    func changeAndSaveClockFloats(){
        print("should change clock floats")
        clockFloats=(!clockFloats)
        userDefaults.set(clockFloats, forKey: ClockPreferencesStorage.clockWindowFloatsKey)
    }
    
    func changeAndSaveCustomColor(customColor: NSColor){
        print("should change custom color "+customColor.description)
        
        self.customColor=customColor.usingColorSpace(NSColorSpace.deviceRGB)
        self.colorChoice=ColorChoice.custom
        
        userDefaults.set("custom", forKey: ClockPreferencesStorage.colorChoiceKey)
        
        redComponent=self.customColor.redComponent
        userDefaults.set(redComponent, forKey: ClockPreferencesStorage.customRedComponentKey)
        greenComponent=self.customColor.greenComponent
        userDefaults.set(greenComponent, forKey: ClockPreferencesStorage.customGreenComponentKey)
        blueComponent=self.customColor.blueComponent
        userDefaults.set(blueComponent, forKey: ClockPreferencesStorage.customBlueComponentKey)
    }
    
}
