//
//  PlaylistViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 3/17/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa
class PlaylistViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	var songURLs=[String]()
	var songs=[String]()
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource=self
		tableView.delegate=self
		tableView.usesAlternatingRowBackgroundColors=true
		getSongs()
		tableView.reloadData()
	}
	override func viewDidAppear() {
		super.viewDidAppear()
		self.view.window?.title = "Clock Suite Playlist"
	}
	func getSongs() {
		var saveURL=FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
		saveURL=saveURL?.appendingPathComponent("Clock Suite")
		guard let validSaveURL=saveURL else {
			return
		}
		do {
			try FileManager.default.createDirectory(at: validSaveURL, withIntermediateDirectories: true)
			var files = try FileManager.default.contentsOfDirectory(atPath: validSaveURL.path)
			files=files.filter({ (string) -> Bool in
				return string.hasSuffix(".mp3")||string.hasSuffix(".mp4")||string.hasSuffix(".m4a")||string.hasSuffix(".wav")
			})
			songs=files
		} catch {
			print("Error with Clock Suite application support directory")
		}
	}
	@IBOutlet weak var tableView: NSTableView!
	@IBAction func addSong(_ sender: Any) {
		let openPanel=NSOpenPanel()
		openPanel.canChooseFiles=true
		openPanel.canChooseDirectories=false
		openPanel.canCreateDirectories=false
		openPanel.allowedFileTypes=["mp3", "mp4", "m4a", "wav"]
		openPanel.allowsMultipleSelection=false
		openPanel.title="Choose Song or Sound"
		openPanel.message="Choose song or sound file."
		openPanel.prompt="Choose"
		openPanel.beginSheetModal(for: self.view.window ?? NSWindow(), completionHandler: { (result) -> Void in
			if result == NSApplication.ModalResponse.OK {
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
					self.getSongs()
					self.tableView.reloadData()
				} catch {
					print("error copying file to applicatiohn support Clock Suite folder")
				}
			} catch {
				print("error creating applicatiohn support Clock Suite folder")
			}
			}
		})
	}
	@IBAction func deleteSong(_ sender: Any) {
		if tableView.selectedRow == -1 {
			let alert=NSAlert()
			alert.messageText="No song selected to delete."
			alert.runModal()
		} else {
			let filename=songs[tableView.selectedRow]
			var fileURL=FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
			fileURL=fileURL?.appendingPathComponent("Clock Suite")
			guard var validFileURL=fileURL else {
				return
			}
			do {
				try FileManager.default.createDirectory(at: validFileURL, withIntermediateDirectories: true)
			validFileURL=validFileURL.appendingPathComponent(filename)
				try FileManager.default.removeItem(at: validFileURL)
				songs.remove(at: tableView.selectedRow)
			} catch {
				print("error trying to delete song")
			}
			tableView.reloadData()
		}
	}
	@IBAction func chooseSong(_ sender: Any) {
		if tableView.selectedRow == -1 {
			let alert=NSAlert()
			alert.messageText="Please select a song or choose cancel."
			alert.runModal()
		} else {
			choosePlaylistAction(songs[tableView.selectedRow])
			dismiss(nil)
		}
	}
	@IBAction func cancel(_ sender: Any) {
		dismiss(nil)
	}
	var choosePlaylistAction = { (_ : String) -> Void in }
	func numberOfRows(in tableView: NSTableView) -> Int {
		return songs.count
	}
	 func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let cell0 = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GenericTableCellView"), owner: nil) as? GenericTableCellView else {
				return NSTableCellView()
			}
		cell0.genericTextField?.stringValue=songs[row]
	   return cell0
	 }
	func tableViewSelectionDidChange(_ notification: Notification) {
	}
}
