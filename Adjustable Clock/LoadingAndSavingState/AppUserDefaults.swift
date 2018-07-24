//
//  DefaultUserDefaults.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/20/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//

/*
 for setting defaults/restoring defaults
 --floats=false
 --seconds=false
 --keys
 --set the defaults
 --check if it has launched, if not set defaults
 --check if it has launched and return true or false
 */


import Cocoa

struct AppUserDefaults{
    
    //a user defaults instance
    let userDefaults=UserDefaults()
    
    /*
    //default is always FALSE
    //so we don't want it floating
    let clockWindowFloatsBool=false
    //and we don't want seconds
    let showSecondsBool=false
    //we don't want 24 hour mode
    let use24hourClock=false
    //we don't want the date
    let showDate=false
    //we don't want the day of the week
    //let showDayOfWeek=false
    let colorScheme=""
 */
    
    static let clockMinWidth: CGFloat=40;
    static let clockMinHeight: CGFloat=10;
    static let preferencesMinWidth: CGFloat=10
    static let referencesMinHeight: CGFloat=10
    
    //the keys
    static let clockWindowFloatsKey="clockWindowFloats"
    static let showSeocndsKey="showSeconds"
    static let use24hourClockKey="use24hourClock"
    static let showDateKey="showDate"
    static let showDayOfWeekKey="showDayOfWeek"
    static let colorSchemeKey="colorScheme"
    static let clockXPositionKey="clockXPosition"
    static let clockYPositionKey="clockYPosition"
    static let clockWidthKey="clockWidthKey"
    static let clockHeightKey="clockHeightKey"
    static let preferencesXPositionKey="preferencesXPositionKey"
    static let preferencesYPositionKey="preferencesYPositionKey"
    static let preferencesWidthKey="preferencesWidthKey"
    static let preferencesHeightKey="preferencesHeightKey"
    static let applicationHasLaunched="applicationHasLaunched"
    
    //just sets the default defaults
    func setDefaultUserDefaults(){
        print("Setting default user defaults")
        userDefaults.set(false, forKey: AppUserDefaults.clockWindowFloatsKey)
        userDefaults.set(false, forKey: AppUserDefaults.showSeocndsKey)
        userDefaults.set(false, forKey: AppUserDefaults.use24hourClockKey)
        userDefaults.set(false, forKey: AppUserDefaults.showDateKey)
       // userDefaults.set(showDayOfWeek, forKey: DefaultUserDefaults.showDayOfWeekKey)
        userDefaults.set("", forKey: AppUserDefaults.colorSchemeKey)
    }
    
    //to see if the appliucation has launched and set these defaults if it hasn't
    /*
    func checkIfFirstLaunchSetDefaults(){
        //check if it has launched
        let applicationHasLaunched=userDefaults.bool(forKey: "applicationHasLaunched")
        //for debug
        print("applicationHasLaunched is "+applicationHasLaunched.description+".")
        //if it hasn't launched, set the defaults
        if(!applicationHasLaunched){
            setDefaultUserDefaults()
        }
    }
 */
    
    //a function for simply checking if the application has launched before (does not set defaults even if it has not luanched)
    
    /*
    func checkIfAppplicationHasLaunchedBefore()->Bool{
        //check if it has launched
        let applicationHasLaunched=userDefaults.bool(forKey: "applicationHasLaunched")
        //for debug
        print("applicationHasLaunched is "+applicationHasLaunched.description+".")
        //return result
        if(applicationHasLaunched){
            return true
        }
        else{
            return false
        }
    }
 */
 
}
