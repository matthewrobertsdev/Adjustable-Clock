//
//  ChooseAlertViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/24/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class AlertViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	var chooseAlertAction = {( _ : String) -> Void in }
	let soundNames=AlertSoundModel.soundsNames
	var loaded=false
	@IBOutlet weak var tableView: NSTableView!
	@IBAction func chooseAlertButton(_ sender: Any) {
		chooseAlertAction(soundNames[tableView.selectedRow])
		self.dismiss(self)
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource=self
		tableView.delegate=self
		tableView.usesAlternatingRowBackgroundColors=true
		tableView.reloadData()
		tableView.selectRowIndexes(IndexSet([0]), byExtendingSelection: false)
		loaded=true
    }
	override func viewDidAppear() {
		super.viewDidAppear()
		self.view.window?.title = "Choose Alert"
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return soundNames.count
	}
	 func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let cell0 = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GenericTableCellView"),
											 owner: nil) as? GenericTableCellView else {
				return NSTableCellView()
			}
		cell0.genericTextField?.stringValue=soundNames[row]
	   return cell0
	 }
	func tableViewSelectionDidChange(_ notification: Notification) {
		if loaded {
			let sound=NSSound(named: soundNames[tableView.selectedRow])
			sound?.play()
		}
	}
}
