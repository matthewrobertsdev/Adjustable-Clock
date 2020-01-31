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
	var digital = false
	private init() {
		animateTime()
	}
	func updateDockTile() {
		if (digital) {
			digitalClockView.setFrameSize(appObject.dockTile.size)
				appObject.dockTile.contentView=digitalClockView
		} else {
			analogClockView.setFrameSize(appObject.dockTile.size)
			applyColorScheme(clockView: analogClockView)
			appObject.dockTile.contentView=analogClockView
		}
		appObject.dockTile.display()
	}
	func updateClockForPreferencesChange() {
		if (digital) {
			
		} else {
			applyColorScheme(clockView: analogClockView)
		}
		appObject.dockTile.display()
	}
	private func animateTime() {
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		guard let timer=updateTimer else { return }
		timer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(1000), leeway: .milliseconds(0))
		timer.setEventHandler {
			//self.dockClockView.draw(self.dockClockView.frame)
			if self.digital {
				
			} else {
				self.analogClockView.setNeedsDisplay(self.analogClockView.bounds)
				self.appObject.dockTile.display()
			}
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
		let clockView=AnalogDockClockView()
		clockView.setFrameSize(self.appObject.dockTile.size)
		applyColorScheme(clockView: clockView)
		clockView.current=false
		clockView.freezeDate=time
		clockView.draw(clockView.bounds)
		return clockView
	}
	func applyColorScheme(clockView: AnalogDockClockView) {
			var contrastColor: NSColor
			let clockNSColors=ColorDictionary()
			if ClockPreferencesStorage.sharedInstance.colorChoice=="custom"{
				contrastColor=ClockPreferencesStorage.sharedInstance.customColor
			} else {
				contrastColor =
					clockNSColors.colorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
			}
			if ClockPreferencesStorage.sharedInstance.colorForForeground==false {
				clockView.color=NSColor.labelColor
				if contrastColor==NSColor.black {
					contrastColor=NSColor.systemGray
				}
				clockView.backgroundColor=contrastColor
				clockView.color=NSColor.white
				if contrastColor != NSColor.black {
					clockView.handsColor=NSColor.black
				} else {
					clockView.handsColor=NSColor.systemGray
				}
			} else {
				clockView.backgroundColor=NSColor.labelColor
				if contrastColor != NSColor.black {
					clockView.color=contrastColor
				} else {
					clockView.color=NSColor.systemGray
				}
				clockView.handsColor=NSColor.white
			}
		}
}
