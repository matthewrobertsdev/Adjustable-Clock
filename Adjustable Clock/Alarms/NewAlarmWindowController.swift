//
//  NewAlarmWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import Cocoa

class NewAlarmWindowController: NSWindowController {
	static var newAlarmConfigurer=NewAlarmWindowController()
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
	func showNewAlarmConfigurer() {
		if newAlarmWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let newAlarmWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"NewAlarmWindowController") as? NewAlarmWindowController else { return }
			NewAlarmWindowController.newAlarmConfigurer=newAlarmWindowController
		NewAlarmWindowController.newAlarmConfigurer.loadWindow()
			NewAlarmWindowController.newAlarmConfigurer.showWindow(nil)
		} else {
			let appObject = NSApp as NSApplication
	for window in appObject.windows where window.identifier==UserInterfaceIdentifier.newAlarmWindow {
				if let alarmsWindowController=window.windowController as? NewAlarmWindowController {
					NewAlarmWindowController.newAlarmConfigurer=alarmsWindowController
						window.makeKeyAndOrderFront(nil)
					}
				}
			}
	}
	func newAlarmWindowPresent() -> Bool {
		return windowPresent(identifier: UserInterfaceIdentifier.newAlarmWindow)
	}
}
