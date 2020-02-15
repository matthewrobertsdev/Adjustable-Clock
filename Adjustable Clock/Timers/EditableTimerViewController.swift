//
//  EditableTimerViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/14/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class EditableTimerViewController: NSViewController {
	@IBOutlet weak var timerDatePicker: NSDatePicker!
	var cancel = { () -> Void in }
    override func viewDidLoad() {
        super.viewDidLoad()
		timerDatePicker.locale=Locale(identifier: "de_AT")
    }
	@IBAction func cancel(_ sender: Any) {
		cancel()
	}
	@IBAction func setTimer(_ sender: Any) {
	}
}
