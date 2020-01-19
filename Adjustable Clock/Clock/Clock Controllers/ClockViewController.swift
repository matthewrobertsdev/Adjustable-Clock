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
	let backgroundView=DarkAndLightBackgroundView()
	var analogClockAnimator: AnalogClockAnimator?
	override func viewDidLoad() {
		super.viewDidLoad()
		//view=backgroundView
		//view.wantsLayer=true
		view.addSubview(backgroundView, positioned: .below, relativeTo: view)
		backgroundView.translatesAutoresizingMaskIntoConstraints=false
		//*
		let leadingConstraint=NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		let trailingConstraint=NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		let topConstraint=NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let bottomConstraint=NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
		updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		maginiferScrollView.maxMagnification=200
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		/*
		let distribitedNotificationCenter=DistributedNotificationCenter.default
		let interfaceNotification=NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification")
		distribitedNotificationCenter.addObserver(self, selector: #selector(interfaceModeChanged(sender:)), name: interfaceNotification, object: nil)
*/
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
				#selector(interfaceModeChanged(sender:)), name: colorChangeNotification, object: nil)
		guard let timeProtocol=tellingTime else { return }
		guard let timer=updateTimer else { return }
		digitalClockAnimator=DigitalClockAnimator(model: model, tellingTime: timeProtocol, updateTimer: timer, digitalClock: digitalClock, animatedDay: animatedDay)
		analogClockAnimator=AnalogClockAnimator(model: model, tellingTime: timeProtocol, updateTimer: timer, analogClock: analogClock, animatedDay: animatedDay)
		colorController=ClockColorController(visualEffectView: visualEffectView, view: backgroundView, digitalClock: digitalClock, animatedDay: animatedDay, analogClock: analogClock)
		if ClockPreferencesStorage.sharedInstance.useAnalog {
			showAnalogClock()
		} else {
			showDigitalClock() }
		print("abcd")
	}
	@objc func interfaceModeChanged(sender: NSNotification) {
		//colorController?.applyColorScheme()
		backgroundView.draw(backgroundView.bounds)
	}
	func showAnalogClock() {
		setConstraints()
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: digitalClock)
		clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: analogClock)
		model.updateClockModelForPreferences()
		updateSizeConstraints()
		guard let clockWindowController=view.window?.windowController as? ClockWindowController else { return }
			clockWindowController.resizeContents()
		guard let width=self.view.window?.frame.width else { return }
			if ClockPreferencesStorage.sharedInstance.fullscreen==false {
				clockWindowController.sizeWindowToFitClock(newWidth: width)
			}
		analogClock.setNeedsDisplay(analogClock.bounds)
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
		clockWindowController.resizeContents()
		guard let width=self.view.window?.frame.width else { return }
		if ClockPreferencesStorage.sharedInstance.fullscreen==false {
			clockWindowController.sizeWindowToFitClock(newWidth: width)
		}
		digitalClockAnimator?.animate()
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
		if let trailingConstraint=magnifierTrailingConstraint {
			trailingConstraint.isActive=false
		}
		if let bottomConstraint=magnifierBottomConstaint {
			bottomConstraint.isActive=true
		}
		if let topConstraint=magnifierTopConstraint {
			topConstraint.isActive=true
		}
	}
	func activateWidthConstraints() {
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
	func updateSizeConstraints() {
		maginfierAspectRatioConstraint=maginfierAspectRatioConstraint.setMultiplier(model.width/model.height)
		clockWidthConstraint.constant=model.width
		clockHeightConstraint.constant=model.height
		analogClock.widthConstraint.constant=model.width
		analogClock.positionLabels()
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
	func displayForDock() {
		if ClockPreferencesStorage.sharedInstance.useAnalog {
			analogClockAnimator?.displayForDock()
		} else {
			digitalClockAnimator?.displayForDock()
		}
	}
}
