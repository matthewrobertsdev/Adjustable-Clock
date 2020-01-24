//
//  ChooseAlertViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/24/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class ChooseAlertViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	var chooseAlertAction: (()->Void)?
	let soundNames=AlertSoundModel().soundsNames
	var loaded=false
	@IBOutlet weak var tableView: NSTableView!
	@IBAction func chooseAlertButton(_ sender: Any) {
		self.dismiss(self)
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource=self
		tableView.delegate=self
		tableView.reloadData()
		tableView.selectRowIndexes(IndexSet([0]), byExtendingSelection: false)
		loaded=true
    }
	func numberOfRows(in tableView: NSTableView) -> Int {
		return soundNames.count
	}
	 func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let cell0 = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GenericTableCellView"), owner: nil) as? GenericTableCellView else {
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
