//
//  DigitalClockAnimator.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/9/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
extension ClockViewController {
	func displayDigitalForDock() {
		updateTimer.cancel()
		updateTimer.setEventHandler {
		}
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
		updateTimer.cancel()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		updateTimer.schedule(deadline: .now()+getSecondAdjustment(),
							 repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			self.updateTimeAndDayInfo()
		}
		updateTimer.resume()
	}
	private func animateTime() {
		digitalClock.stringValue=model.getTime()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		updateTimer.schedule(deadline: .now()+getSecondAdjustment(),
							 repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			self.updateTime()
		}
		updateTimer.resume()
	}
	func animateDigital() {
		if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
			animateTimeAndDayInfo()
		} else {
			animateTime()
		}
	}
}
