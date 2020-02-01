//
//  OnboardingWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/1/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class OnboardingWindowController: NSWindowController {

	static var onboardingObject=OnboardingWindowController()
    override func windowDidLoad() {
        super.windowDidLoad()
    }
	func showOnboarding() {
		print("trying to onboard")
	let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
	guard let onboardingWindowController =
		mainStoryBoard.instantiateController(withIdentifier:
			"OnboardingWindowController") as? OnboardingWindowController else { return }
	onboardingWindowController.loadWindow()
		onboardingWindowController.showWindow(nil)
		print("should load window")
		window?.makeKeyAndOrderFront(nil)
	}
}
