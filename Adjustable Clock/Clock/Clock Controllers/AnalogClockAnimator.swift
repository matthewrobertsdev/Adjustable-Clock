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
		let second=calendar.dateComponents([.second], from: now).second ?? 0
		let totalSeconds=(Double(hour)*3600.0+Double(minute)*60.0+Double(second))
		analogClock.setHourHand(radians: -2*CGFloat.pi*CGFloat(totalSeconds/43200.0))
		analogClock.setMinuteHand(radians: -CGFloat.pi*CGFloat(minute)/30)
		analogClock.setSecondHand(radians: -CGFloat.pi*CGFloat(second)/30)
	}
	func animateTimeAndDayInfo() {
		analogClock.startHands()
		animatedDay.stringValue=model.getDayInfo()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		updateTimer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			self.animateHands()
		}
		updateTimer.resume()
	}
	func animateTime() {
		analogClock.startHands()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		updateTimer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			self.animateHands()
		}
		updateTimer.resume()
	}
}
