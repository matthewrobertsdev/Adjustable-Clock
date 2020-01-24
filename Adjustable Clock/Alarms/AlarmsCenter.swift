//
//  AlarmsStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class AlarmCenter: NSObject {
	static let sharedInstance=AlarmCenter()
	var alarmProtocol: NSObjectProtocol?
	let calendar=Calendar.current
	override private init() {
	}
	private var alarms=[Alarm]()
	func addAlarm(alarm: Alarm) {
		alarms.append(alarm)
		count+=1
	}
	func getAlarm(index: Int) -> Alarm {
		return alarms[index]
	}
	func getActiveAlarms() -> Int {
		var activeCount=0
		for alarm in alarms{
			if alarm.active {
				activeCount+=1
			}
		}
		return activeCount
	}
	func scheduleAlarms(){
		
	}
	func scheduleAlarm(alarm: Alarm) {
		if alarm.active {
			var tomorrow=false
			let now=Date()
			let hour=calendar.dateComponents([.hour], from: now).hour ?? 0
			let minute=calendar.dateComponents([.minute], from: now).minute ?? 0
			let alarmHour=calendar.dateComponents([.hour], from: alarm.date).hour ?? 0
			let alarmMinute=calendar.dateComponents([.minute], from: alarm.date).minute ?? 0
			if hour>alarmHour {
				tomorrow=true
			}
			if hour==alarmHour && minute>=alarmMinute {
				tomorrow=true
			}
			//get difference and schedule
		}
	}
	@objc dynamic var count=0
	func startAlarms(){
		if getActiveAlarms() > 0 {
		alarmProtocol = ProcessInfo().beginActivity(options: .userInitiatedAllowingIdleSystemSleep, reason: "So alarms can go off")
		}
	}
}
