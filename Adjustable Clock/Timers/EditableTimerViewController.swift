//
//  EditableTimerViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/14/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
enum AlertStyle {
	case sound
	case song
	case noSound
}
class EditableTimerViewController: NSViewController {
	var index=0
	let calendar=Calendar.current
	@IBOutlet weak var timerDatePicker: NSDatePicker!
	@IBOutlet weak var playlistTextField: NSButton!
	@IBOutlet weak var beepButton: NSButton!
	@IBOutlet weak var songButton: NSButton!
	@IBOutlet weak var noSoundButton: NSButton!
	var alertStyle=AlertStyle.sound
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
		
		guard let timerViewController=TimersWindowController.timersObject.contentViewController as? TimersViewController else {
			return
		}
		TimersCenter.sharedInstance.setSeconds(index: index, time: timerDate)
		TimersCenter.sharedInstance.stopTimer(index: index)
		TimersCenter.sharedInstance.timers[index].active=true
		timerViewController.animateTimer(index: index)
		let timerCollectionViewItem=timerViewController.collectionView.item(at: index) as? TimerCollectionViewItem
		timerCollectionViewItem?.startPauseButton.title="Pause"
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
		noSoundButton.state=NSControl.StateValue.off
		songButton.state=NSControl.StateValue.off
		beepButton.state=NSControl.StateValue.on
		alertStyle=AlertStyle.sound
	}
	@IBAction func useSongChosen(_ sender: Any) {
		useSong()
	}
	func useSong() {
		beepButton.state=NSControl.StateValue.off
		noSoundButton.state=NSControl.StateValue.off
		songButton.state=NSControl.StateValue.on
		alertStyle=AlertStyle.song
	}
	@IBAction func useNoSoundChosen(_ sender: Any) {
		useNoSound()
	}
	func useNoSound() {
		beepButton.state=NSControl.StateValue.off
		songButton.state=NSControl.StateValue.off
		noSoundButton.state=NSControl.StateValue.on
		alertStyle=AlertStyle.noSound
	}
}
