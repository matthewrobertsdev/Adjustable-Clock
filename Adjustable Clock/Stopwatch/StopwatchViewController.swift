//
//  StopwatchViewController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/19/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Cocoa

class StopwatchViewController: ColorfulViewController {
	@IBOutlet weak var stopwatchLabel: NSTextField!
	override func viewDidLoad() {
        super.viewDidLoad()
		update()
        // Do view setup here.
    }
	func update() {
		applyColorScheme(views: [ColorView](), labels: [stopwatchLabel])
	}
}
