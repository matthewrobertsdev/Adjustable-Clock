//
//  NewAlarmWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import Cocoa

class EditableAlarmWindowController: NSWindowController {
	static var newAlarmConfigurer=EditableAlarmWindowController()
    override func windowDidLoad() {
        super.windowDidLoad()
    }
	func showNewAlarmConfigurer() {
		if newAlarmWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let newAlarmWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"NewAlarmWindowController") as? EditableAlarmWindowController else { return }
			EditableAlarmWindowController.newAlarmConfigurer=newAlarmWindowController
		EditableAlarmWindowController.newAlarmConfigurer.loadWindow()
			EditableAlarmWindowController.newAlarmConfigurer.showWindow(nil)
		} else {
			let appObject = NSApp as NSApplication
	for window in appObject.windows where window.identifier==UserInterfaceIdentifier.newAlarmWindow {
				if let alarmsWindowController=window.windowController as? EditableAlarmWindowController {
					EditableAlarmWindowController.newAlarmConfigurer=alarmsWindowController
						window.makeKeyAndOrderFront(nil)
					}
				}
			}
	}
	func newAlarmWindowPresent() -> Bool {
		return isWindowPresent(identifier: UserInterfaceIdentifier.newAlarmWindow)
	}
}
