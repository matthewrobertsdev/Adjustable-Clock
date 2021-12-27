//
//  StopwatchPreferencesStotrage.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/21/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
class StopwatchPreferencesStorage {
	static let sharedInstance=StopwatchPreferencesStorage()
	private let windowIsOpenKey="stopwatchIsOpen"
	private let stopwatchHasLaunchedKey="stopwatchHasLaunched"
	private let stopwatchFloatsKey="stopwatchFloats"
	private let stopwatchSecondsPrecisionKey="stopwatchSecondsPrecision"
	let userDefaults=UserDefaults.standard
	var windowIsOpen=false
	var stopwatchFloats=false
	var useSecondsPrecision=false
	private init() {
	}
	func hasLaunchedBefore() -> Bool {
		return userDefaults.bool(forKey: stopwatchHasLaunchedKey)
	}
	func setStopwatchAsHasLaunched() {
		userDefaults.set(true, forKey: stopwatchHasLaunchedKey)
	}
	func setWindowIsOpen() {
		userDefaults.set(true, forKey: windowIsOpenKey)
		windowIsOpen=true
	}
	func setWindowIsClosed() {
		userDefaults.set(false, forKey: windowIsOpenKey)
		windowIsOpen=false
	}
	func loadPreferences() {
		windowIsOpen=userDefaults.bool(forKey: windowIsOpenKey)
		stopwatchFloats=userDefaults.bool(forKey: stopwatchFloatsKey)
	}
	func toggleStopwatchFloats() {
		stopwatchFloats = !stopwatchFloats
		userDefaults.set(stopwatchFloats, forKey: stopwatchFloatsKey)
	}
	func setDefaultUserDefaults() {
		userDefaults.set(false, forKey: stopwatchFloatsKey)
		userDefaults.set(false, forKey: stopwatchSecondsPrecisionKey)
	}
	func setUseSecondsPrecision() {
		useSecondsPrecision=true
		userDefaults.set(true, forKey: stopwatchSecondsPrecisionKey)
	}
	func setUseTenthsOfSecondsPrecision() {
		useSecondsPrecision=false
		userDefaults.set(false, forKey: stopwatchSecondsPrecisionKey)
	}
}
