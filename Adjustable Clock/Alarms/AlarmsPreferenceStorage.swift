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
	private let windowIsOpenKey="windowIsOpen"
    let userDefaults=UserDefaults()
	var windowIsOpen=false
	private init() {
	}
	func setWindowIsOpen() {
		userDefaults.set(true, forKey: windowIsOpenKey)
	}
	func setWindowIsClosed() {
		userDefaults.set(false, forKey: windowIsOpenKey)
	}
	func loadPreferences() {
		windowIsOpen=userDefaults.bool(forKey: windowIsOpenKey)
		print("window is open: "+windowIsOpen.description)
	}
}
