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
	var precisionDivisor=10.0
	private let userDefaults=UserDefaults.standard
	private let jsonEncoder=JSONEncoder()
	private let jsonDecoder=JSONDecoder()
	private var useSecondsPrecision=false
	private init() {
	}
	func setUp() {
		jsonEncoder.outputFormatting = .prettyPrinted
		stopwatchFormatter.dateFormat="mm:ss"
		loadTime()
		loadLaps()
		assignShortestAndLongestIndices()
	}
	private func loadTime() {
		startTime=ProcessInfo.processInfo.systemUptime
		previousTime=userDefaults.double(forKey: "previousTimeKey")
	}
	private func loadLaps() {
		if let lapData=userDefaults.data(forKey: "lapDataKey") {
			do {
				laps=try jsonDecoder.decode([Lap].self, from: lapData)
			} catch {
				print("Couldn't load lap data.")
			}
		}
	}
	private func saveTime() {
		userDefaults.set(previousTime, forKey: "previousTimeKey")
	}
	func saveLaps() {
		do {
			let lapData = try jsonEncoder.encode(laps)
			userDefaults.set(lapData, forKey: "lapDataKey")
		} catch {
			print("Couldn't save lap data")
		}
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
		updateLapTime()
	}
	func updateStopwatch() {
		updateLapTime()
	}
	func lapStopwatch() {
		previousTime+=lapTime
		let lap=Lap(lapNumber: laps.count+1, timeInterval: lapTime, useSecondsPrecision: StopwatchPreferencesStorage.sharedInstance.useSecondsPrecision)
		laps.insert(lap, at: 0)
		saveTime()
		saveLaps()
		setStartTime()
		assignShortestAndLongestIndices()
	}
	func resetStopwatch() {
		stopStopwatch()
		resetData()
		saveTime()
		saveLaps()
	}
	func stopStopwatch() {
		if active {
			active=false
			gcdTimer.cancel()
			gcdTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		}
	}
	func getStopwatchDisplayString() -> String {
		let currentTime=previousTime+lapTime
		let minutesAndSecondsString=stopwatchFormatter.string(from: Date(timeIntervalSince1970: currentTime))
		if StopwatchPreferencesStorage.sharedInstance.useSecondsPrecision {
			return minutesAndSecondsString
		} else {
		let hundrethsString=String(format: "%.1f", (currentTime.truncatingRemainder(dividingBy: TimeInterval(10))))
			let firstIndex = hundrethsString.index(hundrethsString.startIndex, offsetBy: 1)
		return minutesAndSecondsString+String(hundrethsString.suffix(from: firstIndex))
		}
	}
	func getStopwatchFreezeString() -> String {
		let currentTime=previousTime
		let minutesAndSecondsString=stopwatchFormatter.string(from: Date(timeIntervalSince1970: currentTime))
		if StopwatchPreferencesStorage.sharedInstance.useSecondsPrecision {
			return minutesAndSecondsString
		} else {
		let hundrethsString=String(format: "%.1f", (currentTime.truncatingRemainder(dividingBy: TimeInterval(10))))
			let firstIndex = hundrethsString.index(hundrethsString.startIndex, offsetBy: 1)
		return minutesAndSecondsString+String(hundrethsString.suffix(from: firstIndex))
		}
	}
	private func resetData() {
		previousTime=0
		lapTime=0
		laps=[Lap]()
	}
	private func assignShortestAndLongestIndices() {
		if laps.count<2 {
			leastIndex = -1
			greatestIndex = -1
		} else {
			leastIndex=laps.startIndex
			greatestIndex=laps.startIndex
			var leastLap=laps[0]
			var greatestLap=laps[0]
			for index in 0...laps.count-1 {
				if laps[index].timeInterval<leastLap.timeInterval {
					leastLap=laps[index]
					leastIndex=index
				} else if laps[index].timeInterval>greatestLap.timeInterval {
					greatestLap=laps[index]
					greatestIndex=index
				}
			}
		}
	}
	func useSeconds() {
		useSecondsPrecision=true
		precisionDivisor=1
	}
	func useTenthsOfSeconds() {
		useSecondsPrecision=false
		precisionDivisor=10
	}
}
