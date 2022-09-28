//
//  StopwatchViewController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/19/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Cocoa

class StopwatchViewController: ColorfulViewController, NSTableViewDataSource, NSTableViewDelegate, NSOpenSavePanelDelegate {
	@IBOutlet weak var stopwatchLabel: NSTextField!
	@IBOutlet weak var startStopButton: NSButton!
	@IBOutlet weak var resetLapButton: NSButton!
	@IBOutlet weak var lapTableView: NSTableView!
	@IBOutlet weak var stopwatchLabelWidthConstraint: NSLayoutConstraint!
	private let lapFormatter=DateFormatter()
	private let dateFormatter=DateFormatter()
	private let workspaceNotifcationCenter=NSWorkspace.shared.notificationCenter
	private let notificationCenter=NotificationCenter.default
	override func viewDidLoad() {
        super.viewDidLoad()
		lapFormatter.setLocalizedDateFormatFromTemplate("mm:ss")
		lapFormatter.locale=Locale(identifier: "en_US")
		dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd/yyyy")
		dateFormatter.locale=Locale(identifier: "en_US")
		lapTableView.usesAlternatingRowBackgroundColors=true
		lapTableView.dataSource=self
		lapTableView.delegate=self
		stopwatchLabel.stringValue=StopwatchCenter.sharedInstance.getStopwatchDisplayString()
		lapTableView.reloadData()
		update()
		workspaceNotifcationCenter.addObserver(self, selector: #selector(stop),
											   name: NSWorkspace.screensDidSleepNotification, object: nil)
    }
	func update() {
		applyColorScheme(views: [ColorView](), labels: [stopwatchLabel])
		if let stopwatchWindowwController=view.window?.windowController as? StopwatchWindowController {
			stopwatchWindowwController.applyFloatState()
		}
		updatePrecision()
		if StopwatchCenter.sharedInstance.active {
			setButtonTitle(button: startStopButton, title: "Stop")
			setButtonTitle(button: resetLapButton, title: "Lap")
		} else {
			setButtonTitle(button: startStopButton, title: "Start")
			setButtonTitle(button: resetLapButton, title: "Reset")
		}
	}
	@IBAction func startStopStopwatch(_ sender: Any) {
		if StopwatchCenter.sharedInstance.active {
			stopStopwatch()
		} else {
			StopwatchCenter.sharedInstance.startStopwatch()
			animateStopwatch()
			startStopButton.title="Stop"
			setButtonTitle(button: startStopButton, title: "Stop")
			resetLapButton.title="Lap"
			setButtonTitle(button: resetLapButton, title: "Lap")
		}
		notificationCenter.post(name: .activeCountChanged, object: nil)
	}
	private func stopStopwatch() {
		StopwatchCenter.sharedInstance.lapStopwatch()
		StopwatchCenter.sharedInstance.stopStopwatch()
		lapTableView.reloadData()
		startStopButton.title="Start"
		setButtonTitle(button: startStopButton, title: "Start")
		resetLapButton.title="Reset"
		setButtonTitle(button: resetLapButton, title: "Reset")
	}
	@IBAction func resetLapStopwatch(_ sender: Any) {
		if StopwatchCenter.sharedInstance.active {
			StopwatchCenter.sharedInstance.lapStopwatch()
		} else {
			StopwatchCenter.sharedInstance.resetStopwatch()
			stopwatchLabel.stringValue=StopwatchCenter.sharedInstance.getStopwatchDisplayString()
		}
		lapTableView.reloadData()
	}
	private func animateStopwatch() {
		StopwatchCenter.sharedInstance.gcdTimer.schedule(deadline: .now()
														 +
														 1/StopwatchCenter.sharedInstance.precisionDivisor, repeating: .milliseconds(1000/Int(StopwatchCenter.sharedInstance.precisionDivisor)),
															  leeway: .milliseconds(0))
		StopwatchCenter.sharedInstance.gcdTimer.setEventHandler { [weak self] in
			guard let strongSelf=self else {
				return
			}
			StopwatchCenter.sharedInstance.updateStopwatch()
			let displayString=StopwatchCenter.sharedInstance.getStopwatchDisplayString()
			strongSelf.stopwatchLabel.stringValue=displayString
		}
		StopwatchCenter.sharedInstance.gcdTimer.resume()
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return StopwatchCenter.sharedInstance.laps.count
	}
	func displayForDock() {
		stopwatchLabel.stringValue=""
	}
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let lap=StopwatchCenter.sharedInstance.laps[row]
		guard let tableCellView = tableView.makeView(withIdentifier: tableColumn!.identifier,
																   owner: self) as? NSTableCellView else {
			return NSTableCellView()
		}
		if tableColumn?.identifier==NSUserInterfaceItemIdentifier("LapNumberColumn") {
			tableCellView.textField?.stringValue=lap.lapNumber.description
		} else if tableColumn?.identifier==NSUserInterfaceItemIdentifier("TimeColumn") {
			let hundrethsString=String(format: "%.1f", (lap.timeInterval.truncatingRemainder(dividingBy: TimeInterval(10))))
			var timeString=lapFormatter.string(from: Date(timeIntervalSince1970: lap.timeInterval))
			if lap.useSecondsPrecision==false {
				let firstIndex = hundrethsString.index(hundrethsString.startIndex, offsetBy: 1)
				timeString+=String(hundrethsString.suffix(from: firstIndex))
			}
			tableCellView.textField?.stringValue=timeString
		} else if tableColumn?.identifier==NSUserInterfaceItemIdentifier("NotesColumn") {
			tableCellView.textField?.stringValue=lap.notes
		}
		if row==StopwatchCenter.sharedInstance.leastIndex {
			tableCellView.textField?.textColor=NSColor.systemGreen
		} else if row==StopwatchCenter.sharedInstance.greatestIndex {
			tableCellView.textField?.textColor=NSColor.systemRed
		} else {
			tableCellView.textField?.textColor=NSColor.labelColor
		}
		return tableCellView
	}
	@objc func stop() {
		if StopwatchCenter.sharedInstance.active {
			stopStopwatch()
			notificationCenter.post(name: .activeCountChanged, object: nil)
		}
	}
	func updatePrecision() {
		if StopwatchPreferencesStorage.sharedInstance.useSecondsPrecision {
			useSeconds()
		} else {
			useTenthsOfSeconds()
		}
	}
	private func useSeconds() {
		stopwatchLabelWidthConstraint.constant=200
		StopwatchCenter.sharedInstance.useSeconds()
		if StopwatchCenter.sharedInstance.active {
			stopwatchLabel.stringValue=StopwatchCenter.sharedInstance.getStopwatchDisplayString()
			StopwatchCenter.sharedInstance.stopStopwatch()
			StopwatchCenter.sharedInstance.active=true
			animateStopwatch()
		} else {
			stopwatchLabel.stringValue=StopwatchCenter.sharedInstance.getStopwatchFreezeString()
		}
	}
	private func useTenthsOfSeconds() {
		stopwatchLabelWidthConstraint.constant=253
		StopwatchCenter.sharedInstance.useTenthsOfSeconds()
		if StopwatchCenter.sharedInstance.active {
			stopwatchLabel.stringValue=StopwatchCenter.sharedInstance.getStopwatchDisplayString()
			StopwatchCenter.sharedInstance.stopStopwatch()
			StopwatchCenter.sharedInstance.active=true
			animateStopwatch()
		} else {
			stopwatchLabel.stringValue=StopwatchCenter.sharedInstance.getStopwatchFreezeString()
		}
	}
	func exportLapsToCsvFile() {
		var csvString="Lap Number, Lap Time, Notes\n"
		for lap in StopwatchCenter.sharedInstance.laps.reversed() {
			csvString+=lap.lapNumber.description+","
			let hundrethsString=String(format: "%.1f", (lap.timeInterval.truncatingRemainder(dividingBy: TimeInterval(10))))
			var timeString=lapFormatter.string(from: Date(timeIntervalSince1970: lap.timeInterval))
			if lap.useSecondsPrecision==false {
				let firstIndex = hundrethsString.index(hundrethsString.startIndex, offsetBy: 1)
				timeString+=String(hundrethsString.suffix(from: firstIndex))
			}
			csvString+=timeString+","
			csvString+=lap.notes+"\n"
		}
		let savePanel=NSSavePanel()
		savePanel.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		savePanel.delegate=self
		savePanel.nameFieldStringValue="Lap Data "+dateFormatter.string(from: Date())+".csv"
		if let window=self.view.window {
			savePanel.beginSheetModal(for: window) { response in
				if response == NSApplication.ModalResponse.OK {
					let fileUrl=savePanel.url
					do {
						if let fileUrl=fileUrl {
							try csvString.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
						}
					} catch {
						print("Couldn't save laps csv file.")
					}
				}
			}
		}
	}
	@IBAction func editNote(_ sender: NSTextField) {
		let selectedRowNumber = lapTableView.selectedRow
		if selectedRowNumber != -1 {
			StopwatchCenter.sharedInstance.laps[selectedRowNumber].notes = sender.stringValue
		}
	}
}
