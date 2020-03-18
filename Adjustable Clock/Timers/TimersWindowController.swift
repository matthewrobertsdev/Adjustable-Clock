//
//  TimersWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/4/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import AppKit

class TimersWindowController: FullViewWindowController, NSWindowDelegate {
	static var timersObject=TimersWindowController()
    override func windowDidLoad() {
        super.windowDidLoad()
		WindowManager.sharedInstance.count+=1
		window?.delegate=self
		window?.minSize=NSSize(width: 450, height: 224)
		if TimersPreferenceStorage.sharedInstance.haslaunchedBefore() {
			TimersWindowRestorer().loadSavedWindowCGRect(window: window)
		}
		prepareWindowButtons()
    }
	func showTimers() {
		if isTimersWindowPresent() == false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let timersWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"TimersWindowController") as? TimersWindowController else { return }
			TimersWindowController.timersObject=timersWindowController
			TimersWindowController.timersObject.loadWindow()
			TimersWindowController.timersObject.showWindow(nil)
		} else {
			let appObject = NSApp as NSApplication
			for window in appObject.windows where window.identifier==UserInterfaceIdentifier.timersWindow {
				if let timersWindowController=window.windowController as? TimersWindowController {
					TimersWindowController.timersObject=timersWindowController
						window.makeKeyAndOrderFront(nil)
					}
				}
			}
	}
	func update() {
        let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.timersWindow {
			if let timersViewController=window.contentViewController as? TimersViewController {
					timersViewController.update()
            }
        }
    }
	func windowWillClose(_ notification: Notification) {
		WindowManager.sharedInstance.count-=1
		saveState()
		if GeneralPreferencesStorage.sharedInstance.closing {
			TimersPreferenceStorage.sharedInstance.setWindowIsOpen()
		} else {
			TimersPreferenceStorage.sharedInstance.setWindowIsClosed()
		}
    }
	func saveState() {
		TimersCenter.sharedInstance.saveTimers()
		TimersWindowRestorer().windowSaveCGRect(window: window)
		TimersPreferenceStorage.sharedInstance.setHasLaunched()
    }
	func isTimersWindowPresent() -> Bool {
		return isWindowPresent(identifier: UserInterfaceIdentifier.timersWindow)
	}
	func windowDidEnterFullScreen(_ notification: Notification) {
        removeTrackingArea()
		hideButtonsTimer?.cancel()
        showButtons(show: true)
    }
	func windowDidExitFullScreen(_ notification: Notification) {
        window?.makeKey()
		prepareWindowButtons()
    }
	func windowWillMiniaturize(_ notification: Notification) {
		guard let timerViewController=window?.contentViewController as? TimersViewController else {
			return
		}
		timerViewController.displayForDock()
		WindowManager.sharedInstance.dockWindowArray.append(window ?? NSWindow())
	}
	func windowDidDeminiaturize(_ notification: Notification) {
		guard let timerViewController=window?.contentViewController as? TimersViewController else {
			return
		}
		timerViewController.displayNormally()
		WindowManager.sharedInstance.dockWindowArray.removeAll { (dockWindow) -> Bool in
			return dockWindow==window
		}
	}
	func windowDidBecomeKey(_ notification: Notification) {
		flashButtons()
    }
}
