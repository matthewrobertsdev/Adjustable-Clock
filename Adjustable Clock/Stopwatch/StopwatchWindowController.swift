//
//  StopwatchWindowController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/20/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Cocoa

class StopwatchWindowController: FullViewWindowController, NSWindowDelegate {
	static var stopwatchObject=StopwatchWindowController()
	var fullscreen=false
    override func windowDidLoad() {
        super.windowDidLoad()
		WindowManager.sharedInstance.count+=1
		StopwatchWindowController.stopwatchObject=StopwatchWindowController()
		window?.delegate=self
		window?.minSize=CGSize(width: 363, height: 290)
		if StopwatchPreferencesStorage.sharedInstance.hasLaunchedBefore() {
			StopwatchWindowFrameRestorer().loadSavedWindowCGRect(window: window)
		}
    }
	func windowWillClose(_ notification: Notification) {
		WindowManager.sharedInstance.count-=1
		saveState()
		StopwatchPreferencesStorage.sharedInstance.setStopwatchAsHasLaunched()
		if GeneralPreferencesStorage.sharedInstance.closing {
			StopwatchPreferencesStorage.sharedInstance.setWindowIsOpen()
		} else {
			StopwatchPreferencesStorage.sharedInstance.setWindowIsClosed()
		}
	}
	func saveState() {
		StopwatchWindowFrameRestorer().windowSaveCGRect(window: window)
	}
	func showStopwatch() {
		if stopwatchWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let stopwatchWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"StopwatchWindowController") as? StopwatchWindowController else { return }
			StopwatchWindowController.stopwatchObject=stopwatchWindowController
			StopwatchWindowController.stopwatchObject.loadWindow()
			StopwatchWindowController.stopwatchObject.showWindow(nil)
		} else {
			let appObject = NSApp as NSApplication
			for window in appObject.windows where window.identifier==UserInterfaceIdentifier.stopwatchWindow {
				if let stopwatchWindowController=window.windowController as? StopwatchWindowController {
					StopwatchWindowController.stopwatchObject=stopwatchWindowController
						window.makeKeyAndOrderFront(nil)
					}
				}
			}
	}
	func stopwatchWindowPresent() -> Bool {
		return isWindowPresent(identifier: UserInterfaceIdentifier.stopwatchWindow)
	}
	func updateForPreferencesChange() {
		let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.stopwatchWindow {
			if let stopwatchViewController=window.contentViewController as? StopwatchViewController {
					stopwatchViewController.update()
			}
		}
	}
}
