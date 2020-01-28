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
	let dockClockView=DockClockView()
	let appObject = NSApp as NSApplication
	var tellingTime: NSObjectProtocol?
	var updateTimer: DispatchSourceTimer?
	private init() {
		animateTime()
	}
	func updateDockTile() {
		dockClockView.setFrameSize(appObject.dockTile.size)
		applyColorScheme(dockClockView: dockClockView)
		appObject.dockTile.contentView=dockClockView
		appObject.dockTile.display()
	}
	func updateClockForPreferencesChange() {
		applyColorScheme(dockClockView: dockClockView)
		appObject.dockTile.display()
	}
	private func animateTime() {
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		guard let timer=updateTimer else { return }
		timer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(1000), leeway: .milliseconds(0))
		timer.setEventHandler {
			//self.dockClockView.draw(self.dockClockView.frame)
			self.dockClockView.setNeedsDisplay(self.dockClockView.bounds)
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
	func getFreezeView(time: Date)->DockClockView{
		let clockView=DockClockView()
		clockView.setFrameSize(self.appObject.dockTile.size)
		applyColorScheme(dockClockView: clockView)
		clockView.current=false
		clockView.freezeDate=time
		clockView.draw(clockView.bounds)
		return clockView
	}
	func applyColorScheme(dockClockView: DockClockView) {
			var contrastColor: NSColor
			let clockNSColors=ColorDictionary()
			if ClockPreferencesStorage.sharedInstance.colorChoice=="custom"{
				contrastColor=ClockPreferencesStorage.sharedInstance.customColor
			} else {
				contrastColor =
					clockNSColors.colorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
			}
			if ClockPreferencesStorage.sharedInstance.colorForForeground==false {
				dockClockView.color=NSColor.labelColor
				if contrastColor==NSColor.black {
					contrastColor=NSColor.systemGray
				}
				dockClockView.backgroundColor=contrastColor
				dockClockView.color=NSColor.white
				if contrastColor != NSColor.black {
					dockClockView.handsColor=NSColor.black
				} else {
					dockClockView.handsColor=NSColor.systemGray
				}
			} else {
				dockClockView.backgroundColor=NSColor.labelColor
				if contrastColor != NSColor.black {
					dockClockView.color=contrastColor
				} else {
					dockClockView.color=NSColor.systemGray
				}
				dockClockView.handsColor=NSColor.white
			}
		}
}
