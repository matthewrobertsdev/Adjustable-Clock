//
//  TimersViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/4/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class TimersViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	@IBOutlet weak var tableView: NSTableView!
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource=self
		tableView.delegate=self
    }
	func numberOfRows(in tableView: NSTableView) -> Int {
	   return 3
	}
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
	  if tableColumn == tableView.tableColumns[0] {
		  guard let cell0 = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerTableCellView"), owner: nil) as? TimerTableCellView) else { return NSTableCellView() }
		  return cell0
	  } else if tableColumn == tableView.tableColumns[1] {
		  guard let cell1 = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerStatusTableCellView"), owner: nil) as? TimerStatusTableCellView) else {
			  return NSTableCellView() }
		  return cell1
		}
	  return NSTableCellView()
	}
}
