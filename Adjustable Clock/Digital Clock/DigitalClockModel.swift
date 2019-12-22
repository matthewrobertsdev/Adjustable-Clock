//
//  TextClockModel.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 3/22/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Cocoa
class DigitalClockModel{
	//properties
	var fullscreen=false
	var color=""
    var clockNSColors=ColorDictionary()
	var showDayInfo=false
	var updateTime=1000
	var timeSizeRatio=CGFloat(0.25)
	var dateSizeRatio=CGFloat(0.25)
	var dockTimeString=""
	var dockDateString=""
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
	//constant properties
	//for time max sizes
    let AM_PM_MINUTES=CGFloat(0.25)
    let AM_PM_SECONDS=CGFloat(0.25)
    let MILITARY_MINUTES=CGFloat(0.36)
    let MILITARY_SECONDS=CGFloat(0.25)
    //for date max sizes
    let WEEKDAY_DATE=CGFloat(0.25)
    let WEEKDAY=CGFloat(0.20)
    let LONG_DATE=CGFloat(0.25)
    let WEEKDAY_NUMERICAL_DATE=CGFloat(0.25)
    let NUMERICAL_DATE=CGFloat(0.20)
    //for time intervals (miliseconds)
    let seconds=1000
    let deciseconds=100
    func useShowMinutesAMPM(){
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
        updateTime=seconds
		dockTimeString="--:--"
    }
    func useShowSecondsAMPM(){
        timeFormatter.setLocalizedDateFormatFromTemplate("hmmss")
        updateTime=seconds
		dockTimeString="--:--:--"
    }
    func useShowMinutes24Hour(){
        timeFormatter.setLocalizedDateFormatFromTemplate("Hmm")
        updateTime=seconds
		dockTimeString="--:--"
    }
    func useShowSeconds24Hour(){
		timeFormatter.setLocalizedDateFormatFromTemplate("Hmmss")
        updateTime=seconds
		dockTimeString="--:--:--"
    }
    func useWeekdayDate(){
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEMMMMd")
		dockDateString="--------"
    }
    func useWeekdayNumericalDate(){
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEMd")
		dockDateString="------"
    }
    func useLongDate(){
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
		dockDateString="----------"
    }
    func useNumericalDate(){
        dateFormatter.setLocalizedDateFormatFromTemplate("Mdyyyy")
		dockDateString="----"
    }
    func useWeekDay(){
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
		dockTimeString="----"
    }
    func setLocaleToEnglishUS(){
        timeFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.locale = Locale(identifier: "en_US")
    }
    func getTime()->String{
        let nowDate=Date()
        return timeFormatter.string(from: nowDate)
    }
    
    func getDayInfo()->String{
        let nowDate=Date()
		return dateFormatter.string(from: nowDate)
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
