//
//  DockClockController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/12/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class DockClockController: NSObject {
	static let dockClockObject=DockClockController()
	let analogClockView=AnalogDockClockView()
	let digitalClockView=DigitalDockClockView()
	let appObject = NSApp as NSApplication
	var tellingTime: NSObjectProtocol?
	var updateTimer: DispatchSourceTimer?
	var model=DockClockModel()
	var preferences=GeneralPreferencesStorage.sharedInstance
	@objc var objectToObserve: DigitalDockClockView!
	var observation: NSKeyValueObservation?
	private override init() {
		super.init()
		GeneralPreferencesStorage.sharedInstance.loadUserPreferences()
		objectToObserve=digitalClockView
		observation = observe(
			\.objectToObserve.dark,
            options: [.old, .new]
        ) { _, _ in
			self.applyColorScheme(digitalClockView: self.digitalClockView, analogClockView: self.analogClockView)
			self.digitalClockView.setNeedsDisplay(self.digitalClockView.bounds)
        }
		animateTime()
	}
	func updateDockTile() {
		if preferences.digital {
			digitalClockView.setFrameSize(appObject.dockTile.size)
			appObject.dockTile.contentView=digitalClockView
			digitalClockView.displaySeconds=preferences.seconds
			if !preferences.seconds {
				digitalClockView.removeSeconds()
			} else {
				digitalClockView.addSeconds()
			}
			updateDigitalClock()
		} else if !preferences.digital {
			if preferences.justColors {
				analogClockView.justColors=true
			} else {
				analogClockView.justColors=false
			}
			analogClockView.setFrameSize(appObject.dockTile.size)
			appObject.dockTile.contentView=analogClockView
				analogClockView.displaySeconds=preferences.seconds
		}
		applyColorScheme(digitalClockView: digitalClockView, analogClockView: analogClockView)
		digitalClockView.setNeedsDisplay(digitalClockView.bounds)
		appObject.dockTile.display()
	}
	func updateClockForPreferencesChange() {
		updateDockTile()
		if preferences.justColors {
			updateTimer?.cancel()
		} else {
			animateTime()
		}
	}
	private func animateTime() {
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		guard let timer=updateTimer else { return }
		timer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(1000), leeway: .milliseconds(0))
		timer.setEventHandler {
			if self.preferences.digital {
				self.updateDigitalClock()
			} else {
				self.analogClockView.setNeedsDisplay(self.analogClockView.bounds)
			}
			self.appObject.dockTile.display()
		}
		timer.resume()
	}
	func updateDigitalClock() {
		digitalClockView.digitalClock.stringValue=model.getTimeString(date: Date())
		self.digitalClockView.digitalClock.sizeToFit()
		digitalClockView.digitalSeconds.stringValue=model.getSecondsString(date: Date())
		self.digitalClockView.digitalSeconds.sizeToFit()
	}
	func getSecondAdjustment() -> Double {
		let start=Date()
		let nanoseconds=Calendar.current.dateComponents([.nanosecond], from: start)
		let missingNanoceconds=1_000_000_000-(nanoseconds.nanosecond ?? 0)
		return Double(missingNanoceconds)/1_000_000_000
	}
	func getFreezeView(time: Date) -> NSView {
		let analogClockView=AnalogDockClockView()
		let digitalClockView=DigitalDockClockView()
		applyColorScheme(digitalClockView: digitalClockView, analogClockView: analogClockView)
		if preferences.digital {
			digitalClockView.setFrameSize(self.appObject.dockTile.size)
			digitalClockView.removeSeconds()
			digitalClockView.digitalClock.stringValue=model.getTimeString(date: time)
			self.digitalClockView.digitalClock.sizeToFit()
			return digitalClockView
		} else {
			analogClockView.setFrameSize(self.appObject.dockTile.size)
			analogClockView.current=false
			analogClockView.freezeDate=time
			analogClockView.draw(analogClockView.bounds)
			return analogClockView
		}
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
				digitalClockView.backgroundColor=NSColor.labelColor
				if contrastColor==NSColor.black {
					analogClockView.backgroundColor=NSColor.systemGray
				}
				analogClockView.backgroundColor=contrastColor
				digitalClockView.backgroundColor=contrastColor
				analogClockView.color=NSColor.white
				digitalClockView.digitalClock.textColor=NSColor.white
				digitalClockView.digitalSeconds.textColor=NSColor.white
				if contrastColor != NSColor.black {
					analogClockView.handsColor=NSColor.black
					if digitalClockView.hasDarkAppearance { digitalClockView.digitalClock.textColor=NSColor.white
					digitalClockView.digitalSeconds.textColor=NSColor.white
					} else {
						digitalClockView.digitalClock.textColor=NSColor.black
						digitalClockView.digitalSeconds.textColor=NSColor.black
					}
				} else {
				print("should be gray")
					analogClockView.handsColor=NSColor.systemGray
					digitalClockView.digitalClock.textColor=NSColor.systemGray
					digitalClockView.digitalSeconds.textColor=NSColor.systemGray
				}
			} else {
				analogClockView.backgroundColor=NSColor.labelColor
				digitalClockView.backgroundColor=NSColor.black
				print("should be black")
				if contrastColor != NSColor.black {
					analogClockView.color=contrastColor
					digitalClockView.digitalClock.textColor=contrastColor
					digitalClockView.digitalSeconds.textColor=contrastColor
				} else {
					analogClockView.color=NSColor.systemGray
					digitalClockView.backgroundColor=NSColor(named: "BlackBackground") ?? NSColor.systemGray
					digitalClockView.digitalClock.textColor=NSColor.systemGray
					digitalClockView.digitalSeconds.textColor=NSColor.systemGray
				}
				analogClockView.handsColor=NSColor.white
			}
		}
	func updateModelToPreferencesChange() {
		model.setTimeFormatter()
	}
}
