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
		for _ in 0...2 {
			gcdTimers.append(DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main))
		}
	}
	var timers=[CountDownTimer(), CountDownTimer(), CountDownTimer()]
	var gcdTimers=[DispatchSourceTimer]()
	func getCountDownString(index: Int) -> String {
		return  String(TimersCenter.sharedInstance.timers[index].secondsRemaining)
	}
}
