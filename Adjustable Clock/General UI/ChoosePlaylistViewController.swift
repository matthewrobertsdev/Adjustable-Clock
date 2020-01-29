//
//  ChooseSongViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/25/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
import iTunesLibrary
class ChoosePlaylistViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	@IBOutlet weak var tableView: NSTableView!
	@IBAction func choosePlaylist(_ sender: Any) {
		if tableView.selectedRow == -1 {
			let alert=NSAlert()
			alert.messageText="Please select a playlist or choose cancel."
			alert.runModal()
		} else {
			choosePlaylistAction(library.playlists[tableView.selectedRow].name)
			dismiss(nil)
		}
	}
	@IBAction func cancel(_ sender: Any) {
		dismiss(nil)
	}
	var library=TracksLibrary.sharedInstance
	var choosePlaylistAction={ (_ : String) -> Void in}
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource=self
		tableView.delegate=self
		do {
			try library.populateLibrary(completionHandler: { () -> Void in self.tableView.reloadData()})
		} catch {
			let alert=NSAlert()
			alert.alertStyle=NSAlert.Style.warning
			alert.messageText="Unable to access your Music library"
			alert.runModal()
		}
    }
	func numberOfRows(in tableView: NSTableView) -> Int {
		return library.playlists.count
	}
	 func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let cell0 = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GenericTableCellView"), owner: nil) as? GenericTableCellView else {
				return NSTableCellView()
			}
		cell0.genericTextField?.stringValue=library.playlists[row].name
	   return cell0
	 }
	func tableViewSelectionDidChange(_ notification: Notification) {
			
	}
}
