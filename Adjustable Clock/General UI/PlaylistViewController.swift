//
//  PlaylistViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 3/17/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa
class PlaylistViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	@IBOutlet weak var tableView: NSTableView!
	@IBAction func chooseSong(_ sender: Any) {
		if tableView.selectedRow == -1 {
			let alert=NSAlert()
			alert.messageText="Please select a song or choose cancel."
			alert.runModal()
		} else {
			//code
			dismiss(nil)
		}
	}
	@IBAction func cancel(_ sender: Any) {
		dismiss(nil)
	}
	var choosePlaylistAction = { (_ : String) -> Void in }
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource=self
		tableView.delegate=self
    }
	func numberOfRows(in tableView: NSTableView) -> Int {
		return 0
	}
	 func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let cell0 = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GenericTableCellView"), owner: nil) as? GenericTableCellView else {
				return NSTableCellView()
			}
		cell0.genericTextField?.stringValue=""
	   return cell0
	 }
	func tableViewSelectionDidChange(_ notification: Notification) {
	}
}
