//
//  TextClockModel.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 3/22/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Cocoa
class ClockModel {
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
    let amPmMinutes=CGFloat(0.25)
    let amPmSeconds=CGFloat(0.25)
    let miltrayMinutes=CGFloat(0.36)
    let militarySaeconds=CGFloat(0.25)
    //for date max sizes
    let weekdayDate=CGFloat(0.25)
    let weekday=CGFloat(0.20)
    let longDate=CGFloat(0.25)
    let weekdayNumericalDate=CGFloat(0.25)
    let numericalDate=CGFloat(0.20)
    //for time intervals (miliseconds)
    let seconds=1000
    let deciseconds=100
    func useShowMinutesAMPM() {
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
        updateTime=seconds
		dockTimeString="--:--"
    }
    func useShowSecondsAMPM() {
        timeFormatter.setLocalizedDateFormatFromTemplate("hmmss")
        updateTime=seconds
		dockTimeString="--:--:--"
    }
    func useShowMinutes24Hour() {
        timeFormatter.setLocalizedDateFormatFromTemplate("Hmm")
        updateTime=seconds
		dockTimeString="--:--"
    }
    func useShowSeconds24Hour() {
		timeFormatter.setLocalizedDateFormatFromTemplate("Hmmss")
        updateTime=seconds
		dockTimeString="--:--:--"
    }
    func useWeekdayDate() {
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEMMMMd")
		dockDateString="--------"
    }
    func useWeekdayNumericalDate() {
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEMd")
		dockDateString="------"
    }
    func useLongDate() {
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
		dockDateString="----------"
    }
    func useNumericalDate() {
        dateFormatter.setLocalizedDateFormatFromTemplate("Mdyyyy")
		dockDateString="----"
    }
    func useWeekDay() {
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
		dockTimeString="----"
    }
    func setLocaleToEnglishUS() {
        timeFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.locale = Locale(identifier: "en_US")
    }
    func getTime() -> String {
        let nowDate=Date()
        return timeFormatter.string(from: nowDate)
    }
    func getDayInfo() -> String {
        let nowDate=Date()
		return dateFormatter.string(from: nowDate)
    }
    func updateClockModelForPreferences() {
        if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
            showDayInfo=true
        }
        if ClockPreferencesStorage.sharedInstance.use24hourClock==false {
            if ClockPreferencesStorage.sharedInstance.showSeconds==false {
                useShowMinutesAMPM()
                timeSizeRatio=amPmMinutes
            } else {
                useShowSecondsAMPM()
                timeSizeRatio=amPmSeconds
            }
        } else {
            if ClockPreferencesStorage.sharedInstance.showSeconds==false {
                useShowMinutes24Hour()
                timeSizeRatio=miltrayMinutes
            } else {
                useShowSeconds24Hour()
                timeSizeRatio=militarySaeconds
            }
        }
        if showDayInfo==true {
            if ClockPreferencesStorage.sharedInstance.showDate==false {
                if ClockPreferencesStorage.sharedInstance.showDayOfWeek==false {
                    useWeekdayDate()
                    dateSizeRatio=weekdayDate
                } else {
                    useWeekDay()
                    dateSizeRatio=weekday
                }
            } else {
                if ClockPreferencesStorage.sharedInstance.showDayOfWeek==false {
                    if ClockPreferencesStorage.sharedInstance.useNumericalDate==false {
                        useLongDate()
                        dateSizeRatio=longDate
                    } else {
                        useNumericalDate()
                        dateSizeRatio=numericalDate
                    }
                } else {
                    if ClockPreferencesStorage.sharedInstance.useNumericalDate==false {
                        useWeekdayDate()
                        dateSizeRatio=weekdayDate
                    } else {
                        useWeekdayNumericalDate()
						dateSizeRatio=weekdayNumericalDate
                    }
                }
            }
        }
    }
}
