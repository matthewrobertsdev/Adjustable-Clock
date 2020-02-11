//
//  TimerCenter.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class TimersCenter {
	static let sharedInstance=TimersCenter()
	private init() {
	}
	var timers=[CountDownTimer(), CountDownTimer(), CountDownTimer()]
}
