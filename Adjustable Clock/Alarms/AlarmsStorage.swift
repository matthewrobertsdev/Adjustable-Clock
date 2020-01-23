//
//  AlarmsStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class AlarmStorage {
	static let storageObject=AlarmStorage()
	private init() {
	}
	var alarms=[Alarm(date: Date(), usesSong: false, repeats: false, song: nil), Alarm(date: Date(), usesSong: false, repeats: false, song: nil)]//[Alarm]()
	func addAlarm(alarm: Alarm) {
		alarms.append(alarm)
	}
}
