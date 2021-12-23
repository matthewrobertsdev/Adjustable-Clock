//
//  StopwatchViewController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/19/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Cocoa

class StopwatchViewController: ColorfulViewController, NSTableViewDataSource {
	@IBOutlet weak var stopwatchLabel: NSTextField!
	@IBOutlet weak var startStopButton: NSButton!
	@IBOutlet weak var resetLapButton: NSButton!
	@IBOutlet weak var lapTableView: NSTableView!
	override func viewDidLoad() {
        super.viewDidLoad()
		update()
    }
	func update() {
		applyColorScheme(views: [ColorView](), labels: [stopwatchLabel])
	}
	@IBAction func startStopStopwatch(_ sender: Any) {
		if StopwatchCenter.sharedInstance.active {
			StopwatchCenter.sharedInstance.stopStopwatch()
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
}
