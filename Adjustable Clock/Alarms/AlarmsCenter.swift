//
//  AlarmsStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class AlarmCenter: NSObject {
	static let sharedInstance=AlarmCenter()
	var alarmProtocol: NSObjectProtocol?
	let calendar=Calendar.current
	var updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
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
		for alarm in alarms {
			if alarm.active {
				activeCount+=1
			}
		}
		return activeCount
	}
	func scheduleAlarms() {
		for alarm in alarms {
			scheduleAlarm(alarm: alarm)
		}
	}
	func scheduleAlarm(alarm: Alarm) {
		print("abcd"+String(getTimeInterval(alarm: alarm)))
		updateTimer.schedule(deadline: .now()+getTimeInterval(alarm: alarm), repeating: .never, leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			print("playing")
			let alarmSound=NSSound(named: NSSound.Name("Ping"))
			alarmSound?.loops=true
			alarmSound?.play()
		}
		updateTimer.resume()
	}
	func getTimeInterval(alarm: Alarm) -> TimeInterval {
			var tomorrow=false
			let now=Date()
			let hour=calendar.dateComponents([.hour], from: now).hour ?? 0
			let minute=calendar.dateComponents([.minute], from: now).minute ?? 0
			let second=calendar.dateComponents([.second], from: now).second ?? 0
		let nanoseconds=calendar.dateComponents([.nanosecond], from: now).nanosecond ?? 0
			let alarmHour=calendar.dateComponents([.hour], from: alarm.date).hour ?? 0
			let alarmMinute=calendar.dateComponents([.minute], from: alarm.date).minute ?? 0
			let alarmSecond=calendar.dateComponents([.second], from: alarm.date).second ?? 0
			if hour>alarmHour {
				tomorrow=true
			}
			if hour==alarmHour && minute>=alarmMinute {
				tomorrow=true
			}
			var totalSeconds: Double=0
			totalSeconds+=Double((alarmHour-hour)*60*60)
			totalSeconds+=Double((alarmMinute-minute)*60)
			totalSeconds+=Double((alarmSecond-second))
			totalSeconds += Double(0-nanoseconds/1_000_000_000)
			if tomorrow {
				totalSeconds *= -1
				totalSeconds+=24*3600
			}
		return TimeInterval(exactly: totalSeconds) ?? 0
	}
	@objc dynamic var count=0
	func startAlarms() {
		if getActiveAlarms() > 0 {
		alarmProtocol = ProcessInfo().beginActivity(options: .userInitiatedAllowingIdleSystemSleep, reason: "So alarms can go off")
		}
	}
}
