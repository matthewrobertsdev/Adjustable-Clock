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
	weak var alarmCollectionViewDelegate: AlarmCollectionItemProtocol?
	let timeFormatter=DateFormatter()
	@IBOutlet weak var verticalStackView: NSStackView!
	@IBOutlet weak var deleteButton: NSButton!
	@IBOutlet weak var datePicker: NSDatePicker!
	@IBOutlet weak var alertSoundPopUpButton: NSPopUpButton!
	@IBOutlet weak var playlistTextField: NSTextField!
	@IBOutlet weak var repeatsButton: NSButton!
	@IBOutlet weak var beepButton: NSButton!
	@IBOutlet weak var songButton: NSButton!
	var settingsButton: NSButton?
	var collectionView: NSCollectionView?
	var usesSong=false
	var oldDate: Date?
	var alertName="Ping"
	var playlistName=""
	var new=true
	var delete = { () -> Void in }
	var cancel = { () -> Void in }
	@IBAction func delete(_ sender: Any) {
		delete()
	}
	@IBAction func chooseAlert(_ sender: Any) {
		let alertTitle=alertSoundPopUpButton.selectedItem?.title
		self.alertName=alertTitle ?? "Ping"
		let sound=NSSound(named: alertTitle ?? "Ping")
		sound?.play()
		useBeep()
	}
	/*@IBAction func chooseAlert(_ sender: Any) {
	let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let chooseAlertViewController =
 mainStoryBoard.instantiateController(withIdentifier:
			"ChooseAlertViewController") as? AlertViewController else { return }
		chooseAlertViewController.chooseAlertAction = { (alert: String) -> Void in
			self.alertName=alert
			self.alertTextField.stringValue="Alert: "+alert
		}
		self.presentAsModalWindow(chooseAlertViewController)
	}*/
	@IBAction func chooseSong(_ sender: Any) {
	let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
				guard let chooseSongViewController = mainStoryBoard.instantiateController(withIdentifier:
				   "PlaylistViewController") as? PlaylistViewController else { return }
		chooseSongViewController.choosePlaylistAction = { [unowned self] (playlist: String) -> Void in
			self.playlistName=playlist
			if playlist=="" {
				self.playlistTextField.stringValue="Song: None chosen"
			} else {
				self.playlistTextField.stringValue="Song: "+playlist
				self.useSong()
			}
			self.playlistTextField.sizeToFit()
		}
		presentAsModalWindow(chooseSongViewController)
	}
	@IBAction func cancel(_ sender: Any) {
		view.window?.close()
		if new {
			view.window?.close()
		} else {
			cancel()
		}
	}
	@IBAction func setAlarm(_ sender: Any) {
		view.window?.makeFirstResponder(view.window)
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
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
		let timeString=timeFormatter.string(from: datePicker.dateValue)
		let alarm=Alarm(time: datePicker.dateValue,
						timeString: timeString, usesSong: usesSong, repeats: repeating,
						alert: alertName, song: playlistName, active: true)
		alarm.setExpirationDate(currentDate: Date())
		if new {
			AlarmsWindowController.alarmsObject.showAlarms()
			guard let alarmsViewController=AlarmsWindowController.alarmsObject.contentViewController
				as? AlarmsViewController else {
				return
			}
			guard let alarmTableView=alarmsViewController.collectionView else {
				return
			}
			AlarmCenter.sharedInstance.addAlarm(alarm: alarm)
			alarmTableView.animator().insertItems(at: [IndexPath(item: 0, section: 0)])
			self.view.window?.close()
		} else {
			AlarmCenter.sharedInstance.replaceAlarm(date: oldDate ?? Date(), alarm: alarm)
			let index=AlarmCenter.sharedInstance.getAlarmIndex(alarm: alarm)
			collectionView?.reloadItems(at: [IndexPath(item: index, section: 0)])
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
		alertSoundPopUpButton.addItems(withTitles: AlertSoundModel.soundsNames)
		if new {
			verticalStackView.removeView(deleteButton)
			alertSoundPopUpButton.selectItem(withTitle: "Ping")
			if ProcessInfo.processInfo.operatingSystemVersion.minorVersion != 14 && ProcessInfo.processInfo.operatingSystemVersion.minorVersion != 15 {
				alertSoundPopUpButton.selectItem(withTitle: "Glass")
				alertName="Glass"
			}
            let now = Date()
            let calendar = Calendar(identifier: .gregorian)
            let noon = calendar.nextDate(after: now, matching: DateComponents(calendar: calendar, timeZone: TimeZone.current, era: nil, year: nil, month: nil, day: nil, hour: 12, minute: 0, second:
																				0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: Calendar.MatchingPolicy.nextTime)
            datePicker.dateValue=noon ?? now
		}
    }
	func assignAlarm(alarm: Alarm) {
		oldDate=alarm.time
		datePicker.dateValue=alarm.time
		alertName=alarm.alertString
		playlistTextField.stringValue="Song: "+(alarm.song=="" ? "None chosen": alarm.song)
		alarm.usesSong ? useSong() : useBeep()
		if alarm.repeats {
			repeatsButton.state=NSControl.StateValue.on
		} else {
			repeatsButton.state=NSControl.StateValue.off
		}
		alertSoundPopUpButton.selectItem(withTitle: alertName)
	}
}
