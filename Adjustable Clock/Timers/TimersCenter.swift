//
//  TimerCenter.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class TimersCenter {
	let calendar=Calendar.current
	let timersKey="savedTimers"
	let jsonEncoder=JSONEncoder()
	let jsonDecoder=JSONDecoder()
	let userDefaults=UserDefaults()
	static let sharedInstance=TimersCenter()
	private init() {
		for _ in 0...2 {
			gcdTimers.append(DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main))
		}
		loadTimers()
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
	func getCountDownString(index: Int) -> String {
		return  String(TimersCenter.sharedInstance.timers[index].secondsRemaining)
	}
	func updateTimer(index: Int) {
		if timers[index].secondsRemaining<1 {
			gcdTimers[index].suspend()
			timers[index].active=false
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
	func stopTimer(index: Int){
		if timers[index].active {
			timers[index].active=false
			gcdTimers[index].suspend()
		}
	}
}
