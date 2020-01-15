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
		applyColorScheme()
		appObject.dockTile.contentView=dockClockView
		appObject.dockTile.display()
	}
	func updateClockForPreferencesChange() {
		applyColorScheme()
		appObject.dockTile.display()
	}
	private func animateTime() {
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		guard let timer=updateTimer else { return }
		timer.schedule(deadline: .now()+getSecondAdjustment(), repeating: .milliseconds(1000), leeway: .milliseconds(0))
		timer.setEventHandler {
			self.dockClockView.draw(self.dockClockView.frame)
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
	func applyColorScheme() {
			var contrastColor: NSColor
			let clockNSColors=ColorDictionary()
			if ClockPreferencesStorage.sharedInstance.colorChoice=="custom"{
				contrastColor=ClockPreferencesStorage.sharedInstance.customColor
			} else {
				contrastColor =
					clockNSColors.colorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
			}
			if ClockPreferencesStorage.sharedInstance.colorForForeground==false {
				dockClockView.foregorundColor=NSColor.labelColor
				if contrastColor==NSColor.black {
					contrastColor=NSColor.systemGray
				}
				if #available(OSX 10.14, *) {
					if let uiName=NSApp?.effectiveAppearance.name {
						if uiName==NSAppearance.Name.darkAqua||uiName==NSAppearance.Name.accessibilityHighContrastDarkAqua||uiName==NSAppearance.Name.accessibilityHighContrastVibrantDark {
							if contrastColor==NSColor.white {
								contrastColor=NSColor.systemGray
							}
						}
					}
				}
				dockClockView.foregorundColor=NSColor.white
				dockClockView.backgroundColor=contrastColor
				dockClockView.color=NSColor.white
			} else {
				dockClockView.foregorundColor=contrastColor
				dockClockView.backgroundColor=NSColor.labelColor
				dockClockView.color=contrastColor
			}
		}
}
