//
//  ViewController.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class ClockViewController: NSViewController {
	@IBOutlet weak var analogClock: AnalogClockView!
	@IBOutlet weak var digitalClock: NSTextField!
	@IBOutlet weak var animatedDayInfo: NSTextField!
	@IBOutlet weak var clockStackView: NSStackView!
	@IBOutlet weak var visualEffectView: NSVisualEffectView!
	@IBOutlet weak var maginiferScrollView: NSScrollView!
	@IBOutlet weak var analogClockHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var analogClockWidthConstraint: NSLayoutConstraint!
	let clockModel=ClockModel()
	var magnifierSemaphore=DispatchSemaphore(value: 1)
	var tellingTime: NSObjectProtocol?
	var updateTimer: DispatchSourceTimer?
	let workspaceNotifcationCenter=NSWorkspace.shared.notificationCenter
	func showAnalogClock() {
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: digitalClock)
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: animatedDayInfo)
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: analogClock)
		if let clockWindowController=view.window?.windowController as? ClockWindowController  {
			if let width=self.view.window?.frame.size.width {
				clockWindowController.sizeWindowToFitClock(newWidth: width)
			}
		}
	}
	func showDigitalClock() {
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: analogClock)
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: digitalClock)
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: animatedDayInfo)
		guard let clockWindowController=view.window?.windowController as? ClockWindowController else {
			return
		}
		if let width=self.view.window?.frame.size.width {
			if  self.view.isInFullScreenMode==false {
				resizeContents(maxWidth: width)
				clockWindowController.sizeWindowToFitClock(newWidth: width)
			}
		}
		if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
			animateTimeAndDayInfo()
		} else {
			animateTime()
		}
	}
	func displayForDock() {
		guard let timer=updateTimer else {
			return
		}
		timer.cancel()
		self.digitalClock.stringValue=clockModel.dockTimeString
		self.animatedDayInfo.stringValue=clockModel.dockDateString
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		maginiferScrollView.maxMagnification=200
		
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		if ClockPreferencesStorage.sharedInstance.useAnalog {
			showAnalogClock()
		} else {
			showDigitalClock()
		}
		let screenSleepObserver =
			workspaceNotifcationCenter.addObserver(forName:
			NSWorkspace.screensDidSleepNotification, object: nil, queue: nil) { (_) in
				guard let timer=self.updateTimer else {
					return
				}
				timer.cancel()
				self.updateTimer=nil
				self.digitalClock.stringValue="Relaunch To Resume"
				self.animatedDayInfo.stringValue=""
				self.resizeContents(maxWidth: self.view.window?.frame.width ?? CGFloat(200))
		}
		let screenWakeObserver =
			workspaceNotifcationCenter.addObserver(forName:
			NSWorkspace.screensDidWakeNotification, object: nil, queue: nil) { (_) in
				self.animateClock()
				guard let windowWidth=self.view.window?.frame.width else {
					return
				}
				self.resizeContents(maxWidth: windowWidth)
		}
		let processOptions: ProcessInfo.ActivityOptions=[ProcessInfo.ActivityOptions.userInitiatedAllowingIdleSystemSleep]
		tellingTime = ProcessInfo().beginActivity(options: processOptions, reason: "Need accurate time all the time")
		let notifier=DistributedNotificationCenter.default
		let colorChangeNotification=NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification")
		let colorChangeObserver =
			notifier.addObserver(self, selector:
				#selector(applyColors(sender:)), name: colorChangeNotification, object: nil)
	}
	func updateClockModel() {
		clockModel.updateClockModelForPreferences()
		analogClock.setNeedsDisplay(analogClock.frame)
		
	}
	func updateClock() {
		updateClockModel()
		applyColorScheme()
		applyFloatState()
		animateClock()
		resizeClock()
	}
	func animateClock() {
		if ClockPreferencesStorage.sharedInstance.useAnalog==false {
			showDigitalClock()
			if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
				clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: animatedDayInfo!)
				animateTimeAndDayInfo()
			} else {
				clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: animatedDayInfo!)
				animateTime()
			}
		} else {
			showAnalogClock()
		}
	}
	func resizeClock() {
		if ClockPreferencesStorage.sharedInstance.useAnalog==false {
			if let windowWidth=view.window?.frame.size.width {
				resizeContents(maxWidth: windowWidth)
			}
			guard let digitalClockWC=view.window?.windowController as? ClockWindowController else {
				return
			}
			if ClockPreferencesStorage.sharedInstance.fullscreen==false && self.view.window?.isZoomed==false {
				if let newWidth=self.view.window?.frame.width {
					digitalClockWC.sizeWindowToFitClock(newWidth: newWidth)
				}
			} else {
				digitalClockWC.sizeWindowToFitClock(newWidth: analogClock.frame.width)
			}
		}
	}
	func resizeContents(maxWidth: CGFloat) {
		magnifierSemaphore.wait()
		if ClockPreferencesStorage.sharedInstance.useAnalog==false {
			digitalClock.sizeToFit()
			animatedDayInfo.sizeToFit()
			let desiredMaginifcation=(maxWidth/332)//clockStackView.frame.width)*0.98
			maginiferScrollView.magnification=desiredMaginifcation
			if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
				let projectedTimeHeight=makeTimeMaxSize(maxWidth: maxWidth).height
				let projectedDateHeight=makeDateMaxSize(maxWidth: maxWidth).height
				let projectedHeight=projectedTimeHeight+projectedDateHeight
				if let maxHeight=self.view.window?.screen?.visibleFrame.height {
					if projectedHeight>maxHeight {
					} else {
					}
				} else {
				}
			} else {
				let projectedHeight=makeDateMaxSize(maxWidth: (self.view.window?.frame.width) ?? CGFloat(200)).height
				if let maxHeight=self.view.window?.screen?.visibleFrame.height {
					if projectedHeight>maxHeight {
					} else {
					}
				} else {
				}
			}
		} else {
			analogClock.setNeedsDisplay(analogClock.frame)
		}
		magnifierSemaphore.signal()
	}
	func updateTime() {
		let timeString=clockModel.getTime()
		if digitalClock?.stringValue != timeString {
			digitalClock?.stringValue=timeString
		}
	}
	func updateTimeAndDayInfo() {
		let timeString=clockModel.getTime()
		if digitalClock?.stringValue != timeString {
			digitalClock?.stringValue=timeString
			let dayInfo=clockModel.getDayInfo()
			animatedDayInfo?.stringValue=dayInfo
		}
	}
	func animateTimeAndDayInfo() {
		digitalClock?.stringValue=clockModel.getTime()
		animatedDayInfo?.stringValue=clockModel.getDayInfo()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		guard let timer=updateTimer else {
			return
		}
		timer.schedule(deadline: .now(), repeating: .milliseconds(clockModel.updateTime), leeway: .milliseconds(10))
		timer.setEventHandler {
			self.updateTimeAndDayInfo()
		}
		timer.resume()
	}
	func animateTime() {
		digitalClock?.stringValue=clockModel.getTime()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		guard let timer=updateTimer else {
			return
		}
		timer.schedule(deadline: .now(), repeating: .milliseconds(clockModel.updateTime), leeway: .milliseconds(10))
		timer.setEventHandler {
			self.updateTime()
		}
		timer.resume()
	}
	@objc func applyColors(sender: NSNotification) {
		applyColorScheme()
	}
	func applyColorScheme() {
		var contrastColor: NSColor
		let clockNSColors=ColorDictionary()
		self.view.wantsLayer=true
		if ClockPreferencesStorage.sharedInstance.colorChoice=="custom"{
			contrastColor=ClockPreferencesStorage.sharedInstance.customColor
		} else {
			contrastColor =
				clockNSColors.colorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
		}
		if ClockPreferencesStorage.sharedInstance.colorForForeground==false {
			visualEffectView.isHidden=true
			digitalClock.textColor=NSColor.labelColor
			animatedDayInfo.textColor=NSColor.labelColor
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
			self.view.layer?.backgroundColor=contrastColor.cgColor
			animatedDayInfo.backgroundColor=contrastColor
			analogClock.color=NSColor.labelColor
			analogClock.setNeedsDisplay(analogClock.frame)
		} else {
			visualEffectView.isHidden=false
			digitalClock.textColor=contrastColor
			animatedDayInfo.textColor=contrastColor
			analogClock.color=contrastColor
			analogClock.setNeedsDisplay(analogClock.frame)
			self.view.layer?.backgroundColor = NSColor.labelColor.cgColor/*NSColor.clear.cgColor*/
		}
	}
	func applyFloatState() {
		if ClockPreferencesStorage.sharedInstance.clockFloats {
			self.view.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow))-1)
		} else {
			self.view.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.normalWindow)))
		}
	}
	func makeTimeMaxSize(maxWidth: CGFloat) -> CGSize {
		return CGSize(width: maxWidth, height: maxWidth*clockModel.timeSizeRatio)
	}
	func makeDateMaxSize(maxWidth: CGFloat) -> CGSize {
		return CGSize(width: maxWidth, height: maxWidth*clockModel.dateSizeRatio)
	}
	func stopAnimatingDigital() {
		if let timeActivity=tellingTime {
			ProcessInfo().endActivity(timeActivity)
		}
		if let timer=updateTimer {
			timer.cancel()
		}
	}
	deinit {
		stopAnimatingDigital()
	}
}
