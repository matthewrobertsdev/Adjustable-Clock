//
//  AlarmsStorage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class AlarmStorage: NSObject {
	static let storageObject=AlarmStorage()
	override private init() {
	}
	private var alarms=[Alarm]()
	func addAlarm(alarm: Alarm) {
		print("1234"+count.description)
		alarms.append(alarm)
		count+=1
	}
	func getAlarm(index: Int) -> Alarm {
		return alarms[index]
	}
	@objc dynamic var count=0
}
/*[Alarm(date: Date(), usesSong: false, repeats: false, song: nil), Alarm(date: Date(), usesSong: false, repeats: false, song: nil)]*/
