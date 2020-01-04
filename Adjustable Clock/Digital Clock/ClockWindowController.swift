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
	let digitalHeightMultiplier=CGFloat(1.07)
	let analogHeightMultiplier=CGFloat(1.14)
	let analogConstant=CGFloat(10)
    override func windowDidLoad() {
        super.windowDidLoad()
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else {
			return
		}
        backgroundView=digitalClockVC.view
        //setMaxSize()
        setMinSize()
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		if ClockPreferencesStorage.sharedInstance.hasLaunchedBefore() {
			ClockWindowRestorer().loadSavedWindowCGRect(window: window)
        }
		ClockPreferencesStorage.sharedInstance.setApplicationAsHasLaunched()
        digitalClockVC.updateClock()
		if let windowSize=window?.frame.size {
			window?.aspectRatio=windowSize
		}
        window?.isMovableByWindowBackground=true
        window?.delegate=self
		if !ClockPreferencesStorage.sharedInstance.fullscreen {
            prepareWindowButtons()
        } else {
            showButtons(show: true)
        }
        enableClockMenu(enabled: true)
        updateClockMenuUI()
        window?.isOpaque=false
    }
	func digitalClockWindowPresent() -> Bool {
		return windowPresent(identifier: UserInterfaceIdentifier.digitalClockWindow)
	}
	func showDigitalClock() {
		if !digitalClockWindowPresent() {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let digitalClockWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"DigitalClockWindowController") as? ClockWindowController else {
				return
			}
		ClockWindowController.clockObject=digitalClockWindowController
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
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.digitalClockWindow {
			window.close()
		}
	}
    func setTrackingArea() {
		guard let view=backgroundView else {
			return
		}
		let rect=view.frame
		let trackingOptions: NSTrackingArea.Options =
			[NSTrackingArea.Options.activeInKeyWindow, NSTrackingArea.Options.inVisibleRect, NSTrackingArea.Options.mouseMoved]
        trackingArea=NSTrackingArea(rect: rect, options: trackingOptions, owner: view.window, userInfo: nil)
		guard let area=trackingArea else {
			return
		}
        view.addTrackingArea(area)
    }
    func sizeWindowToFitClock(newWidth: CGFloat) {
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else {
			return
		}
		var finalHeight: CGFloat=100
		if !ClockPreferencesStorage.sharedInstance.useAnalog {
			finalHeight=digitalClockVC.clockStackView.fittingSize.height*digitalHeightMultiplier
		} else {
			if let height=window?.frame.width {
				finalHeight=height
			}
		}
		let oldWidth=window?.frame.width
		var newSize=NSSize(width: newWidth, height: finalHeight)
        let oldHeight=window?.frame.height
        let changeInHeight=finalHeight-oldHeight!
        let changeInWidth=newWidth-oldWidth!
		guard let windowOrigin=window?.frame.origin else {
			return
		}
		var newOrigin=CGPoint(x: windowOrigin.x-changeInWidth, y: windowOrigin.y-changeInHeight)
		if ClockPreferencesStorage.sharedInstance.fullscreen {
			if let size=window?.frame.size {
				newSize=size
				newOrigin=CGPoint(x: 0, y: 0)
			}
		}
        let newRect=NSRect(origin: newOrigin, size: newSize)
        //window?.setFrame(newRect, display: true)
		print("window"+window!.frame.size.height.description)
    }
    func windowDidBecomeKey(_ notification: Notification) {
		flashButtons()
    }
    func windowDidResignKey(_ notification: Notification) {
        if !ClockPreferencesStorage.sharedInstance.fullscreen {
            showButtons(show: false)
        }
    }
    override func mouseMoved(with event: NSEvent) {
        flashButtons()
    }
    func windowDidEndLiveResize(_ notification: Notification) {
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else {
			return
		}
        //digitalClockVC.resizeClock()
    }
    func windowDidResize(_ notification: Notification) {
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else {
			return
		}
		if !ClockPreferencesStorage.sharedInstance.useAnalog {
		guard let windowWidth=window?.frame.width else {
			return
		}
			if !ClockPreferencesStorage.sharedInstance.useAnalog {
        digitalClockVC.resizeContents(maxWidth: windowWidth)
			}
		guard let windowIsZoomed=window?.isZoomed else {
			return
		}
        if !windowIsZoomed && ClockPreferencesStorage.sharedInstance.fullscreen==false {
			var multiplier: CGFloat=1
			var constant: CGFloat=0
			if ClockPreferencesStorage.sharedInstance.useAnalog {
				multiplier=analogHeightMultiplier
				constant=analogConstant
			} else {
				multiplier=digitalHeightMultiplier
			}
			let newWidth=digitalClockVC.clockStackView.fittingSize.width
			let newHeight=digitalClockVC.clockStackView.fittingSize.height
            let newAspectRatio=NSSize(width: newWidth, height: newHeight)
            window?.aspectRatio=newAspectRatio
            showButtons(show: false)
        } else {
            showButtons(show: true)
        }
		} else {
			window?.aspectRatio=digitalClockVC.analogClock.frame.size
		}
		print("window resize"+(window?.frame.size.height.description)!)
    }
    func windowWillClose(_ notification: Notification) {
		saveState()
		if !ClockPreferencesStorage.sharedInstance.useAnalog {
			enableClockMenu(enabled: false)
			let appObject = NSApp as NSApplication
			appObject.terminate(self)
		}
    }
    func windowWillEnterFullScreen(_ notification: Notification) {
        saveState()
        ClockPreferencesStorage.sharedInstance.fullscreen=true
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else {
			return
		}
		guard let windowSize=window?.screen?.frame.size else {
			return
		}
        digitalClockVC.resizeContents(maxWidth: windowSize.width)
		window?.aspectRatio=windowSize
    }
    func windowDidEnterFullScreen(_ notification: Notification) {
        removeTrackingArea()
        hideButtonsTimer?.invalidate()
        updateClockMenuUI()
        reloadPreferencesWindowIfOpen()
        window?.makeKey()
        showButtons(show: true)
		if let size=window?.screen?.frame.size {
		window?.setFrame(NSRect(origin: CGPoint(x: 0, y: 0), size: size), display: true)
		}
    }
    func windowWillExitFullScreen(_ notification: Notification) {
		ClockPreferencesStorage.sharedInstance.fullscreen=false
		let maxWidth=CGFloat(ClockWindowRestorer().getClockWidth())
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else {
			return
		}
		digitalClockVC.resizeContents(maxWidth: maxWidth)
		sizeWindowToFitClock(newWidth: maxWidth)
		digitalClockVC.applyFloatState()
    }
    func windowDidExitFullScreen(_ notification: Notification) {
        window?.makeKey()
		prepareWindowButtons()
        updateClockMenuUI()
        reloadPreferencesWindowIfOpen()
        window?.aspectRatio=(window?.frame.size)!
    }
    func windowWillUseStandardFrame(_ window: NSWindow,
                                    defaultFrame newFrame: NSRect) -> NSRect {
		//return newFrame
		guard let screenFrame=window.screen?.visibleFrame else {
			return newFrame
		}
		return screenFrame
    }
    func setMaxSize() {
		guard let screenSize=window?.screen else {
			return
		}
		window?.maxSize=screenSize.frame.size
    }
    func setMinSize() {
        window?.minSize=CGSize(width: 100, height: 1)
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
		if !ClockPreferencesStorage.sharedInstance.fullscreen {
            showButtons(show: false)
        }
    }
    func showButtons(show: Bool) {
	self.window?.standardWindowButton(.closeButton)?.isHidden=(!show)
	self.window?.standardWindowButton(.zoomButton)?.isHidden=(!show)
	self.window?.standardWindowButton(.miniaturizeButton)?.isHidden=(!show)
    }
    func saveState() {
        ClockWindowRestorer().windowSaveCGRect(window: window)
    }
    func removeTrackingArea() {
		guard let view=backgroundView else {
			return
		}
		guard let area=trackingArea else {
			return
		}
		view.removeTrackingArea(area)
    }
    func reloadPreferencesWindowIfOpen() {
        let appObject = NSApp as NSApplication
		guard let mainMenu=appObject.mainMenu as? MainMenu else {
			return
		}
		if isThereAPreferencesWindow() {
			mainMenu.reloadSimplePreferencesWindow()
		}
    }
	func windowWillMiniaturize(_ notification: Notification) {
		if let digitalClockVC=window?.contentViewController as? ClockViewController {
			digitalClockVC.displayForDock()
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
}
