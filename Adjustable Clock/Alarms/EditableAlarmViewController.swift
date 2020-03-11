//
//  NewAlarmViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Cocoa
class EditableAlarmViewController: NSViewController {
	var song: String?
	@IBOutlet weak var verticalStackView: NSStackView!
	@IBOutlet weak var deleteButton: NSButton!
	@IBOutlet weak var alertTextField: NSTextField!
	@IBOutlet weak var datePicker: NSDatePicker!
	@IBOutlet weak var playlistTextField: NSTextField!
	@IBOutlet weak var repeatsButton: NSButton!
	@IBOutlet weak var beepButton: NSButton!
	@IBOutlet weak var songButton: NSButton!
	var settingsButton: NSButton?
	var collectionView: NSCollectionView?
	var usesSong=false
	var oldDate: Date?
	var delete = { () -> Void in }
	@IBAction func delete(_ sender: Any) {
		delete()
	}
	var alertName="Ping"
	var playlistName=""
	var new=true
	var cancel = { () -> Void in }
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
	@IBAction func choosePlaylist(_ sender: Any) {
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
			if playlistName=="" {
				let songAlert=NSAlert()
				songAlert.messageText="Please select a playlist before setting an alarm with a song for the alarm."
				songAlert.runModal()
				return
			}
		}
		let alarm=Alarm(time: datePicker.dateValue, usesSong: usesSong, repeats: repeating, alert: alertName, song: playlistName, active: true)
		if new {
			AlarmCenter.sharedInstance.addAlarm(alarm: alarm)
			self.view.window?.close()
		} else {
			AlarmCenter.sharedInstance.replaceAlarm(date: oldDate ?? Date(), alarm: alarm)
			if let button=settingsButton {
				if let alarmTableView=collectionView {
					alarmTableView.reloadData()
				}
			}
			cancel()
		}
		AlarmCenter.sharedInstance.setAlarms()
		AlarmsWindowController.alarmsObject.showAlarms()
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
	override func viewDidLoad() {
        super.viewDidLoad()
		if new {
			verticalStackView.removeView(deleteButton)
		}
    }
	func assignAlarm(alarm: Alarm) {
		oldDate=alarm.time
		datePicker.dateValue=alarm.time
		alertName=alarm.alertString
		alertTextField.stringValue="Alert: "+alarm.alertString
		playlistName=alarm.song=="" ? "none chosen": alarm.song
		playlistTextField.stringValue="Playlist: "+(alarm.song=="" ? "none chosen": alarm.song)
		alarm.usesSong ? useSong() : useBeep()
		if alarm.repeats {
			repeatsButton.state=NSControl.StateValue.on
		} else {
			repeatsButton.state=NSControl.StateValue.off
		}
	}
	func indexPathForView(cellItem: NSView, collectionView: NSCollectionView) -> IndexPath? {
		let point = cellItem.convert(cellItem.bounds.origin, to: collectionView)
		if let indexPath = collectionView.indexPathForItem(at: point){
			return indexPath
		}
		return nil

	}
}
