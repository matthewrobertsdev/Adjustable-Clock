//
//  StopwatchViewController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/19/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Cocoa

class StopwatchViewController: ColorfulViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		applyColors()
        // Do view setup here.
    }
    
	func applyColors() {
		let labels=[NSTextField]()
		applyColorScheme(views: [ColorView](), labels: labels)
	}
}
