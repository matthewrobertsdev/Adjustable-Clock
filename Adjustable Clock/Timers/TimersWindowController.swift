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
	func windowDidResize(_ notification: Notification) {
    }
	func windowDidEnterFullScreen(_ notification: Notification) {
	}
    func windowWillExitFullScreen(_ notification: Notification) {
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
		saveState()
		if GeneralPreferencesStorage.sharedInstance.closing {
			TimersPreferenceStorage.sharedInstance.setWindowIsOpen()
		} else {
			TimersPreferenceStorage.sharedInstance.setWindowIsClosed()
		}
    }
	func saveState() {
		TimersWindowRestorer().windowSaveCGRect(window: window)
		TimersPreferenceStorage.sharedInstance.setHasLaunched()
    }
	func isTimersWindowPresent() -> Bool {
		return isWindowPresent(identifier: UserInterfaceIdentifier.timersWindow)
	}
}
