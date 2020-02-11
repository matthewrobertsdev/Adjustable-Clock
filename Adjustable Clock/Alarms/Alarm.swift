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
	var expiresDate=Date()
	var usesSong: Bool
	var repeats: Bool
	var alertString="Ping"
	var song=""
	var active=false
	init(time: Date, usesSong: Bool, repeats: Bool, alert: String, song: String, active: Bool) {
		self.time=time
		self.usesSong=usesSong
		self.repeats=repeats
		self.alertString=alert
		self.song=song
		self.active=active
		setExpirationDate(currentDate: Date())
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
