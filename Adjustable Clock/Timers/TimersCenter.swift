//
//  TimerCenter.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class TimersCenter {
	var tellingTime: NSObjectProtocol?
	let timeFormatter=DateFormatter()
	let calendar=Calendar.current
	let timersKey="savedTimers"
	let jsonEncoder=JSONEncoder()
	let jsonDecoder=JSONDecoder()
	let userDefaults=UserDefaults()
	var activeTimers=0 {
		didSet {
			NotificationCenter.default.post(name: NSNotification.Name.activeCountChanged, object: nil)
		}
	}
	static let sharedInstance=TimersCenter()
	private init() {
		timeFormatter.locale=Locale(identifier: "de_AT")
		timeFormatter.setLocalizedDateFormatFromTemplate("HHmmss")
		timeFormatter.timeZone=TimeZone(secondsFromGMT: 0)
		for _ in 0...2 {
			gcdTimers.append(DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main))
		}
		loadTimers()
		NotificationCenter.default.addObserver(self, selector: #selector(setActivity), name: NSNotification.Name.activeCountChanged, object: nil)
	}
	@objc func setActivity() {
		if activeTimers>0 {
			tellingTime = ProcessInfo().beginActivity(options: .idleSystemSleepDisabled, reason: "Need accurate time for timers")
		} else {
			tellingTime=nil
		}
	}
	func saveTimers() {
		for timer in timers {
			timer.active=false
		}
		do {
			let timerData=try jsonEncoder.encode(timers)
			userDefaults.setValue(timerData, forKeyPath: timersKey)
		} catch {
			print("Error encoding data")
		}
	}
	func loadTimers() {
		do {
			if let timersData=userDefaults.data(forKey: timersKey) {
				let savedTimers=try jsonDecoder.decode([CountDownTimer].self, from: timersData)
				timers=savedTimers
			}
		} catch {
			print("Error decoding data")
			timers=[CountDownTimer(), CountDownTimer(), CountDownTimer()]
		}
	}
	var timers=[CountDownTimer(), CountDownTimer(), CountDownTimer()]
	var gcdTimers=[DispatchSourceTimer]()
	func resetTimer(index: Int){
		if timers[index].active {
			stopTimer(index: index)
		}
		timers[index].secondsRemaining=timers[index].totalSeconds
	}
	func getCountDownString(index: Int) -> String {
		if TimersCenter.sharedInstance.timers[index].secondsRemaining < 0 {
			if TimersPreferenceStorage.sharedInstance.asSeconds {
				return String(0)
			} else {
				return String(timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(0))))
			}
		} else if TimersPreferenceStorage.sharedInstance.asSeconds {
			return String(TimersCenter.sharedInstance.timers[index].secondsRemaining)
		} else {
			return String(timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(TimersCenter.sharedInstance.timers[index].secondsRemaining))))
		}
	}
	func updateTimer(index: Int) {
		if timers[index].secondsRemaining<=0 {
			timers[index].secondsRemaining-=1
			gcdTimers[index].suspend()
			timers[index].active=false
			activeTimers-=1
		} else {
			timers[index].secondsRemaining-=1
		}
	}
	func setSeconds(index: Int, time: Date) {
		let hours=calendar.dateComponents([.hour], from: time).hour ?? 0
		let minutes=calendar.dateComponents([.minute], from: time).minute ?? 0
		let seconds=calendar.dateComponents([.second], from: time).second ?? 0
		let totalSeconds=60*60*hours+60*minutes+seconds
		let timer=timers[index]
		timer.totalSeconds=totalSeconds
		timer.secondsRemaining=totalSeconds
	}
	func stopTimer(index: Int) {
		if timers[index].active {
			activeTimers-=1
			timers[index].active=false
			gcdTimers[index].suspend()
		}
	}
}

