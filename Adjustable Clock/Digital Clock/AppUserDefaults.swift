//
//  DefaultUserDefaults.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/20/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
struct AppUserDefaults {
    let userDefaults=UserDefaults()
	//mins and maxs
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
        userDefaults.set(false, forKey: AppUserDefaults.clockWindowFloatsKey)
        userDefaults.set(false, forKey: AppUserDefaults.showSeocndsKey)
        userDefaults.set(false, forKey: AppUserDefaults.use24hourClockKey)
        userDefaults.set(false, forKey: AppUserDefaults.showDateKey)
        userDefaults.set("", forKey: AppUserDefaults.colorSchemeKey)
    }
}
