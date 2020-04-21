//
//  EditableTimerViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/14/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
enum AlertStyle: String, Codable {
	case sound
	case song
	case noSound
}
import Cocoa
class EditableTimerViewController: NSViewController {
	var index=0
	let calendar=Calendar.autoupdatingCurrent
	@IBOutlet weak var timerDatePicker: NSDatePicker!
	@IBOutlet weak var beepButton: NSButton!
	@IBOutlet weak var songButton: NSButton!
	@IBOutlet weak var noSoundButton: NSButton!
	@IBOutlet weak var playlistTextField: NSTextField!
	@IBOutlet weak var titleTextField: NSTextField!
	@IBOutlet weak var alertSoundPopUpButton: NSPopUpButton!
	var alertStyle=AlertStyle.sound
	var oldDate: Date?
	var alertName="Ping"
	var playlistName=""
	var closeAction = { () -> Void in }
	var startingDate: Date?
	override func viewDidLoad() {
        super.viewDidLoad()
		alertSoundPopUpButton.addItems(withTitles: AlertSoundModel.soundsNames)
		timerDatePicker.locale=Locale(identifier: "de_AT")
		startingDate=timerDatePicker.dateValue
		alertSoundPopUpButton.selectItem(withTitle: "Ping")
    }
	override func viewDidAppear() {
		view.window?.makeFirstResponder(view.window)
	}
	@IBAction func chooseAlert(_ sender: Any) {
		let alertTitle=alertSoundPopUpButton.selectedItem?.title
		self.alertName=alertTitle ?? "Ping"
		let sound=NSSound(named: alertTitle ?? "Ping")
		sound?.play()
	}
	@IBAction func cancel(_ sender: Any) {
		closeAction()
	}
	@IBAction func setTimer(_ sender: Any) {
		view.window?.makeFirstResponder(view.window)
		/*if timerDatePicker.dateValue==startingDate {
			let warningAlert=NSAlert()
			warningAlert.alertStyle = .warning
			warningAlert.messageText="Invalid Duration"
			warningAlert.informativeText="Duration must not be 0."
			warningAlert.runModal()
			return
		}*/
		TimersCenter.sharedInstance.stopTimer(index: index)
		let timerDate=timerDatePicker.dateValue
		guard let timerViewController=TimersWindowController.timersObject.contentViewController
			as? TimersViewController else {
			return
		}
		TimersCenter.sharedInstance.setSeconds(index: index, time: timerDate)
		let timer=TimersCenter.sharedInstance.timers[index]
		timer.alertStyle=alertStyle
		timer.alertString=alertName
		timer.song=playlistName
		timer.title=titleTextField.stringValue
		timer.reset=true
		TimersCenter.sharedInstance.timers[index].active=true
		timerViewController.animateTimer(index: index)
		let timerCollectionViewItem=timerViewController.collectionView.item(at: index) as? TimerCollectionViewItem
		timerCollectionViewItem?.startPauseButton.title="Pause"
		timerCollectionViewItem?.resetButton.title="Reset"
		closeAction()
	}
	/*
	@IBAction func chooseAlert(_ sender: Any) {
		   let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
			   guard let chooseAlertViewController =
		mainStoryBoard.instantiateController(withIdentifier:
				   "ChooseAlertViewController") as? AlertViewController else { return }
			   chooseAlertViewController.chooseAlertAction = { (alert: String) -> Void in
				   self.alertName=alert
				   self.alertTextField.stringValue="Alert: "+alert
				self.useBeep()
			   }
		self.presentAsModalWindow(chooseAlertViewController)
	}
*/
	@IBAction func chooseSong(_ sender: Any) {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
				guard let chooseSongViewController = mainStoryBoard.instantiateController(withIdentifier:
				   "PlaylistViewController") as? PlaylistViewController else { return }
		chooseSongViewController.choosePlaylistAction = { (playlistURL: String) -> Void in
			print("abcd"+playlistURL)
			self.playlistName=playlistURL
			if playlistURL=="" {
				self.playlistTextField.stringValue="Song: None chosen"
			} else {
				self.playlistTextField.stringValue="Song: "+playlistURL
				self.useSong()
			}
		}
		self.presentAsModalWindow(chooseSongViewController)
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
