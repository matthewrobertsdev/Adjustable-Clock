//
//  NewAlarmViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class NewAlarmViewController: NSViewController {
	@IBOutlet weak var datePicker: NSDatePicker!
	@IBOutlet weak var songTextField: NSTextField!
	@IBOutlet weak var repeatsButton: NSButton!
	@IBAction func chooseSong(_ sender: Any) {
	}
	@IBAction func setAlarm(_ sender: Any) {
	}
	@IBAction func useBeepChosen(_ sender: Any) {
	}
	@IBAction func useSongChosen(_ sender: Any) {
	}
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
