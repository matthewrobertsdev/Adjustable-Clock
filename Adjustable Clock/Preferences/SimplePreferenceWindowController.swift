//
//  SimplePreferencesWC.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 8/4/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Cocoa
class SimplePreferenceWindowController: NSWindowController, NSWindowDelegate {
	static var prefrencesObject=SimplePreferenceWindowController()
	var open=false
    override func windowDidLoad() {
		open=true
        super.windowDidLoad()
        window?.maxSize=CGSize(width: window?.frame.width ?? CGFloat(100), height: window?.frame.height ?? CGFloat(100))
        window?.minSize=CGSize(width: window?.frame.width ?? CGFloat(100), height: window?.frame.height ?? CGFloat(100))
		WindowManager.sharedInstance.count+=1
		window?.delegate=self
    }
	func windowWillClose(_ notification: Notification) {
		WindowManager.sharedInstance.count-=1
		open=false
    }
	func showPreferences() {
		if isThereASimplePreferencesWindow() == false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let preferencesWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"SimplePreferenceWindowController") as? SimplePreferenceWindowController else { return }
			SimplePreferenceWindowController.prefrencesObject=preferencesWindowController
			SimplePreferenceWindowController.prefrencesObject.loadWindow()
			SimplePreferenceWindowController.prefrencesObject.showWindow(nil)
		} else {
			let appObject = NSApp as NSApplication
			for window in appObject.windows where window.identifier==UserInterfaceIdentifier.simplePrefrencesWindow {
				if let preferencesWindowController=window.windowController as? SimplePreferenceWindowController {
					SimplePreferenceWindowController.prefrencesObject=preferencesWindowController
						window.makeKeyAndOrderFront(nil)
					}
				}
			}
	}
}
