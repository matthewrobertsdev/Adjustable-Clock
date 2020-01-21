//
//  AlarmsWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/21/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa
class AlarmsWindowController: NSWindowController {
	static var alarmsObject=AlarmsWindowController()
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
	func showAlarms() {
		print("inside show alarms")
		if alarmsWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let alarmsWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"AlarmsWindowController") as? AlarmsWindowController else { return }
			print("should instantiate alarms")
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
}
