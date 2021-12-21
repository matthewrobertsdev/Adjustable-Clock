//
//  AlarmsPreferenceStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Foundation
class AlarmsPreferencesStorage {
	static let sharedInstance=AlarmsPreferencesStorage()
	private let windowIsOpenKey="alarmIsOpen"
	private let alarmsHasLaunchedKey="alarmsHasLaunched"
	let userDefaults=UserDefaults.standard
	var windowIsOpen=false
	private init() {
	}
	func hasLaunchedBefore() -> Bool {
		return userDefaults.bool(forKey: alarmsHasLaunchedKey)
	}
	func setAlarmsAsHasLaunched() {
		userDefaults.set(true, forKey: alarmsHasLaunchedKey)
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
