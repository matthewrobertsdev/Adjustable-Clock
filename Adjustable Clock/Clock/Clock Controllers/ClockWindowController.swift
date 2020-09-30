//
//  DigitalClockWC.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class ClockWindowController: FullViewWindowController, NSWindowDelegate {
	static var clockObject=ClockWindowController()
	var fullscreen=false
    override func windowDidLoad() {
        super.windowDidLoad()
		WindowManager.sharedInstance.count+=1
		guard let clockViewController=window?.contentViewController as? ClockViewController else { return }
		window?.minSize=CGSize(width: 220, height: 150)
		if ClockPreferencesStorage.sharedInstance.hasLaunchedBefore() {
			ClockWindowRestorer().loadSavedWindowCGRect(window: window)
        }

		ClockPreferencesStorage.sharedInstance.setApplicationAsHasLaunched()
        clockViewController.updateClock()
		if let windowSize=window?.frame.size {
			window?.aspectRatio=windowSize
		}
        window?.delegate=self
		/*
		if ClockPreferencesStorage.sharedInstance.fullscreen==false {
			prepareWindowButtons()
		} else {
            showButtons(show: true)
        }
*/
        enableClockMenu(enabled: true)
        updateClockMenuUI()
    }
	func closeDigitalClock() {
		let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.digitalClockWindow { window.close() }
	}
	func getWindowRect(newWidth: CGFloat) -> NSRect {
		let safetyRect=NSRect(x: 0, y: 0, width: newWidth, height: newWidth)
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return safetyRect}
		var newHeight: CGFloat=100
		newHeight=newWidth/digitalClockVC.model.width*digitalClockVC.model.height
		var newSize=NSSize(width: newWidth, height: newHeight)
        let changeInHeight=newHeight-(window?.frame.height ?? 0)
        let changeInWidth=newWidth-(window?.frame.width ?? 0)
		guard let windowOrigin=window?.frame.origin else { return safetyRect}
		var newOrigin=CGPoint(x: windowOrigin.x-changeInWidth, y: windowOrigin.y-changeInHeight)
		if ClockPreferencesStorage.sharedInstance.fullscreen {
			if let size=window?.frame.size {
				newSize=size
				newOrigin=CGPoint(x: 0, y: 0)
			}
		}
        return NSRect(origin: newOrigin, size: newSize)
	}
	func getWindowRect(newHeight: CGFloat) -> NSRect {
		let safetyRect=NSRect(x: 0, y: 0, width: newHeight, height: newHeight)
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return safetyRect}
		var newHeightWithOutDock=newHeight
		if !ClockPreferencesStorage.sharedInstance.fullscreen {
			newHeightWithOutDock-=100
		}
		let newWidth=newHeightWithOutDock/digitalClockVC.model.height*digitalClockVC.model.width
		var newSize=NSSize(width: newWidth, height: newHeightWithOutDock)
        let changeInHeight=newHeightWithOutDock-(window?.frame.height ?? 0)
		guard let windowOrigin=window?.frame.origin else { return safetyRect}
		var newOrigin=CGPoint(x: windowOrigin.x, y: windowOrigin.y-changeInHeight)
		if ClockPreferencesStorage.sharedInstance.fullscreen {
			if let size=window?.frame.size {
				newSize=size
				newOrigin=CGPoint(x: 0, y: 0)
			}
		}
        return NSRect(origin: newOrigin, size: newSize)
	}
    func sizeWindowToFitClock(newWidth: CGFloat) {
        var newRect=getWindowRect(newWidth: newWidth)
		if let screen=window?.screen {
			if newWidth>screen.frame.width {
				newRect=getWindowRect(newWidth: screen.frame.width)
			}
			if newRect.height>screen.frame.height {
				newRect=getWindowRect(newHeight: screen.frame.height)
			}
		}
        window?.setFrame(newRect, display: true, animate: false)
    }
    func windowDidBecomeKey(_ notification: Notification) {
		/*
		if !fullscreen {
			flashButtons()
		}
*/
		enableClockMenu(enabled: true)
    }
    func windowDidResignKey(_ notification: Notification) {
		/*
        if ClockPreferencesStorage.sharedInstance.fullscreen==false {
            showButtons(show: false)
        }
*/
    }
    func windowDidResize(_ notification: Notification) {
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return }
		digitalClockVC.updateSizeConstraints()
        resizeContents()
		guard let windowIsZoomed=window?.isZoomed else { return }
        if windowIsZoomed==false && ClockPreferencesStorage.sharedInstance.fullscreen==false {
			let newAspectRatio=NSSize(width: digitalClockVC.model.width, height: digitalClockVC.model.height)
            window?.aspectRatio=newAspectRatio
            //showButtons(show: false)
        } else {
			if ClockPreferencesStorage.sharedInstance.useAnalog {
				//digitalClockVC.showAnalogClock()
			}
            //showButtons(show: true)
        }
    }
	func resizeContents() {
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return }
		guard let windowSize=window?.frame.size else { return }
		if digitalClockVC.view.frame.size.width/digitalClockVC.view.frame.size.height <
		digitalClockVC.model.width/digitalClockVC.model.height {
			digitalClockVC.activateWidthConstraints()
			digitalClockVC.resizeContents(maxWidth: windowSize.width)
		} else {
			digitalClockVC.activateHeightConstraints()
			digitalClockVC.resizeContents(maxHeight: windowSize.height)
		}
		if ClockPreferencesStorage.sharedInstance.useAnalog && ClockPreferencesStorage.sharedInstance.fullscreen {
			//digitalClockVC.animateAnalog()
		}
	}
    func windowWillClose(_ notification: Notification) {
		saveState()
		WindowManager.sharedInstance.count-=1
		enableClockMenu(enabled: false)
		if GeneralPreferencesStorage.sharedInstance.closing {
			ClockPreferencesStorage.sharedInstance.setWindowIsOpen()
		} else {
			ClockPreferencesStorage.sharedInstance.setWindowIsClosed()
		}
    }
    func windowWillEnterFullScreen(_ notification: Notification) {
        saveState()
        ClockPreferencesStorage.sharedInstance.fullscreen=true
		self.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.normalWindow)))
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
		fullscreen=true
        //removeTrackingArea()
		//hideButtonsTimer?.cancel()
        updateClockMenuUI()
		//digitalClockVC.showClock()
        //reloadPreferencesWindowIfOpen()
        //showButtons(show: true)
    }
    func windowWillExitFullScreen(_ notification: Notification) {
		ClockPreferencesStorage.sharedInstance.fullscreen=false
		let maxWidth=CGFloat(ClockWindowRestorer().getClockWidth())
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return }
		digitalClockVC.assignMinSize()
		digitalClockVC.resizeContents(maxWidth: maxWidth)
		digitalClockVC.clockHeightConstraint.constant=digitalClockVC.model.height
		sizeWindowToFitClock(newWidth: maxWidth)
		applyFloatState()
    }
    func windowDidExitFullScreen(_ notification: Notification) {
		fullscreen=false
        window?.makeKey()
		//prepareWindowButtons()
        updateClockMenuUI()
        //reloadPreferencesWindowIfOpen()
		guard let digitalClockVC=window?.contentViewController as? ClockViewController else { return }
		window?.aspectRatio=NSSize(width: digitalClockVC.model.width, height: digitalClockVC.model.height)
		//applyFloatState()
        digitalClockVC.showDigitalClock()
        digitalClockVC.showClock()
    }
    func windowWillUseStandardFrame(_ window: NSWindow,
                                    defaultFrame newFrame: NSRect) -> NSRect {
		guard let screenFrame=window.screen?.visibleFrame else { return newFrame }
		return screenFrame
    }
    func saveState() {
        ClockWindowRestorer().windowSaveCGRect(window: window)
    }
	func windowWillMiniaturize(_ notification: Notification) {
		if let digitalClockVC=window?.contentViewController as? ClockViewController {
			digitalClockVC.displayForDock()
		}
		WindowManager.sharedInstance.dockWindowArray.append(window ?? NSWindow())
		enableClockMenu(enabled: false)
	}
	func windowDidDeminiaturize(_ notification: Notification) {
		if let digitalClockVC=window?.contentViewController as? ClockViewController {
			digitalClockVC.backgroundView.draw(digitalClockVC.backgroundView.bounds)
			digitalClockVC.animateClock()
		}
		WindowManager.sharedInstance.dockWindowArray.removeAll { (dockWindow) -> Bool in
			return dockWindow==window
		}
		enableClockMenu(enabled: true)
	}
	func windowDidChangeScreen(_ notification: Notification) {
		guard let width=window?.frame.width else {
			return
		}
		sizeWindowToFitClock(newWidth: width)
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
	func clockWindowPresent() -> Bool {
		return isWindowPresent(identifier: UserInterfaceIdentifier.digitalClockWindow)
	}
	func showClock() {
		if clockWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let clockWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"ClockWindowController") as? ClockWindowController else { return }
		ClockWindowController.clockObject=clockWindowController
		ClockWindowController.clockObject.loadWindow()
			if let clockViewController=clockWindowController.contentViewController as? ClockViewController {
				clockViewController.showClock()
				ClockWindowController.clockObject.showWindow(nil)
			}
		} else {
			let appObject = NSApp as NSApplication
			for window in appObject.windows where window.identifier==UserInterfaceIdentifier.digitalClockWindow {
				if let clockWindowController=window.windowController as? ClockWindowController {
					ClockWindowController.clockObject=clockWindowController
					if let clockViewController=clockWindowController.contentViewController as? ClockViewController {
						clockViewController.showClock()
						window.makeKeyAndOrderFront(nil)
					}
				}
			}
		}
	}
	func enableClockMenu(enabled: Bool) {
		guard let appDelagte = NSApplication.shared.delegate as? AppDelegate else {
			return
		}
		appDelagte.clockMenuController?.enableMenu(enabled: enabled)
	}
}
