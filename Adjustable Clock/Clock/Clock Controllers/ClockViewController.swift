//
//  ViewController.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class ClockViewController: ColorfulViewController {
	@IBOutlet weak var analogClock: AnalogClockView!
	@IBOutlet weak var digitalClock: NSTextField!
	@IBOutlet weak var animatedDay: NSTextField!
	@IBOutlet weak var clockStackView: NSStackView!
	@IBOutlet weak var maginiferScrollView: MagnifierScrollView!
	@IBOutlet weak var visibleView: NSView!
	@IBOutlet weak var maginfierAspectRatioConstraint: NSLayoutConstraint!
	@IBOutlet var magnifierTopConstraint: NSLayoutConstraint!
	@IBOutlet var magnifierLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var clockWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var clockHeightConstraint: NSLayoutConstraint!
	let model=ClockModel()
	var tellingTime: NSObjectProtocol?
	var updateTimer: DispatchSourceTimer!
	let workspaceNotifcationCenter=NSWorkspace.shared.notificationCenter
	override func viewDidLoad() {
		super.viewDidLoad()
		//updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		/*
		let screenSleepObserver =
			workspaceNotifcationCenter.addObserver(forName:
			NSWorkspace.screensDidSleepNotification, object: nil, queue: nil) { [weak self] (_)  in
				guard let strongSelf=self else {
					return
				}
				strongSelf.updateTimer?.cancel()
				strongSelf.digitalClock.stringValue="Relaunch To Resume"
				strongSelf.animatedDay.stringValue=""
				strongSelf.resizeContents(maxWidth: strongSelf.view.window?.frame.width ?? CGFloat(200))
		}
		*/	/*workspaceNotifcationCenter.addObserver(forName:
			NSWorkspace.screensDidWakeNotification, object: nil, queue: nil) {[weak self] (_)  in
				guard let strongSelf=self else {
					return
				}
				strongSelf.animateClock()
				guard let windowWidth=strongSelf.view.window?.frame.width else {
					return
				}
				strongSelf.resizeContents(maxWidth: windowWidth)} */
		workspaceNotifcationCenter.addObserver(self, selector: #selector(endForSleep),
																		 name: NSWorkspace.screensDidSleepNotification, object: nil)
		workspaceNotifcationCenter.addObserver(self, selector: #selector(startForWake),
																		name: NSWorkspace.screensDidWakeNotification, object: nil)
		let processOptions: ProcessInfo.ActivityOptions=[ProcessInfo.ActivityOptions.userInitiatedAllowingIdleSystemSleep]
		tellingTime = ProcessInfo().beginActivity(options: processOptions, reason: "Need accurate time all the time")
		showClock()
	}
	@objc func interfaceModeChanged(sender: NSNotification) {
		applyColors()
		backgroundView.draw(backgroundView.bounds)
	}
	@objc func endForSleep() {
		updateTimer?.cancel()
		digitalClock.stringValue="Relaunch To Resume"
		animatedDay.stringValue=""
		resizeContents(maxWidth: view.window?.frame.width ?? CGFloat(200))
	}
	@objc func startForWake() {
		animateClock()
		guard let windowWidth=view.window?.frame.width else {
			return
		}
		resizeContents(maxWidth: windowWidth)
	}
	func showClock() {
		if ClockPreferencesStorage.sharedInstance.useAnalog {
			showAnalogClock()
		} else {
			showDigitalClock() }
	}
	func assignMinSize() {
		let aspectWidth=(self.view.window?.frame.width ?? 220)
		let aspectHeight=(self.view.window?.frame.height ?? 220)
		let minHeight=aspectHeight/220*aspectWidth
		self.view.window?.minSize=NSSize(width: 220, height: minHeight)
	}
	func showAnalogClock() {
		assignMinSize()
		setConstraints()
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: digitalClock)
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: analogClock)
		model.updateClockModelForPreferences()
		updateSizeConstraints()
		guard let clockWindowController=view.window?.windowController as? ClockWindowController else { return }
			clockWindowController.resizeContents()
		guard var width=self.view.window?.frame.width else { return }
			if ClockPreferencesStorage.sharedInstance.fullscreen==false {
				width=width<220 ? 220 : width
				clockWindowController.sizeWindowToFitClock(newWidth: width)
			}
		showHideDate()
		animateAnalog()
		analogClock.setNeedsDisplay(analogClock.bounds)
		analogClock.layoutSubtreeIfNeeded()
	}
	func showDigitalClock() {
		assignMinSize()
		showHideDate()
		setConstraints()
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: analogClock)
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: digitalClock)
		guard let clockWindowController=view.window?.windowController as? ClockWindowController else {
			return
		}
		model.updateClockModelForPreferences()
		updateSizeConstraints()
		animateDigital()
		clockWindowController.resizeContents()
		guard let width=self.view.window?.frame.width else { return }
		if ClockPreferencesStorage.sharedInstance.fullscreen==false {
			clockWindowController.sizeWindowToFitClock(newWidth: width)
		}
	}
	func setConstraints() {
			if self.view.frame.size.width/self.view.frame.size.height<model.width/model.height {
				activateWidthConstraints()
			} else {
				activateHeightConstraints()
			}
	}
	func activateHeightConstraints() {
		if let leadingConstraint=magnifierLeadingConstraint {
			leadingConstraint.isActive=false
		}
		if let topConstraint=magnifierTopConstraint {
			topConstraint.isActive=true
		}
	}
	func activateWidthConstraints() {
		if let topConstraint=magnifierTopConstraint {
			topConstraint.isActive=false
		}
		if let leadingConstraint=magnifierLeadingConstraint {
			leadingConstraint.isActive=true
		}
	}
	func updateSizeConstraints() {
		maginfierAspectRatioConstraint =
			setMultiplier(layoutConstraint: maginfierAspectRatioConstraint, multiplier: model.width/model.height)
		clockWidthConstraint.constant=model.width
		clockHeightConstraint.constant=model.height
		analogClock.widthConstraint.constant=model.width
		analogClock.positionLabels()
		visibleView.setFrameSize(NSSize(width: model.width, height: model.height))
	}
	func updateClock() {
		model.updateClockModelForPreferences()
		animateClock()
		updateSizeConstraints()
		applyColors()
		if let windowController=self.view.window?.windowController as? ClockWindowController {
			if !windowController.fullscreen {
				windowController.applyFloatState()
			}
		}
		resizeClock()
		analogClock.setNeedsDisplay(analogClock.frame)
	}
	func showHideDate() {
		if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
			clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: animatedDay!)
			animatedDay.isHidden=false
		} else {
			clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: animatedDay!)
			animatedDay.isHidden=true
		}
	}
	func animateClock() {
	if ClockPreferencesStorage.sharedInstance.useAnalog==false {
		showDigitalClock()
	} else {
		showAnalogClock()
	}
	}
	func resizeClock() {
		guard let digitalClockWC=view.window?.windowController as? ClockWindowController else {
			return
		}
		if !ClockPreferencesStorage.sharedInstance.useAnalog || !digitalClockWC.fullscreen {
		if let windowWidth=view.window?.frame.size.width {
			self.resizeContents(maxWidth: windowWidth)
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
			digitalClock.sizeToFit()
			animatedDay.sizeToFit()
			let desiredMaginifcation=maxWidth/model.width
			maginiferScrollView.magnification=desiredMaginifcation
	}
	func resizeContents(maxHeight: CGFloat) {
			digitalClock.sizeToFit()
			animatedDay.sizeToFit()
			let desiredMaginifcation=maxHeight/model.height
			maginiferScrollView.magnification=desiredMaginifcation
	}
	@objc func applyColors(sender: NSNotification) {
		applyColors()
		}
	deinit { stopAnimating()
	}
	func applyColors() {
		let labels=[digitalClock!, animatedDay!]
		applyColorScheme(views: [analogClock], labels: labels)
	}
	func displayForDock() {
		if ClockPreferencesStorage.sharedInstance.useAnalog {
			displayAnalogForDock()
		} else {
			displayDigitalForDock()
		}
	}
	func getSecondAdjustment() -> Double {
		let start=Date()
		let nanoseconds=Calendar.current.dateComponents([.nanosecond], from: start)
		let missingNanoceconds=1_000_000_000-(nanoseconds.nanosecond ?? 0)
		return Double(missingNanoceconds)/1_000_000_000
	}
	func stopAnimating() {
		ProcessInfo().endActivity(tellingTime!)
		tellingTime=nil
		updateTimer.cancel()
	}
}
