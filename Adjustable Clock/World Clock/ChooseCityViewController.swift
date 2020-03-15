//
//  ChooseCityViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/19/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class ChooseCityViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	@IBOutlet weak var tableView: NSTableView!
	let timeZoneStrings=TimeZone.knownTimeZoneIdentifiers//Array(TimeZone.abbreviationDictionary.keys)
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource=self
		tableView.delegate=self
    }
	func numberOfRows(in tableView: NSTableView) -> Int {
		return timeZoneStrings.count
	}
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		print("abcd"+timeZoneStrings[row])
		guard let cell0 = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GenericTableCellView"), owner: nil) as? GenericTableCellView else {
					return NSTableCellView()
			}
		cell0.genericTextField?.stringValue=timeZoneStrings[row]
	   return cell0
	 }
}
