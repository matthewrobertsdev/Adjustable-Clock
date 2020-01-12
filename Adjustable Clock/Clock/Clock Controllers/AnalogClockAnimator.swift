//
//  AnalogClockAnimator.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/10/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
class AnalogClockAnimator: ClockAnimator {
	private var analogClock: AnalogClockView
	private var animatedDay: NSTextField
	private var calendar=Calendar.current
	init(model: ClockModel, tellingTime: NSObjectProtocol, updateTimer: DispatchSourceTimer, analogClock: AnalogClockView, animatedDay: NSTextField) {
		self.analogClock=analogClock
		self.animatedDay=animatedDay
		super.init(model: model, tellingTime: tellingTime, updateTimer: updateTimer)
	}
	private func animateHandsWithSeconds() {
		let now=Date()
		let hour=calendar.dateComponents([.hour], from: now).hour ?? 0
		let minute=calendar.dateComponents([.minute], from: now).minute ?? 0
		let second=calendar.dateComponents([.second], from: now).second ?? 0
		let totalSeconds=(Double(hour)*3600.0+Double(minute)*60.0+Double(second))
		analogClock.setHourHand(radians: -2*CGFloat.pi*CGFloat(totalSeconds/43200.0))
		analogClock.setMinuteHand(radians: -CGFloat.pi*CGFloat(minute)/30)
		analogClock.setSecondHand(radians: -CGFloat.pi*CGFloat(second)/30)
		updateHours(hour: hour)
	}
	private func animateHandsNoSeconds() {
		let now=Date()
		let hour=calendar.dateComponents([.hour], from: now).hour ?? 0
		let minute=calendar.dateComponents([.minute], from: now).minute ?? 0
		let second=calendar.dateComponents([.second], from: now).second ?? 0
		let totalSeconds=(Double(hour)*3600.0+Double(minute)*60.0+Double(second))
		analogClock.setHourHand(radians: -2*CGFloat.pi*CGFloat(totalSeconds/43200.0))
		analogClock.setMinuteHand(radians: -CGFloat.pi*CGFloat(minute)/30)
		updateHours(hour: hour)
	}
	private func animateTimeAndDayInfo() {
		analogClock.startHands(withSeconds: ClockPreferencesStorage.sharedInstance.showSeconds)
		if animatedDay.stringValue != model.getDayInfo() {
			animatedDay.stringValue=model.getDayInfo()
		}
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		CALayer.performWithoutAnimation {
			runAnimation()
		}
		updateTimer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			self.runAnimation()
		}
		updateTimer.resume()
	}
	private func animateTime() {
		analogClock.startHands(withSeconds: ClockPreferencesStorage.sharedInstance.showSeconds)
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		CALayer.performWithoutAnimation {
			runAnimation()
		}
		updateTimer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			self.runAnimation()
		}
		updateTimer.resume()
	}
	private func runAnimation() {
		if ClockPreferencesStorage.sharedInstance.showSeconds {
			self.animateHandsWithSeconds()
		} else {
			self.animateHandsNoSeconds()
		}
	}
	func animate() {
		if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
			animateTimeAndDayInfo()
		} else {
			animateTime()
		}
	}
	func updateHours(hour: Int) {
		if ClockPreferencesStorage.sharedInstance.use24hourClock {
			updateHourNums(hour: hour)
		} else {
			updateAmPm(hour: hour)
		}
	}
	func updateAmPm(hour: Int) {
		if analogClock.hourLabels[0].stringValue != String(12) || analogClock.hourLabels[6].stringValue != String(6){
			analogClock.use1to12Hours()
		}
		if hour>11 && analogClock.amPmLabel.stringValue != "PM" {
			analogClock.amPmLabel.stringValue = "PM"
		} else if hour<12 && analogClock.amPmLabel.stringValue != "AM" {
			analogClock.amPmLabel.stringValue = "AM"
		}
	}
	func updateHourNums(hour: Int) {
		if analogClock.amPmLabel.stringValue != "" {
			analogClock.amPmLabel.stringValue=""
		}
		if analogClock.hourLabels[5].stringValue != String(6) && hour<12 {
			analogClock.use0to11Hours()
		} else if analogClock.hourLabels[5].stringValue != String(18) && hour>11 {
			analogClock.use12to23Hours()
		}
	}
}
