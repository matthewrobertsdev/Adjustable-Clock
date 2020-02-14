//
//  WorldClockWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/13/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class WorldClockWindowController: FullViewWindowController {
	static var worldClockObject=WorldClockWindowController()
    override func windowDidLoad() {
        super.windowDidLoad()
		prepareWindowButtons()
    }
	func showWorldClock() {
		if worldClockWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let worldClockWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"WorldClockWindowController") as? WorldClockWindowController else { return }
		WorldClockWindowController.worldClockObject=worldClockWindowController
		WorldClockWindowController.worldClockObject.loadWindow()
			WorldClockWindowController.worldClockObject.showWindow(nil)
		} else {
			let appObject = NSApp as NSApplication
			for window in appObject.windows where window.identifier==UserInterfaceIdentifier.worldClockWindow {
				if let worldClockWindowController=window.windowController as? WorldClockWindowController {
					WorldClockWindowController.worldClockObject=worldClockWindowController
						window.makeKeyAndOrderFront(nil)
					}
				}
		}
	}
	func worldClockWindowPresent() -> Bool {
		return isWindowPresent(identifier: UserInterfaceIdentifier.worldClockWindow)
	}
	func update(){
		guard let worldClockViewController=self.contentViewController as? WorldClockViewController else {
			return
		}
		worldClockViewController.update()
	}
}
