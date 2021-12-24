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
	override func viewDidLoad() {
        super.viewDidLoad()
		lapTableView.usesAlternatingRowBackgroundColors=true
		lapTableView.dataSource=self
		lapTableView.delegate=self
		update()
    }
	func update() {
		applyColorScheme(views: [ColorView](), labels: [stopwatchLabel])
	}
	@IBAction func startStopStopwatch(_ sender: Any) {
		if StopwatchCenter.sharedInstance.active {
			StopwatchCenter.sharedInstance.lapStopwatch()
			StopwatchCenter.sharedInstance.stopStopwatch()
			lapTableView.reloadData()
			startStopButton.title="Start"
			resetLapButton.title="Reset"
		} else {
			StopwatchCenter.sharedInstance.startStopwatch()
			animateStopwatch()
			startStopButton.title="Stop"
			resetLapButton.title="Lap"
		}
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
		StopwatchCenter.sharedInstance.gcdTimer.schedule(deadline: .now()+0.1, repeating: .milliseconds(100),
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
	/*
	func tableView(_ tableView: NSTableView,
			 objectValueFor tableColumn: NSTableColumn?,
				   row: Int) -> Any? {
		let lap=StopwatchCenter.sharedInstance.laps[row]
		guard let tableCellView = tableView.makeView(withIdentifier: tableColumn!.identifier,
																   owner: self) as? NSTableCellView else {
			return NSTableCellView()
		}
		if tableColumn?.identifier==NSUserInterfaceItemIdentifier("LapNumberColumn") {
			tableCellView.textField?.stringValue=lap.lapNumber.description
		} else if tableColumn?.identifier==NSUserInterfaceItemIdentifier("TimeColumn") {
			tableCellView.textField?.stringValue=lap.timeInterval.description
		}
		return tableCellView
	}
	 */
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let lap=StopwatchCenter.sharedInstance.laps[row]
		guard let tableCellView = tableView.makeView(withIdentifier: tableColumn!.identifier,
																   owner: self) as? NSTableCellView else {
			return NSTableCellView()
		}
		if tableColumn?.identifier==NSUserInterfaceItemIdentifier("LapNumberColumn") {
			tableCellView.textField?.stringValue=lap.lapNumber.description
		} else if tableColumn?.identifier==NSUserInterfaceItemIdentifier("TimeColumn") {
			tableCellView.textField?.stringValue=lap.timeInterval.description
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
}
