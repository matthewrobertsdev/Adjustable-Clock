//
//  AnalogClockAnimator.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/10/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
class AnalogClockAnimator: ClockAnimator {
	var analogClock: AnalogClockView
	var animatedDay: NSTextField
	var calendar=Calendar.current
	init(model: ClockModel, tellingTime: NSObjectProtocol, updateTimer: DispatchSourceTimer, analogClock: AnalogClockView, animatedDay: NSTextField) {
		self.analogClock=analogClock
		self.animatedDay=animatedDay
		super.init(model: model, tellingTime: tellingTime, updateTimer: updateTimer)
	}
	func animateHands() {
		let now=Date()
		let hour=calendar.dateComponents([.hour], from: now).hour ?? 0
		let minute=calendar.dateComponents([.minute], from: now).minute ?? 0
		analogClock.setMinuteHand(radians: -CGFloat.pi*CGFloat(minute)/30)
		let second=calendar.dateComponents([.second], from: now).second ?? 0
	}
}
