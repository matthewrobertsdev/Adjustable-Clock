//
//  StopwatchViewController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/19/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Cocoa

class StopwatchViewController: ColorfulViewController, NSTableViewDataSource, NSTableViewDelegate {
	@IBOutlet weak var stopwatchLabel: NSTextField!
	@IBOutlet weak var startStopButton: NSButton!
	@IBOutlet weak var resetLapButton: NSButton!
	@IBOutlet weak var lapTableView: NSTableView!
	@IBOutlet weak var stopwatchLabelWidthConstraint: NSLayoutConstraint!
	private let lapFormatter=DateFormatter()
	private let workspaceNotifcationCenter=NSWorkspace.shared.notificationCenter
	override func viewDidLoad() {
        super.viewDidLoad()
		lapFormatter.setLocalizedDateFormatFromTemplate("mm:ss")
		lapFormatter.locale=Locale(identifier: "en_US")
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
	}
	@IBAction func startStopStopwatch(_ sender: Any) {
		if StopwatchCenter.sharedInstance.active {
			stopStopwatch()
		} else {
			StopwatchCenter.sharedInstance.startStopwatch()
			animateStopwatch()
			startStopButton.title="Stop"
			resetLapButton.title="Lap"
		}
	}
	private func stopStopwatch() {
		StopwatchCenter.sharedInstance.lapStopwatch()
		StopwatchCenter.sharedInstance.stopStopwatch()
		lapTableView.reloadData()
		startStopButton.title="Start"
		resetLapButton.title="Reset"
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
			if lap.useSecondsPrecision==false { timeString+=hundrethsString.substring(from: hundrethsString.index(hundrethsString.startIndex, offsetBy: 1))
			}
			tableCellView.textField?.stringValue=timeString
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
}
