//
//  OnboardingViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/1/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class OnboardingViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
	@IBAction func dismiss(_ sender: Any) {
		self.view.window?.close()
		ClockWindowController.clockObject.showClock()
	}
	@IBAction func okAction(_ sender: Any) {
		self.view.window?.close()
		let appleScript =
		"""
		tell application "Music"
			stop
		end tell
		"""
		var error: NSDictionary?
		if let scriptObject = NSAppleScript(source: appleScript) {
			if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
			print(outputString)
			} else if error != nil {
			print("Error: ", error ?? "")
			}
		}
		ClockWindowController.clockObject.showClock()
	}
}
