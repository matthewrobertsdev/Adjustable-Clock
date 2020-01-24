//
//  NewAlarmViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class NewAlarmViewController: NSViewController {
	var song: String?
	@IBOutlet weak var datePicker: NSDatePicker!
	@IBOutlet weak var songTextField: NSTextField!
	@IBOutlet weak var repeatsButton: NSButton!
	@IBOutlet weak var beepButton: NSButton!
	@IBOutlet weak var songButton: NSButton!
	@IBAction func chooseSong(_ sender: Any) {
	}
	@IBAction func setAlarm(_ sender: Any) {
		var repeating=false
		if repeatsButton.state==NSControl.StateValue.on {
			repeating=true
		}
		if songButton.state==NSControl.StateValue.on {
			if song==nil {
				let songAlert=NSAlert()
				songAlert.messageText="Please select a song before setting an alarm with a song for the alarm."
				songAlert.runModal()
				return
			}
		}
		AlarmCenter.sharedInstance.addAlarm(alarm: Alarm(date: datePicker.dateValue, usesSong: false, repeats: repeating, song: song, active: true))
		AlarmCenter.sharedInstance.startAlarms()
		AlarmsWindowController.alarmsObject.showAlarms()
	}
	@IBAction func useBeepChosen(_ sender: Any) {
		beepButton.state=NSControl.StateValue.on
		songButton.state=NSControl.StateValue.off
	}
	@IBAction func useSongChosen(_ sender: Any) {
		beepButton.state=NSControl.StateValue.off
		songButton.state=NSControl.StateValue.on
	}
	override func viewDidLoad() {
        super.viewDidLoad()
    }
}
