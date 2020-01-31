//
//  DockClockController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/12/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class DockClockController {
	static let dockClockObject=DockClockController()
	let analogClockView=AnalogDockClockView()
	let digitalClockView=DigitalDockClockView()
	let appObject = NSApp as NSApplication
	var tellingTime: NSObjectProtocol?
	var updateTimer: DispatchSourceTimer?
	var model=DockClockModel()
	var digital = !false
	private init() {
		animateTime()
	}
	func updateDockTile() {
		if (digital) {
			digitalClockView.setFrameSize(appObject.dockTile.size)
			appObject.dockTile.contentView=digitalClockView
		} else {
			analogClockView.setFrameSize(appObject.dockTile.size)
			appObject.dockTile.contentView=analogClockView
		}
		applyColorScheme(digitalClockView: digitalClockView, analogClockView: analogClockView)
		appObject.dockTile.display()
	}
	func updateClockForPreferencesChange() {
			applyColorScheme(digitalClockView: digitalClockView, analogClockView: analogClockView)
		appObject.dockTile.display()
	}
	private func animateTime() {
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		guard let timer=updateTimer else { return }
		timer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(1000), leeway: .milliseconds(0))
		timer.setEventHandler {
			//self.dockClockView.draw(self.dockClockView.frame)
			if self.digital {
				self.digitalClockView.digitalClock.stringValue=self.model.getTimeString(date: Date())
				self.digitalClockView.digitalClock.sizeToFit()
			} else {
				self.analogClockView.setNeedsDisplay(self.analogClockView.bounds)
			}
			self.appObject.dockTile.display()
		}
		timer.resume()
	}
	func getSecondAdjustment() -> Double {
		let start=Date()
		let nanoseconds=Calendar.current.dateComponents([.nanosecond], from: start)
		let missingNanoceconds=1_000_000_000-(nanoseconds.nanosecond ?? 0)
		return Double(missingNanoceconds)/1_000_000_000
	}
	func getFreezeView(time: Date) -> AnalogDockClockView {
		let analogClockView=AnalogDockClockView()
		analogClockView.setFrameSize(self.appObject.dockTile.size)
		applyColorScheme(digitalClockView: digitalClockView, analogClockView: analogClockView)
		analogClockView.current=false
		analogClockView.freezeDate=time
		analogClockView.draw(analogClockView.bounds)
		return analogClockView
	}
	func applyColorScheme(digitalClockView: DigitalDockClockView, analogClockView: AnalogDockClockView) {
			var contrastColor: NSColor
			let clockNSColors=ColorDictionary()
			if ClockPreferencesStorage.sharedInstance.colorChoice=="custom"{
				contrastColor=ClockPreferencesStorage.sharedInstance.customColor
			} else {
				contrastColor =
					clockNSColors.colorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
			}
			if ClockPreferencesStorage.sharedInstance.colorForForeground==false {
				analogClockView.color=NSColor.labelColor
				digitalClockView.digitalClock.textColor=NSColor.labelColor
				if contrastColor==NSColor.black {
					contrastColor=NSColor.systemGray
				}
				analogClockView.backgroundColor=contrastColor
				digitalClockView.contentStackView.layer?.backgroundColor=contrastColor.cgColor
				analogClockView.color=NSColor.white
				if contrastColor != NSColor.black {
					analogClockView.handsColor=NSColor.black
					digitalClockView.digitalClock.textColor=NSColor.black
				} else {
					analogClockView.handsColor=NSColor.systemGray
					digitalClockView.digitalClock.textColor=NSColor.systemGray
				}
			} else {
				analogClockView.backgroundColor=NSColor.labelColor
				digitalClockView.contentStackView.layer?.backgroundColor=NSColor.labelColor.cgColor
				if contrastColor != NSColor.black {
					analogClockView.color=contrastColor
					digitalClockView.digitalClock.textColor=contrastColor
				} else {
					analogClockView.color=NSColor.systemGray
					digitalClockView.digitalClock.textColor=NSColor.systemGray
				}
				analogClockView.handsColor=NSColor.white
				digitalClockView.digitalClock.textColor=contrastColor
			}
		}
	func updateModelToPreferencesChange(){
		model.setTimeFormatter()
	}
}
