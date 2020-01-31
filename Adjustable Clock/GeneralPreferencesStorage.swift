//
//  GeneralPreferencesStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class GeneralPreferencesStorage {
	static let sharedInstance=GeneralPreferencesStorage()
	var closing=false
	var use24Hours=false
	var dockClock="useAnalogNoSeconds"
	let userDefaults=UserDefaults()
	private let use24HoursKey="use24Hours"
	private let dockClockKey="dockClock"
	private init() {
	}
	func loadUserPreferences() {
		use24Hours=userDefaults.bool(forKey: use24HoursKey)
		dockClock=userDefaults.string(forKey: dockClockKey) ?? "useAnalogNoSeconds"
	}
	func changeAndSaveUseAmPM() {
        use24Hours=(!use24Hours)
        userDefaults.set(use24Hours, forKey: use24HoursKey)
    }
}
