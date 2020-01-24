//
//  AlarmsStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
class AlarmCenter: NSObject {
	static let sharedInstance=AlarmCenter()
	private var alarmProtocol: NSObjectProtocol?
	private let calendar=Calendar.current
	private var alarmTimers=[DispatchSourceTimer]()
	private let timeFormatter=DateFormatter()
	private let appObject = NSApp as NSApplication
	override private init() {
		timeFormatter.locale=Locale(identifier: "en_US")
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
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
		for alarm in alarms where alarm.active {
			activeCount+=1
		}
		return activeCount
	}
	private func scheduleAlarms() {
		for alarm in alarms where alarm.active {
			scheduleAlarm(alarm: alarm)
		}
	}
	private func scheduleAlarm(alarm: Alarm) {
		if alarm.active {
			let alarmTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
			print("abcd"+String(getTimeInterval(alarm: alarm)))
			alarmTimer.schedule(deadline: .now()+getTimeInterval(alarm: alarm), repeating: .never, leeway: .milliseconds(0))
			alarmTimer.setEventHandler {
				let alarmSound=NSSound(named: NSSound.Name("Ping"))
				alarmSound?.loops=true
				alarmSound?.play()
				let alarmAlert=NSAlert()
				alarmAlert.messageText="Alarm for \(self.timeFormatter.string(from: alarm.date))  has gone off."
				alarmAlert.addButton(withTitle: "Dismiss")
				alarmAlert.icon=DockClockController.dockClockObject.getFreezeView(time: alarm.date).image()
				AlarmsWindowController.alarmsObject.showAlarms()
				alarmAlert.beginSheetModal(for: AlarmsWindowController.alarmsObject.window ?? NSWindow()) { (_) in
					alarmSound?.stop()
					alarmTimer.cancel()
				}
			}
			alarmTimer.resume()
			alarmTimers.append(alarmTimer)
		}
	}
	private func getTimeInterval(alarm: Alarm) -> TimeInterval {
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
		scheduleAlarms()
	}
}
