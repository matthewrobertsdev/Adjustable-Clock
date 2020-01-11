//
//  DigitalClockAnimator.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/9/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class DigitalClockAnimator: ClockAnimator {
	private var digitalClock: NSTextField
	private var animatedDay: NSTextField
	init(model: ClockModel, tellingTime: NSObjectProtocol, updateTimer: DispatchSourceTimer, digitalClock: NSTextField, animatedDay: NSTextField) {
		self.digitalClock=digitalClock
		self.animatedDay=animatedDay
		super.init(model: model, tellingTime: tellingTime, updateTimer: updateTimer)
	}
	func displayForDock() {
		updateTimer.cancel()
		self.digitalClock.stringValue=model.dockTimeString
		self.animatedDay.stringValue=model.dockDateString
	}
	private func updateTime() {
		let timeString=model.getTime()
		if digitalClock.stringValue != timeString {
			digitalClock.stringValue=timeString
		}
	}
	private func updateTimeAndDayInfo() {
		let timeString=model.getTime()
		if digitalClock.stringValue != timeString {
			digitalClock.stringValue=timeString
			let dayInfo=model.getDayInfo()
			animatedDay.stringValue=dayInfo
		}
	}
	private func animateTimeAndDayInfo() {
		digitalClock.stringValue=model.getTime()
		animatedDay.stringValue=model.getDayInfo()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		updateTimer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			self.updateTimeAndDayInfo()
		}
		updateTimer.resume()
	}
	private func animateTime() {
		digitalClock.stringValue=model.getTime()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		updateTimer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			self.updateTime()
		}
		updateTimer.resume()
	}
	func animate() {
		if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
			animateTimeAndDayInfo()
		} else {
			animateTime()
		}
	}
}
