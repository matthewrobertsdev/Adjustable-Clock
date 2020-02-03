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
	var digital=false
	var seconds=false
	let userDefaults=UserDefaults()
	private let use24HoursKey="use24Hours"
	private let dockClockKey="dockClock"
	let useAnalogNoSeconds="useAnalogNoSeconds"
	let useAnalogWithSeconds="useAnalogWithSeconds"
	let useDigitalNoSeconds="useDigitalNoSeconds"
	let useDigitalWithSeconds="useDigitalWithSeconds"
	private init() {
	}
	func loadUserPreferences() {
		use24Hours=userDefaults.bool(forKey: use24HoursKey)
		dockClock=userDefaults.string(forKey: dockClockKey) ?? "useAnalogNoSeconds"
		updateModelToPreferences()
	}
	func changeAndSaveUseAmPM() {
        use24Hours=(!use24Hours)
        userDefaults.set(use24Hours, forKey: use24HoursKey)
    }
	func updateDockClockPreferences(mode: String) {
		userDefaults.set(mode, forKey: dockClockKey)
		dockClock=mode
	}
	func updateModelToPreferences() {
		switch dockClock {
		case "useAnalogNoSeconds":
			digital=false
			seconds=false
		case "useDigitalNoSeconds":
			digital=true
			seconds=false
		case "useAnalogWithSeconds":
			digital=false
			seconds=true
		case "useDigitalWithSeconds":
			digital=true
			seconds=true
		default:
			digital=false
			seconds=false
		}
	}
}
