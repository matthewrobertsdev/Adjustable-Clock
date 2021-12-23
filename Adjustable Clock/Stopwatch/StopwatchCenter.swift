//
//  StopwatchCenter.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/21/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
class StopwatchCenter {
	static let sharedInstance=StopwatchCenter()
	var leastIndex = -1
	var greatestIndex = -1
	var gcdTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
	var active=false
	var started=false
	var laps=[Lap]()
	private let stopwatchFormatter=DateFormatter()
	private var startTime: TimeInterval=0
	private var lapTime: TimeInterval=0
	private var previousTime: TimeInterval=0
	private init() {
		setUp()
	}
	private func setUp() {
		stopwatchFormatter.dateFormat="mm:ss"
		loadTime()
		loadLaps()
		findLeastAndGreatest()
	}
	private func loadTime() {
	}
	private func loadLaps() {
	}
	private func findLeastAndGreatest() {
	}
	private func setStartTime() {
		startTime=ProcessInfo.processInfo.systemUptime
	}
	private func updateLapTime() {
		let currentUpTime=ProcessInfo.processInfo.systemUptime
		lapTime=currentUpTime-startTime
	}
	func startStopwatch() {
		setStartTime()
		active=true
	}
	func updateStopwatch() {
		updateLapTime()
	}
	func lapStopwatch() {
		previousTime+=lapTime
		setStartTime()
	}
	func resetStopwatch() {
		resetData()
		stopStopwatch()
	}
	func getStopwatchDisplayString() -> String {
		let currentTime=previousTime+lapTime
		let hundrethsString=String(format: "%.1f", (currentTime.truncatingRemainder(dividingBy: TimeInterval(10))))
		return stopwatchFormatter.string(from: Date(timeIntervalSince1970: currentTime))+hundrethsString.substring(from: hundrethsString.index(hundrethsString.startIndex, offsetBy: 1))
	}
	private func resetData() {
		previousTime=0
		lapTime=0
		laps=[Lap]()
	}
	func stopStopwatch() {
		if active {
			active=false
			gcdTimer.cancel()
			gcdTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
			previousTime+=lapTime
		}
	}
}
