//
//  AnalogClockWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/27/19.
//  Copyright © 2019 Celeritas Apps. All rights reserved.
//
import Cocoa
class AnalogClockWindowController: NSWindowController, NSWindowDelegate {
	static var clockObject=AnalogClockWindowController()
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.delegate=self
		if ClockPreferencesStorage.sharedInstance.hasLaunchedBefore() {
			ClockWindowRestorer().loadSavedWindowCGRect(window: window)
        }
    }
	func showAnalogClock() {
		if !analogClockWindowPresent() {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let analogClockWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"AnalogClockWindowController") as? AnalogClockWindowController else {
				return
			}
		AnalogClockWindowController.clockObject=analogClockWindowController
		AnalogClockWindowController.clockObject.loadWindow()
		AnalogClockWindowController.clockObject.showWindow(nil)
		} else {
			let appObject = NSApp as NSApplication
			for window in appObject.windows where window.identifier==UserInterfaceIdentifier.analogClockWindow {
				window.makeKeyAndOrderFront(nil)
			}
		}
	}
	func windowWillClose(_ notification: Notification) {
		saveState()
		if ClockPreferencesStorage.sharedInstance.useAnalog {
			enableClockMenu(enabled: false)
			let appObject = NSApp as NSApplication
			appObject.terminate(self)
		}
    }
	func analogClockWindowPresent() -> Bool {
		return windowPresent(identifier: UserInterfaceIdentifier.analogClockWindow)
	}
	func closeAnalogClock() {
		let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.analogClockWindow {
			window.close()
		}
	}
	func saveState() {
        ClockWindowRestorer().windowSaveCGRect(window: window)
    }
}
