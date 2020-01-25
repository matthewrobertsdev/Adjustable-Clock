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
	let userDefaults=UserDefaults()
	private init() {
	}
}
