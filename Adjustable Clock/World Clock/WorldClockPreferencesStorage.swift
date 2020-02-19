//
//  WorldClockPreferencesStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/19/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class WorldClockPreferencesStorage {
	let userDefaults=UserDefaults()
	static let sharedInstance=WorldClockPreferencesStorage()
	private let windowIsOpenKey="worldClocksIsOpen"
	private let hasLaunchedKey="worldClockHasLaunched"
	var windowIsOpen=false
	func setWindowIsOpen() {
		userDefaults.set(true, forKey: windowIsOpenKey)
	}
	func setWindowIsClosed() {
		userDefaults.set(false, forKey: windowIsOpenKey)
	}
	func loadPreferences() {
		windowIsOpen=userDefaults.bool(forKey: windowIsOpenKey)
	}
	func setHasLaunched() {
		userDefaults.set(true, forKey: hasLaunchedKey)
	}
	func haslaunchedBefore() -> Bool {
		return userDefaults.bool(forKey: hasLaunchedKey)
	}
}
