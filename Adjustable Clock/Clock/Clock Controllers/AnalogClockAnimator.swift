//
//  AnalogClockAnimator.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/10/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
extension ClockViewController {
	private func animateHandsWithSeconds(early: Bool) {
		let now=Date()
		let hour=Calendar.autoupdatingCurrent.dateComponents([.hour], from: now).hour ?? 0
		var minute=Calendar.autoupdatingCurrent.dateComponents([.minute], from: now).minute ?? 0
		var second=Calendar.autoupdatingCurrent.dateComponents([.second], from: now).second ?? 0
		if early {
			second+=1
			if second==60 {
				minute+=1
			}
		}
		let totalSeconds=(Double(hour)*3600.0+Double(minute)*60.0+Double(second))
		analogClock.setHourHand(radians: -2*CGFloat.pi*CGFloat(totalSeconds/43200.0))
		analogClock.setMinuteHand(radians: -CGFloat.pi*CGFloat(minute)/30)
		analogClock.setSecondHand(radians: -CGFloat.pi*CGFloat(second)/30)
		updateHours(hour: hour)
	}
	private func animateHandsNoSeconds(early: Bool) {
		let now=Date()
		let hour=Calendar.autoupdatingCurrent.dateComponents([.hour], from: now).hour ?? 0
		var minute=Calendar.autoupdatingCurrent.dateComponents([.minute], from: now).minute ?? 0
		var second=Calendar.autoupdatingCurrent.dateComponents([.second], from: now).second ?? 0
		if early {
			second+=1
			if second==60 {
				minute+=1
			}
		}
		let totalSeconds=(Double(hour)*3600.0+Double(minute)*60.0+Double(second))
		analogClock.setHourHand(radians: -2*CGFloat.pi*CGFloat(totalSeconds/43200.0))
		analogClock.setMinuteHand(radians: -CGFloat.pi*CGFloat(minute)/30)
		updateHours(hour: hour)
	}
	private func animateTimeAndDayInfo() {
		if self.animatedDay.stringValue != self.model.getDayInfo() {
			self.animatedDay.stringValue=self.model.getDayInfo()
		}
		analogClock.startHands(withSeconds: ClockPreferencesStorage.sharedInstance.showSeconds)
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		performWithoutAnimation {
			runAnimation(early: false)
		}
		performAnimationWithDuration(seconds: getSecondAdjustment()) {
			runAnimation(early: true)
		}
		updateTimer.schedule(deadline: .now()+0.8, repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			performAnimationWithDuration(seconds: 0.2) {
				self.runAnimation(early: true)
			}
			if self.animatedDay.stringValue != self.model.getDayInfo() {
				self.animatedDay.stringValue=self.model.getDayInfo()
			}
		}
		updateTimer.resume()
	}
	private func animateTime() {
		analogClock.startHands(withSeconds: ClockPreferencesStorage.sharedInstance.showSeconds)
		updateTimer.cancel()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		performWithoutAnimation {
			runAnimation(early: false)
		}
		performAnimationWithDuration(seconds: getSecondAdjustment()) {
			runAnimation(early: true)
		}
		updateTimer.schedule(deadline: .now()+0.8, repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			performAnimationWithDuration(seconds: 0.2) {
				self.runAnimation(early: true)
			}
		}
		updateTimer.resume()
	}
	private func runAnimation(early: Bool) {
		if ClockPreferencesStorage.sharedInstance.showSeconds {
			self.animateHandsWithSeconds(early: early)
		} else {
			self.animateHandsNoSeconds(early: early)
		}
	}
	func animateAnalog() {
		if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
			animateTimeAndDayInfo()
		} else {
			animateTime()
		}
	}
	func updateHours(hour: Int) {
		if GeneralPreferencesStorage.sharedInstance.use24Hours {
			updateHourNums(hour: hour)
		} else {
			updateAmPm(hour: hour)
		}
	}
	func updateAmPm(hour: Int) {
		if analogClock.hourLabels[0].stringValue != String(12) || analogClock.hourLabels[6].stringValue != String(6) {
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
	func displayAnalogForDock() {
		analogClock.clearHands()
		animatedDay.stringValue=model.dockDateString
	}
}
