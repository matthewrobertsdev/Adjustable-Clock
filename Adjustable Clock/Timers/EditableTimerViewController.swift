//
//  EditableTimerViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/14/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class EditableTimerViewController: NSViewController {
	var index=0
	let calendar=Calendar.current
	@IBOutlet weak var timerDatePicker: NSDatePicker!
	@IBOutlet weak var playlistTextField: NSButton!
	@IBOutlet weak var beepButton: NSButton!
	@IBOutlet weak var songButton: NSButton!
	var usesSong=false
	var oldDate: Date?
	var alertName="Ping"
	var playlistName=""
	var closeAction = { () -> Void in }
	@IBOutlet weak var alertTextField: NSTextField!
	override func viewDidLoad() {
        super.viewDidLoad()
		timerDatePicker.locale=Locale(identifier: "de_AT")
    }
	@IBAction func cancel(_ sender: Any) {
		closeAction()
	}
	@IBAction func setTimer(_ sender: Any) {
		let timerDate=timerDatePicker.dateValue
		let hours=calendar.dateComponents([.hour], from: timerDate).hour ?? 0
		let minutes=calendar.dateComponents([.minute], from: timerDate).minute ?? 0
		let seconds=calendar.dateComponents([.second], from: timerDate).second ?? 0
		let totalSeconds=60*60*hours+60*minutes+seconds
		let timer=TimersCenter.sharedInstance.timers[index]
		timer.totalSeconds=totalSeconds
		timer.secondsRemaining=totalSeconds
		guard let timerViewController=TimersWindowController.timersObject.contentViewController as? TimersViewController else {
			return
		}
		if TimersCenter.sharedInstance.timers[index].active {
		TimersCenter.sharedInstance.timers[index].active=false
		TimersCenter.sharedInstance.gcdTimers[index].suspend()
		}
		timer.active=true
		timerViewController.animateTimer(index: index)
		closeAction()
	}
	@IBAction func chooseAlert(_ sender: Any) {
		   let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
			   guard let chooseAlertViewController =
		mainStoryBoard.instantiateController(withIdentifier:
				   "ChooseAlertViewController") as? ChooseAlertViewController else { return }
			   chooseAlertViewController.chooseAlertAction = { (alert: String) -> Void in
				   self.alertName=alert
				   self.alertTextField.stringValue="Alert: "+alert
			   }
			   self.presentAsSheet(chooseAlertViewController)
	}
	@IBAction func chooseSong(_ sender: Any) {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
				guard let chooseSongViewController = mainStoryBoard.instantiateController(withIdentifier:
				   "ChooseSongViewController") as? ChoosePlaylistViewController else { return }
		chooseSongViewController.choosePlaylistAction = { (playlist: String) -> Void in
			self.playlistName=playlist
			if playlist=="" {
				self.playlistTextField.stringValue="Playlist: None chosen"
			} else {
				self.playlistTextField.stringValue="Playlist: "+playlist
			}
		}
		self.presentAsSheet(chooseSongViewController)
	}
	@IBAction func useBeepChosen(_ sender: Any) {
		useBeep()
	}
	func useBeep() {
		beepButton.state=NSControl.StateValue.on
		songButton.state=NSControl.StateValue.off
		usesSong=false
	}
	@IBAction func useSongChosen(_ sender: Any) {
		useSong()
	}
	func useSong() {
		beepButton.state=NSControl.StateValue.off
		songButton.state=NSControl.StateValue.on
		usesSong=true
	}
}
