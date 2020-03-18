//
//  PlaylistViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 3/17/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa
class PlaylistViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSOpenSavePanelDelegate {
	var songURLs=[String]()
	@IBOutlet weak var tableView: NSTableView!
	@IBAction func addSong(_ sender: Any) {
		let openPanel=NSOpenPanel()
		openPanel.canChooseFiles=true
		openPanel.canChooseDirectories=false
		openPanel.canCreateDirectories=false
		openPanel.allowedFileTypes=["mp3"]
		openPanel.allowsMultipleSelection=false
		openPanel.begin { (result) -> Void in
			if result == NSApplication.ModalResponse.OK {
			}
			var saveURL=FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
			saveURL=saveURL?.appendingPathComponent("Clock Suite")
			guard var validSaveURL=saveURL else {
				return
			}
			do {
				try FileManager.default.createDirectory(at: validSaveURL, withIntermediateDirectories: true)
				guard let filename=openPanel.urls.first?.lastPathComponent else {
					return
				}
				validSaveURL=validSaveURL.appendingPathComponent(filename)
				guard let fileURL=openPanel.urls.first else {
					return
				}
				do {
					try FileManager.default.copyItem(atPath: fileURL.path, toPath: validSaveURL.path)
				} catch {
					print("error copying file to applicatiohn support Clock Suite folder")
				}
			} catch {
				print("error creating applicatiohn support Clock Suite folder")
			}

		}

		print("abcd+\(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first)")
	}
	@IBAction func deleteSong(_ sender: Any) {
	}
	
	@IBAction func chooseSong(_ sender: Any) {
		if tableView.selectedRow == -1 {
			let alert=NSAlert()
			alert.messageText="Please select a song or choose cancel."
			alert.runModal()
		} else {
			choosePlaylistAction(songURLs[tableView.selectedRow])
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
