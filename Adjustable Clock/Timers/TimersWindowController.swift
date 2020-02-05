//
//  TimersWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/4/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class TimersWindowController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate {
	static var timersObject=TimersWindowController()
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
	func showTimers() {
		//if alarmsWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let timersWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"TimersWindowController") as? TimersWindowController else { return }
			TimersWindowController.timersObject=timersWindowController
			TimersWindowController.timersObject.loadWindow()
			TimersWindowController.timersObject.showWindow(nil)
		/*} else {
			let appObject = NSApp as NSApplication
			for window in appObject.windows where window.identifier==UserInterfaceIdentifier.timersWindow {
				if let timersWindowController=window.windowController as? TimersWindowController {
					TimersWindowController.timersObject=timersWindowController
						window.makeKeyAndOrderFront(nil)
					}
				}
			}*/
	}
}
