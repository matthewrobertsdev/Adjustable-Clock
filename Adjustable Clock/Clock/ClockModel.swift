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
	var showDayInfo=false
	var updateTime=1000
	var dockTimeString="", dockDateString=""
	let timeFormatter = DateFormatter(), dateFormatter = DateFormatter()
	//for time intervals (miliseconds)
	let seconds=1000
	//current height and width
	var width=CGFloat(332), height=CGFloat(151)
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
		if ClockPreferencesStorage.sharedInstance.showDate
			|| ClockPreferencesStorage.sharedInstance.showDayOfWeek {
			showDayInfo=true
		} else {
			showDayInfo=false
		}
		if ClockPreferencesStorage.sharedInstance.useAnalog==false {
			if GeneralPreferencesStorage.sharedInstance.use24Hours==false {
				if ClockPreferencesStorage.sharedInstance.showSeconds==false {
					useShowMinutesAMPM()
					if ClockPreferencesStorage.sharedInstance.showDate && !ClockPreferencesStorage.sharedInstance.showDayOfWeek {
						width=CGFloat(400); height=CGFloat(151)
					} else {
						width=CGFloat(332); height=CGFloat(151)
					}
				} else {
					useShowSecondsAMPM(); width=CGFloat(460); height=CGFloat(180)
				}
			} else {
				if ClockPreferencesStorage.sharedInstance.showSeconds==false {
					useShowMinutes24Hour(); width=CGFloat(332); height=CGFloat(151)
				} else {
					useShowSeconds24Hour(); width=CGFloat(332); height=CGFloat(151)
				}
			}
		} else {
			width=CGFloat(460); height=CGFloat(460)
		}
		if showDayInfo {
			if ClockPreferencesStorage.sharedInstance.useAnalog {
				height=530
				if ClockPreferencesStorage.sharedInstance.showDate==false {
					if ClockPreferencesStorage.sharedInstance.showDayOfWeek==false {
						useWeekdayDate()
					} else { useWeekDay() }
				} else {
					if ClockPreferencesStorage.sharedInstance.showDayOfWeek==false {
						if ClockPreferencesStorage.sharedInstance.useNumericalDate==false {
							useLongDate()
						} else {
							useNumericalDate()
						}
					} else {
						if ClockPreferencesStorage.sharedInstance.useNumericalDate==false {
							useWeekdayDate()
						} else {
							useWeekdayNumericalDate()
						}
					}
				}
			} else {
				if ClockPreferencesStorage.sharedInstance.showDate==false {
					if ClockPreferencesStorage.sharedInstance.showDayOfWeek==false {
						useWeekdayDate(); height=140
					} else { useWeekDay() }
				} else {
					if ClockPreferencesStorage.sharedInstance.showDayOfWeek==false {
						if ClockPreferencesStorage.sharedInstance.useNumericalDate==false {
							useLongDate()
						} else {
							useNumericalDate()
						}
					} else {
						if ClockPreferencesStorage.sharedInstance.useNumericalDate==false {
							useWeekdayDate(); width=CGFloat(460); height=CGFloat(180)
						} else {
							useWeekdayNumericalDate()
						}
					}
				}
			}
		} else {
			if ClockPreferencesStorage.sharedInstance.useAnalog==false {
				height=140
			} else {
				width=CGFloat(460); height=CGFloat(460)
			}
		}
	}
}
