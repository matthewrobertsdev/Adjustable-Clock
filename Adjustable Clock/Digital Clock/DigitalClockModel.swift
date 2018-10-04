//
//  TextClockModel.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 3/22/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Cocoa

/*
 Time
 Time seconds or no seconds
 24 hour or 12 hour
 Date
 Date or no date
 Day of week or no day of week
 If just date, show year
 Numerical or not numerical
 If numerical, always show year
 */

class DigitalClockModel{
    
    var fullscreen = false
    
    var color=""
    
    var clockNSColors=ClockNSColors()
    var standardColors: [String:(NSColor,NSColor)]!
    var colorChoice: ColorChoice!
    
    var timeSizeRatio=CGFloat(0.25)
    var dateSizeRatio=CGFloat(0.25)
    
    let AM_PM_MINUTES=CGFloat(0.25)
    let AM_PM_SECONDS=CGFloat(0.25)
    let MILITARY_MINUTES=CGFloat(0.36)
    let MILITARY_SECONDS=CGFloat(0.25)
    
    let WEEKDAY_DATE=CGFloat(0.25)
    let WEEKDAY=CGFloat(0.20)
    let LONG_DATE=CGFloat(0.25)
    let WEEKDAY_NUMERICAL_DATE=CGFloat(0.25)
    let NUMERICAL_DATE=CGFloat(0.20)
    
    let seconds=1000
    let deciseconds=100
    
    init(){
        //standardColors=clockNSColors.standardColors
    }
    
    var timeFormatter = DateFormatter()
    var dateFormatter = DateFormatter()
    
    var showDayInfo=false
    
    var updateTime=1000
    
    func useShowMinutesAMPM(){
        timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
        updateTime=seconds
    }
    func useShowSecondsAMPM(){
        timeFormatter.setLocalizedDateFormatFromTemplate("hmmss")
        updateTime=deciseconds
    }
    func useShowMinutes24Hour(){
        timeFormatter.setLocalizedDateFormatFromTemplate("Hmm")
        updateTime=seconds
    }
    func useShowSeconds24Hour(){
        timeFormatter.setLocalizedDateFormatFromTemplate("Hmmss")
        updateTime=deciseconds
    }
    
    func useWeekdayDate(){
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEMMMMd")
    }
    
    func useWeekdayNumericalDate(){
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEMd")
    }
    
    func useLongDate(){
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
    }
    
    func useNumericalDate(){
        dateFormatter.setLocalizedDateFormatFromTemplate("Mdyyyy")
    }
    
    func useWeekDay(){
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
    }
    
    func setLocaleToEnglishUS(){
        timeFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.locale = Locale(identifier: "en_US")
    }
    
    func getTime()->String{
        let nowDate=Date()
        let time=timeFormatter.string(from: nowDate)
        //print(time.description)
        return time
    }
    
    func getDayInfo()->String{
        let nowDate=Date()
        let date=dateFormatter.string(from: nowDate)
        //print(date.description)
        return date
    }
    
    func updateClockModelForPreferences(){
        if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek{
            showDayInfo=true
        }
        if !ClockPreferencesStorage.sharedInstance.use24hourClock{
            if !ClockPreferencesStorage.sharedInstance.showSeconds{
                useShowMinutesAMPM()
                timeSizeRatio=AM_PM_MINUTES
            }
            else{
                useShowSecondsAMPM()
                timeSizeRatio=AM_PM_SECONDS
            }
        }
        else{
            if !ClockPreferencesStorage.sharedInstance.showSeconds{
                useShowMinutes24Hour()
                timeSizeRatio=MILITARY_MINUTES
            }
            else{
                useShowSeconds24Hour()
                timeSizeRatio=MILITARY_SECONDS
            }
        }
        if showDayInfo==true{
            if !ClockPreferencesStorage.sharedInstance.showDate{
                if !ClockPreferencesStorage.sharedInstance.showDayOfWeek{
                    //clock will not actually use this model
                    useWeekdayDate()
                    dateSizeRatio=WEEKDAY_DATE
                }
                else{
                    useWeekDay()
                    dateSizeRatio=WEEKDAY
                }
                
            }
            else{
                if !ClockPreferencesStorage.sharedInstance.showDayOfWeek{
                    //clock will not actually use this model
                    if !ClockPreferencesStorage.sharedInstance.useNumericalDate{
                        useLongDate()
                        dateSizeRatio=LONG_DATE
                    }
                    else{
                        useNumericalDate()
                        dateSizeRatio=NUMERICAL_DATE
                    }
                }
                else{
                    if !ClockPreferencesStorage.sharedInstance.useNumericalDate{
                        useWeekdayDate()
                        dateSizeRatio=WEEKDAY_DATE
                    }
                    else{
                        useWeekdayNumericalDate()
                        dateSizeRatio=WEEKDAY_NUMERICAL_DATE
                    }
                }
            }
        }
    }
    
}
