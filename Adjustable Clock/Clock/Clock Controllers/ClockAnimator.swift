//
//  ClockAnimator.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import AppKit
class ClockAnimator {
	var model: ClockModel
	var tellingTime: NSObjectProtocol!
	var updateTimer: DispatchSourceTimer!
	init(model: ClockModel, tellingTime: NSObjectProtocol, updateTimer: DispatchSourceTimer) {
		self.model=model
		self.tellingTime=tellingTime
		self.updateTimer=updateTimer
	}
	func getSecondAdjustment() -> Double {
		let start=Date()
		let nanoseconds=Calendar.current.dateComponents([.nanosecond], from: start)
		let missingNanoceconds=1_000_000_000-(nanoseconds.nanosecond ?? 0)
		return Double(missingNanoceconds)/1_000_000_000
	}
	func stopAnimating() {
		ProcessInfo().endActivity(tellingTime)
		updateTimer.cancel()
	}
}
