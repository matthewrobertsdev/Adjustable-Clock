//
//  DigitalClockWC.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class ClockWindowController: NSWindowController, NSWindowDelegate {
	static var clockObject=ClockWindowController()
	var hideButtonsTimer: Timer?
    var backgroundView: NSView?
    var trackingArea: NSTrackingArea?
	let analogConstant=CGFloat(10)
    override func windowDidLoad() {
        super.windowDidLoad()
		ClockWindowController.clockObject=ClockWindowController()
		guard let clockViewController=window?.contentViewController as? ClockViewController else { return }
        backgroundView=clockViewController.view
		window?.minSize=CGSize(width: 150, height: 150)
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		if ClockPreferencesStorage.sharedInstance.hasLaunchedBefore() {
			ClockWindowRestorer().loadSavedWindowCGRect(window: window)
        }
		ClockPreferencesStorage.sharedInstance.setApplicationAsHasLaunched()
        clockViewController.updateClock()
		if let windowSize=window?.frame.size {
			window?.aspectRatio=windowSize
		}
        window?.isMovableByWindowBackground=true
        window?.delegate=self
		if ClockPreferencesStorage.sharedInstance.fullscreen==false {
			prepareWindowButtons()
		} else {
            showButtons(show: true)
        }
        enableClockMenu(enabled: true)
        updateClockMenuUI()
        window?.isOpaque=false
    }
	func clockWindowPresent() -> Bool {
		return windowPresent(identifier: UserInterfaceIdentifier.digitalClockWindow)
	}
	func showClock() {
		if clockWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let clockWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"ClockWindowController") as? ClockWindowController else { return }
		ClockWindowController.clockObject=clockWindowController
		ClockWindowController.clockObject.loadWindow()
		ClockWindowController.clockObject.showWindow(nil)
		} else {
			let appObject = NSApp as NSApplication
			for window in appObject.windows where window.identifier==UserInterfaceIdentifier.digitalClockWindow {
				window.makeKeyAndOrderFront(nil)
			}
		}
	}
	func closeDigitalClock() {
		let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.digitalClockWindow { window.close() }
	}
    func setTrackingArea() {
		guard let view=backgroundView else { return }
		let rect=view.frame
		let trackingOptions: NSTrackingArea.Options =
			[NSTrackingArea.Options.activeInKeyWindow, NSTrackingArea.Options.inVisibleRect, NSTrackingArea.Options.mouseMoved]
        trackingArea=NSTrackingArea(rect: rect, options: trackingOptions, owner: view.window, userInfo: nil)
		guard let area=trackingArea else { return }
        view.addTrackingArea(area)
    }
    func sizeWindowToFitClock(newWidth: CGFloat) {
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return }
		var newHeight: CGFloat=100
		newHeight=newWidth/digitalClockVC.model.width*digitalClockVC.model.height
		var newSize=NSSize(width: newWidth, height: newHeight)
        let changeInHeight=newHeight-(window?.frame.height ?? 0)
        let changeInWidth=newWidth-(window?.frame.width ?? 0)
		guard let windowOrigin=window?.frame.origin else { return }
		var newOrigin=CGPoint(x: windowOrigin.x-changeInWidth, y: windowOrigin.y-changeInHeight)
		if ClockPreferencesStorage.sharedInstance.fullscreen {
			if let size=window?.frame.size {
				newSize=size
				newOrigin=CGPoint(x: 0, y: 0)
			}
		}
        let newRect=NSRect(origin: newOrigin, size: newSize)
        window?.setFrame(newRect, display: true)
    }
    func windowDidBecomeKey(_ notification: Notification) {
		flashButtons()
    }
    func windowDidResignKey(_ notification: Notification) {
        if ClockPreferencesStorage.sharedInstance.fullscreen==false {
            showButtons(show: false)
        }
    }
    override func mouseMoved(with event: NSEvent) {
        flashButtons()
    }
    func windowDidResize(_ notification: Notification) {
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return }
		digitalClockVC.updateSizeConstraints()
		digitalClockVC.setConstraints()
        resizeContents()
		guard let windowIsZoomed=window?.isZoomed else { return }
        if windowIsZoomed==false && ClockPreferencesStorage.sharedInstance.fullscreen==false {
			let newAspectRatio=NSSize(width: digitalClockVC.model.width, height: digitalClockVC.model.height)
            window?.aspectRatio=newAspectRatio
            showButtons(show: false)
        } else {
            showButtons(show: true)
        }
    }
	func resizeContents() {
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return }
		guard let windowSize=window?.frame.size else { return }/*if ClockPreferencesStorage.sharedInstance.useAnalog && ClockPreferencesStorage.sharedInstance.fullscreen {
			digitalClockVC.resizeContents(maxHeight: windowSize.height)
		} else {*/
		guard let windowWidth=window?.frame.size.width else { return }
		if digitalClockVC.view.frame.size.width/digitalClockVC.view.frame.size.height<digitalClockVC.model.width/digitalClockVC.model.height {
			digitalClockVC.resizeContents(maxWidth: windowSize.width)
		} else {
			digitalClockVC.resizeContents(maxHeight: windowSize.height)
		}
			
			
		//}
	}
    func windowWillClose(_ notification: Notification) {
		saveState()
		enableClockMenu(enabled: false)
		let appObject = NSApp as NSApplication
		appObject.terminate(self)
    }
    func windowWillEnterFullScreen(_ notification: Notification) {
        saveState()
        ClockPreferencesStorage.sharedInstance.fullscreen=true
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return }
		digitalClockVC.setConstraints()
		resizeContents()
		setFullScreenFrame()
    }
	func setFullScreenFrame() {
		if let windowSize=window?.frame.size {
			window?.aspectRatio=windowSize
		}
		if let screen=window?.screen?.frame {
			window?.setFrame(screen, display: true)
		}
	}
    func windowDidEnterFullScreen(_ notification: Notification) {
        removeTrackingArea()
        hideButtonsTimer?.invalidate()
        updateClockMenuUI()
        reloadPreferencesWindowIfOpen()
        window?.makeKey()
        showButtons(show: true)
    }
    func windowWillExitFullScreen(_ notification: Notification) {
		ClockPreferencesStorage.sharedInstance.fullscreen=false
		let maxWidth=CGFloat(ClockWindowRestorer().getClockWidth())
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return }
		digitalClockVC.resizeContents(maxWidth: maxWidth)
		digitalClockVC.clockHeightConstraint.constant=digitalClockVC.model.height
		sizeWindowToFitClock(newWidth: maxWidth)
    }
    func windowDidExitFullScreen(_ notification: Notification) {
        window?.makeKey()
		prepareWindowButtons()
        updateClockMenuUI()
        reloadPreferencesWindowIfOpen()
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return }
		window?.aspectRatio=NSSize(width: digitalClockVC.model.width, height: digitalClockVC.model.height)
    }
    func windowWillUseStandardFrame(_ window: NSWindow,
                                    defaultFrame newFrame: NSRect) -> NSRect {
		guard let screenFrame=window.screen?.visibleFrame else { return newFrame }
		return screenFrame
    }
    func flashButtons() {
        showButtons(show: true)
        hideButtonsTimer?.invalidate()
        hideButtonsTimer = Timer.scheduledTimer(timeInterval: 1,
                                                target: self,
                                                selector: #selector(hideButtons(timer:)),
                                                userInfo: nil,
                                                repeats: false)
    }
    @objc func hideButtons(timer: Timer) {
		if ClockPreferencesStorage.sharedInstance.fullscreen==false {
            showButtons(show: false)
        }
    }
    func showButtons(show: Bool) {
		if show==true {
			self.window?.standardWindowButton(.closeButton)?.isHidden=(false)
			self.window?.standardWindowButton(.zoomButton)?.isHidden=(false)
			self.window?.standardWindowButton(.miniaturizeButton)?.isHidden=(false)
		} else {
			self.window?.standardWindowButton(.closeButton)?.isHidden=(true)
			self.window?.standardWindowButton(.zoomButton)?.isHidden=(true)
			self.window?.standardWindowButton(.miniaturizeButton)?.isHidden=(true)
			}
    }
    func saveState() {
        ClockWindowRestorer().windowSaveCGRect(window: window)
    }
    func removeTrackingArea() {
		guard let view=backgroundView else { return }
		guard let area=trackingArea else { return }
		view.removeTrackingArea(area)
    }
    func reloadPreferencesWindowIfOpen() {
        let appObject = NSApp as NSApplication
		guard let mainMenu=appObject.mainMenu as? MainMenu else { return }
		if isThereAPreferencesWindow() {
			mainMenu.reloadSimplePreferencesWindow()
		}
    }
	func windowWillMiniaturize(_ notification: Notification) {
		if let digitalClockVC=window?.contentViewController as? ClockViewController {
			digitalClockVC.digitalClockAnimator?.displayForDock()
		}
	}
	func windowDidDeminiaturize(_ notification: Notification) {
		if let digitalClockVC=window?.contentViewController as? ClockViewController {
			digitalClockVC.animateClock()
		}
	}
	func prepareWindowButtons() {
		showButtons(show: false)
        flashButtons()
        setTrackingArea()
	}
	func updateClockToPreferencesChange() {
        let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.digitalClockWindow {
			if let digitalClockViewController=window.contentViewController as? ClockViewController {
					digitalClockViewController.updateClock()
            }
        }
    }
	func applyFloatState() {
		if ClockPreferencesStorage.sharedInstance.clockFloats {
			self.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow))-1)
		} else {
			self.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.normalWindow)))
		}
	}
}
