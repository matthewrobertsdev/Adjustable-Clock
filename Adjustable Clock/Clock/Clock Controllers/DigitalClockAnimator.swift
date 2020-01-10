//
//  DigitalClockAnimator.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/9/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class DigitalClockAnimator {
	var model: ClockModel
	var tellingTime: NSObjectProtocol
	var updateTimer: DispatchSourceTimer
	var digitalClock: NSTextField
	var animatedDay: NSTextField
	init(model: ClockModel, tellingTime: NSObjectProtocol, updateTimer: DispatchSourceTimer, digitalClock: NSTextField, animatedDay: NSTextField) {
		self.model=model
		self.tellingTime=tellingTime
		self.updateTimer=updateTimer
		self.digitalClock=digitalClock
		self.animatedDay=animatedDay
		print("inited DigitalClockAnimator")
	}
	func displayForDock() {
		updateTimer.cancel()
		self.digitalClock.stringValue=model.dockTimeString
		self.animatedDay.stringValue=model.dockDateString
	}
	func updateTime() {
		let timeString=model.getTime()
		if digitalClock.stringValue != timeString {
			digitalClock.stringValue=timeString
		}
	}
	func updateTimeAndDayInfo() {
		let timeString=model.getTime()
		if digitalClock.stringValue != timeString {
			digitalClock.stringValue=timeString
			let dayInfo=model.getDayInfo()
			animatedDay.stringValue=dayInfo
		}
	}
	func animateTimeAndDayInfo() {
		digitalClock.stringValue=model.getTime()
		animatedDay.stringValue=model.getDayInfo()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		updateTimer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			self.updateTimeAndDayInfo()
		}
		updateTimer.resume()
	}
	func getSecondAdjustment() -> Double {
		let start=Date()
		let nanoseconds=Calendar.current.dateComponents([.nanosecond], from: start)
		let missingNanoceconds=1_000_000_000-(nanoseconds.nanosecond ?? 0)
		return Double(missingNanoceconds)/1_000_000_000
	}
	func animateTime() {
		digitalClock.stringValue=model.getTime()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		updateTimer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(model.updateTime), leeway: .milliseconds(0))
		updateTimer.setEventHandler {
			self.updateTime()
		}
		updateTimer.resume()
	}
	func stopAnimating() {
		ProcessInfo().endActivity(tellingTime)
		updateTimer.cancel()
	}
}
