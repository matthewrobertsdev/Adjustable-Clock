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
	@IBOutlet weak var animatedDay: NSTextField!
	@IBOutlet weak var clockStackView: NSStackView!
	@IBOutlet weak var visualEffectView: NSVisualEffectView!
	@IBOutlet weak var maginiferScrollView: MagnifierScrollView!
	@IBOutlet weak var visibleView: NSView!
	@IBOutlet weak var maginfierAspectRatioConstraint: NSLayoutConstraint!
	@IBOutlet var magnifierTopConstraint: NSLayoutConstraint!
	@IBOutlet var magnifierLeadingConstraint: NSLayoutConstraint!
	@IBOutlet var magnifierBottomConstaint: NSLayoutConstraint!
	@IBOutlet var magnifierTrailingConstraint: NSLayoutConstraint!
	@IBOutlet weak var clockWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var clockHeightConstraint: NSLayoutConstraint!
	let model=ClockModel()
	var magnifierSemaphore=DispatchSemaphore(value: 1)
	var tellingTime: NSObjectProtocol?
	var updateTimer: DispatchSourceTimer?
	let workspaceNotifcationCenter=NSWorkspace.shared.notificationCenter
	var colorController: ClockColorController?
	var digitalClockAnimator: DigitalClockAnimator?
	var analogClockAnimator: AnalogClockAnimator?
	override func viewDidLoad() {
		super.viewDidLoad()
		updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		maginiferScrollView.maxMagnification=200
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		let screenSleepObserver =
			workspaceNotifcationCenter.addObserver(forName:
			NSWorkspace.screensDidSleepNotification, object: nil, queue: nil) { (_) in
				self.updateTimer?.cancel()
				self.digitalClock.stringValue="Relaunch To Resume"
				self.animatedDay.stringValue=""
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
		guard let timeProtocol=tellingTime else { return }
		guard let timer=updateTimer else { return }
		digitalClockAnimator=DigitalClockAnimator(model: model, tellingTime: timeProtocol, updateTimer: timer, digitalClock: digitalClock, animatedDay: animatedDay)
		analogClockAnimator=AnalogClockAnimator(model: model, tellingTime: timeProtocol, updateTimer: timer, analogClock: analogClock, animatedDay: animatedDay)
		colorController=ClockColorController(visualEffectView: visualEffectView, view: view, digitalClock: digitalClock, animatedDay: animatedDay, analogClock: analogClock)
		if ClockPreferencesStorage.sharedInstance.useAnalog {
			showAnalogClock()
		} else {
			showDigitalClock() }
	}
	func showAnalogClock() {
		setConstraints()
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: digitalClock)
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: analogClock)
		model.updateClockModelForPreferences()
		updateSizeConstraints()
		if let clockWindowController=view.window?.windowController as? ClockWindowController {
			if let width=self.view.window?.frame.size.width {
				clockWindowController.sizeWindowToFitClock(newWidth: width)
			}
		}
		if ClockPreferencesStorage.sharedInstance.fullscreen {
			if let windowHeight=view.window?.screen?.frame.height {
				resizeContents(maxHeight: windowHeight)
			}
		}
		//analogClock.setNeedsDisplay(analogClock.bounds)
		analogClockAnimator?.animate()
	}
	func showDigitalClock() {
		setConstraints()
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: analogClock)
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: digitalClock)
		guard let clockWindowController=view.window?.windowController as? ClockWindowController else {
			return
		}
		model.updateClockModelForPreferences()
		updateSizeConstraints()
		if ClockPreferencesStorage.sharedInstance.fullscreen {
			if let windowWidth=view.window?.screen?.frame.width {
				resizeContents(maxWidth: windowWidth)
			}
		}
		if let width=self.view.window?.frame.size.width {
			if self.view.isInFullScreenMode==false {
				resizeContents(maxWidth: width)
				clockWindowController.sizeWindowToFitClock(newWidth: width)
			}
		}
		digitalClockAnimator?.animate()
	}
	func setConstraints() {
		if ClockPreferencesStorage.sharedInstance.useAnalog {
			if let leadingConstraint=magnifierLeadingConstraint {
				leadingConstraint.isActive=false
			}
			if let trailingConstraint=magnifierTrailingConstraint {
				trailingConstraint.isActive=false
			}
			if let bottomConstraint=magnifierBottomConstaint {
				bottomConstraint.isActive=true
			}
			if let topConstraint=magnifierTopConstraint {
				topConstraint.isActive=true
			}
		} else {
			if let bottomConstraint=magnifierBottomConstaint {
				bottomConstraint.isActive=false
			}
			if let topConstraint=magnifierTopConstraint {
				topConstraint.isActive=false
			}
			if let leadingConstraint=magnifierLeadingConstraint {
				leadingConstraint.isActive=true
			}
			if let trailingConstraint=magnifierTrailingConstraint {
				trailingConstraint.isActive=true
			}
		}
	}
	func updateSizeConstraints() {
		maginfierAspectRatioConstraint=maginfierAspectRatioConstraint.setMultiplier(model.width/model.height)
		clockWidthConstraint.constant=model.width
		clockHeightConstraint.constant=model.height
		analogClock.widthConstraint.constant=model.width
		visibleView.setFrameSize(NSSize(width: model.width, height: model.height))
	}
	func updateClock() {
		model.updateClockModelForPreferences()
		updateSizeConstraints()
		colorController?.applyColorScheme()
		if let windowController=self.view.window?.windowController as? ClockWindowController {
			windowController.applyFloatState()
		}
		animateClock()
		resizeClock()
		analogClock.setNeedsDisplay(analogClock.frame)
	}
	func animateClock() {
			if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
				clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: animatedDay!)
				animatedDay.isHidden=false
			} else {
				clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: animatedDay!)
				animatedDay.isHidden=true
			}
	if ClockPreferencesStorage.sharedInstance.useAnalog==false {
		showDigitalClock()
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
			digitalClock.sizeToFit()
			animatedDay.sizeToFit()
			let desiredMaginifcation=maxWidth/model.width
			maginiferScrollView.magnification=desiredMaginifcation
		magnifierSemaphore.signal()
	}
	func resizeContents(maxHeight: CGFloat) {
		magnifierSemaphore.wait()
			digitalClock.sizeToFit()
			animatedDay.sizeToFit()
			let desiredMaginifcation=maxHeight/model.height
			maginiferScrollView.magnification=desiredMaginifcation
		magnifierSemaphore.signal()
	}
	@objc func applyColors(sender: NSNotification) { colorController?.applyColorScheme() }
	deinit { digitalClockAnimator?.stopAnimating() }
}
