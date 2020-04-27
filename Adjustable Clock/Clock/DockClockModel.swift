//
//  DockClockModel.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/31/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class DockClockModel {
	private let timeFormatter=DateFormatter()
	private let secondsFormatter=DateComponentsFormatter()
	private let calendar=Calendar.current
	init() {
		timeFormatter.locale=Locale(identifier: "en_US")
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
		secondsFormatter.zeroFormattingBehavior = .pad
	}
	func setTimeFormatter() {
		if GeneralPreferencesStorage.sharedInstance.use24Hours {
			timeFormatter.setLocalizedDateFormatFromTemplate("HHmm")
		} else {
			timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
		}
	}
	func getTimeString(date: Date) -> String {
		if GeneralPreferencesStorage.sharedInstance.use24Hours {
			return timeFormatter.string(from: date)
		} else {
			var amPmString=timeFormatter.string(from: date)
			let rangeToRemove = amPmString.index(amPmString.endIndex, offsetBy: -3)..<amPmString.endIndex
			 amPmString.removeSubrange(rangeToRemove)
			assert(!amPmString.lowercased().contains("AM"), "Dock Clock contained AM")
			assert(!amPmString.lowercased().contains("PM"), "Dock Clock contained PM")
			return amPmString
		}
	}
	func getSecondsString(date: Date) -> String {
		return ":"+(secondsFormatter.string(from: calendar.dateComponents([.second], from: date)) ?? "--")
	}
}
