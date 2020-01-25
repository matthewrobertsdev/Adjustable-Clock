//
//  NewAlarmViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Cocoa
class NewAlarmViewController: NSViewController {
	var song: String?
	@IBOutlet weak var verticalStackView: NSStackView!
	@IBOutlet weak var deleteButton: NSButton!
	@IBOutlet weak var alertTextField: NSTextField!
	@IBOutlet weak var datePicker: NSDatePicker!
	@IBOutlet weak var songTextField: NSTextField!
	@IBOutlet weak var repeatsButton: NSButton!
	@IBOutlet weak var beepButton: NSButton!
	@IBOutlet weak var songButton: NSButton!
	var alertString="Ping"
	var new=true
	var cancel = { () -> Void in }
	@IBAction func chooseAlert(_ sender: Any) {
	let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let chooseAlertViewController =
 mainStoryBoard.instantiateController(withIdentifier:
			"ChooseAlertViewController") as? ChooseAlertViewController else { return }
		chooseAlertViewController.chooseAlertAction={ (alert: String) -> Void in
			self.alertString=alert
			self.alertTextField.stringValue="Alert: "+alert
		}
		self.presentAsSheet(chooseAlertViewController)
	}
	@IBAction func chooseSong(_ sender: Any) {
	}
	@IBAction func cancel(_ sender: Any) {
		self.view.window?.close()
		if new {	self.view.window?.close()
		} else {
			cancel()
		}
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
		if new {
			AlarmCenter.sharedInstance.addAlarm(alarm: Alarm(date: datePicker.dateValue, usesSong: false, repeats: repeating, alert: alertString, song: song, active: true))
			AlarmCenter.sharedInstance.startAlarms()
			self.view.window?.close()
		} else {
			cancel()
		}
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
		if new {
			verticalStackView.removeView(deleteButton)
			/*let oldFrame=self.view.window?.frame
			let newSize=NSSize(width: oldFrame?.size.width ?? 100, height: (oldFrame?.size.height ?? 142)-CGFloat(42))
			let newOrigin=CGPoint(x: oldFrame?.origin.x ?? 0, y: (oldFrame?.origin.y ?? 0)+CGFloat(42))
			let newFrame=CGRect(origin: newOrigin, size: newSize)
			view.window?.setFrame(newFrame, display: true)*/
		}
    }
}
