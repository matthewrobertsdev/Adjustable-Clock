//
//  StopwatchCenter.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/21/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
class StopwatchCenter {
	var leastIndex = -1
	var greatestIndex = -1
	var sharedInstance = StopwatchCenter()
	private var gcdTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
	private let stopwatchFormatter=DateFormatter()
	private var startTime: TimeInterval=0
	private var elapsedTime: TimeInterval=0
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
	private func updateElapsedTime() {
		let currentUpTime=ProcessInfo.processInfo.systemUptime
		elapsedTime=currentUpTime-startTime
	}
	func startStopwatch() {
		setStartTime()
	}
	func updateStopwatch() {
		updateElapsedTime()
	}
	func getStopwatchDisplayString() -> String {
		return stopwatchFormatter.string(from: Date(timeIntervalSince1970: elapsedTime))+String(format: "%.2f", elapsedTime-1)
	}
}
