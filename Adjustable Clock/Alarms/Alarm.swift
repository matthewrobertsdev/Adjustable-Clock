//
//  Alarm.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Robertss. All rights reserved.
//
import Foundation
class Alarm: Codable {
	var calendar=Calendar.current
	var time: Date
	var timeString: String
	var expiresDate=Date()
	var usesSong: Bool
	var repeats: Bool
	var alertString="Ping"
	var song=""
	var active=false
	init(time: Date, timeString: String, usesSong: Bool, repeats: Bool, alert: String, song: String, active: Bool) {
		self.time=time
		self.usesSong=usesSong
		self.repeats=repeats
		self.alertString=alert
		self.song=song
		self.active=active
		self.timeString=timeString
		setExpirationDate(currentDate: Date())
	}
	func getTimeString() -> String {
		if GeneralPreferencesStorage.sharedInstance.use24Hours {
			return get24HourTime()
		} else {
			return timeString
		}
	}
	func get24HourTime() -> String {
		var twentyFourHourString=""
		if timeString.hasPrefix("12") && timeString.hasSuffix("AM") {
			twentyFourHourString+="00:"
			let prefixString=timeString.dropLast(3)
			let components=prefixString.components(separatedBy: ":")
			twentyFourHourString+=components[1]
			return twentyFourHourString
		} else if timeString.hasSuffix("AM") &&
			!timeString.hasPrefix("10") && !timeString.hasPrefix("11") && !timeString.hasPrefix("12") {
			twentyFourHourString+="0"
			let prefixString=timeString.dropLast(3)
			let components=prefixString.components(separatedBy: ":")
			twentyFourHourString+=components[0]+":"+components[1]
			return twentyFourHourString
		} else if timeString.hasSuffix("AM") {
			let prefixString=timeString.dropLast(3)
			return String(prefixString)
		} else if timeString.hasPrefix("12") && timeString.hasSuffix("PM") {
			let prefixString=timeString.dropLast(3)
			let components=prefixString.components(separatedBy: ":")
			twentyFourHourString+=components[0]+":"+components[1]
			return twentyFourHourString
		} else {
			let prefixString=timeString.dropLast(3)
			let components=prefixString.components(separatedBy: ":")
			twentyFourHourString+=String((Int(components[0]) ?? 0)+12)+":"+components[1]
			return twentyFourHourString
		}
	}
	func setExpirationDate(currentDate: Date) {
		var tomorrow=false
		let hour=calendar.dateComponents([.hour], from: currentDate).hour ?? 0
		let minute=calendar.dateComponents([.minute], from: currentDate).minute ?? 0
		let alarmHour=calendar.dateComponents([.hour], from: time).hour ?? 0
		let alarmMinute=calendar.dateComponents([.minute], from: time).minute ?? 0
		let alarmSecond=calendar.dateComponents([.second], from: time).second ?? 0
		let alarmNanosecond=calendar.dateComponents([.nanosecond], from: time).minute ?? 0
		var alarmDateComponents=calendar.dateComponents([.day, .month, .year], from: currentDate)
		alarmDateComponents.hour=alarmHour
		alarmDateComponents.minute=alarmMinute
		alarmDateComponents.second=alarmSecond
		alarmDateComponents.nanosecond=alarmNanosecond
		if hour>alarmHour {
			tomorrow=true
		}
		if hour==alarmHour && minute>=alarmMinute {
			tomorrow=true
		}
		expiresDate=calendar.date(from: alarmDateComponents) ?? Date()
		if tomorrow {
			expiresDate=calendar.date(byAdding: .day, value: 1, to: expiresDate) ?? Date()
		}
	}
}
