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
	let userDefaults=UserDefaults.standard
	var windowIsOpen=false
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
	}
	func setWindowIsClosed() {
		userDefaults.set(false, forKey: windowIsOpenKey)
	}
	func loadPreferences() {
		windowIsOpen=userDefaults.bool(forKey: windowIsOpenKey)
	}
}
