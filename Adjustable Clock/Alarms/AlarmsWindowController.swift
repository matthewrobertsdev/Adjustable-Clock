//
//  AlarmsWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/21/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import Cocoa
class AlarmsWindowController: FullViewWindowController, NSWindowDelegate {
	static var alarmsObject=AlarmsWindowController()
    override func windowDidLoad() {
        super.windowDidLoad()
		window?.delegate=self
		AlarmsWindowController.alarmsObject=AlarmsWindowController()
		AlarmsPreferencesStorage.sharedInstance.setWindowIsClosed()
		window?.minSize=CGSize(width: 200, height: 400)
		window?.maxSize=CGSize(width: 200, height: 2000)
		AlarmsWindowRestorer().loadSavedWindowCGRect(window: window)
		self.window?.standardWindowButton(.zoomButton)?.isEnabled=false
		prepareWindowButtons()
    }
	func windowWillClose(_ notification: Notification) {
		saveState()
		if GeneralPreferencesStorage.sharedInstance.closing {
			AlarmsPreferencesStorage.sharedInstance.setWindowIsOpen()
		} else {
			AlarmsPreferencesStorage.sharedInstance.setWindowIsClosed()
		}
    }
	func saveState() {
		AlarmsWindowRestorer().windowSaveCGRect(window: window)
    }
	func showAlarms() {
		if alarmsWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let alarmsWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"AlarmsWindowController") as? AlarmsWindowController else { return }
			AlarmsWindowController.alarmsObject=alarmsWindowController
		AlarmsWindowController.alarmsObject.loadWindow()
			AlarmsWindowController.alarmsObject.showWindow(nil)
		} else {
			let appObject = NSApp as NSApplication
	for window in appObject.windows where window.identifier==UserInterfaceIdentifier.alarmsWindow {
				if let alarmsWindowController=window.windowController as? AlarmsWindowController {
					AlarmsWindowController.alarmsObject=alarmsWindowController
						window.makeKeyAndOrderFront(nil)
					}
				}
			}
	}
	func alarmsWindowPresent() -> Bool {
		return windowPresent(identifier: UserInterfaceIdentifier.alarmsWindow)
	}
	func updateForPreferencesChange() {
        let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.alarmsWindow {
			if let alarmsViewController=window.contentViewController as? AlarmsViewController {
					alarmsViewController.update()
            }
        }
    }
	deinit {
	}
}