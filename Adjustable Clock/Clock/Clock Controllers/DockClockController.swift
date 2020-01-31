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
	var preferences=GeneralPreferencesStorage.sharedInstance
	private init() {
		animateTime()
	}
	func updateDockTile() {
		if preferences.digital {
			digitalClockView.setFrameSize(appObject.dockTile.size)
			appObject.dockTile.contentView=digitalClockView
			if !preferences.seconds {
				digitalClockView.removeSeconds()
			} else {
				digitalClockView.addSeconds()
			}
			digitalClockView.setNeedsDisplay(digitalClockView.bounds)
		} else if !preferences.digital {
			analogClockView.setFrameSize(appObject.dockTile.size)
			appObject.dockTile.contentView=analogClockView
				analogClockView.displaySeconds=preferences.seconds
		}
		applyColorScheme(digitalClockView: digitalClockView, analogClockView: analogClockView)
		appObject.dockTile.display()
	}
	func updateClockForPreferencesChange() {
		updateDockTile()
		animateTime()
	}
	private func animateTime() {
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		guard let timer=updateTimer else { return }
		timer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(1000), leeway: .milliseconds(0))
		timer.setEventHandler {
			//self.dockClockView.draw(self.dockClockView.frame)
			if self.preferences.digital {
				self.digitalClockView.digitalClock.stringValue=self.model.getTimeString(date: Date())
				self.digitalClockView.digitalClock.sizeToFit()
				self.digitalClockView.digitalSeconds.stringValue=self.model.getSecondsString(date: Date())
				self.digitalClockView.digitalSeconds.sizeToFit()
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
				digitalClockView.backgroundView.contrastColor=NSColor.labelColor
				if contrastColor==NSColor.black {
					contrastColor=NSColor.systemGray
				}
				analogClockView.backgroundColor=contrastColor
				digitalClockView.backgroundView.contrastColor=contrastColor
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
					analogClockView.handsColor=NSColor.systemGray
					digitalClockView.digitalClock.textColor=NSColor.systemGray
					digitalClockView.digitalSeconds.textColor=NSColor.systemGray
				}
			} else {
				analogClockView.backgroundColor=NSColor.labelColor
				digitalClockView.backgroundView.contrastColor=NSColor.black
				print("should be black")
				if contrastColor != NSColor.black {
					analogClockView.color=contrastColor
					digitalClockView.digitalClock.textColor=contrastColor
					digitalClockView.digitalSeconds.textColor=contrastColor
				} else {
					analogClockView.color=NSColor.systemGray
					digitalClockView.digitalClock.textColor=contrastColor
					digitalClockView.digitalSeconds.textColor=contrastColor
				}
				analogClockView.handsColor=NSColor.white
			}
		}
	func updateModelToPreferencesChange() {
		model.setTimeFormatter()
	}
}
