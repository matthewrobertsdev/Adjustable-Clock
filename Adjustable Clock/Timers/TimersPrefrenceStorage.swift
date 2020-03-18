//
//  TimersPrefrenceStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class TimersPreferenceStorage {
	let userDefaults=UserDefaults()
	static let sharedInstance=TimersPreferenceStorage()
	private let windowIsOpenKey="timersIsOpen"
	private let hasLaunchedKey="timersHasLaunched"
	private let asSecondsKey="asSecondsKey"
	var windowIsOpen=false
	var asSeconds=false
	func setWindowIsOpen() {
		userDefaults.set(true, forKey: windowIsOpenKey)
	}
	func setWindowIsClosed() {
		userDefaults.set(false, forKey: windowIsOpenKey)
	}
	func loadPreferences() {
		windowIsOpen=userDefaults.bool(forKey: windowIsOpenKey)
		asSeconds=userDefaults.bool(forKey: asSecondsKey)
	}
	func setHasLaunched() {
		userDefaults.set(true, forKey: hasLaunchedKey)
	}
	func haslaunchedBefore() -> Bool {
		return userDefaults.bool(forKey: hasLaunchedKey)
	}
	func setAsSeconds() {
		if asSeconds {
			asSeconds=false
		} else {
			asSeconds=true
		}
		userDefaults.set(asSeconds, forKey: asSecondsKey)
	}
}
