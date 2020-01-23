//
//  AlarmsViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/20/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Cocoa
class AlarmsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate{
	var colorController: AlarmsColorController?
	@IBOutlet weak var visualEffectView: NSVisualEffectView!
	var backgroundView=DarkAndLightBackgroundView()
	@IBOutlet weak var tableView: NSTableView!
	@IBOutlet weak var titleTextField: NSTextField!
	override func viewDidLoad() {
        super.viewDidLoad()
       view.addSubview(backgroundView, positioned: .below, relativeTo: view)
		tableView.selectionHighlightStyle=NSTableView.SelectionHighlightStyle.none
		tableView.delegate=self
		tableView.dataSource=self
		backgroundView.translatesAutoresizingMaskIntoConstraints=false
		//*
		let leadingConstraint=NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		let trailingConstraint=NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		let topConstraint=NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let bottomConstraint=NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
		colorController=AlarmsColorController(visualEffectView: visualEffectView, view: backgroundView, titleTextField: titleTextField)
		colorController?.applyColorScheme()
    }
	func update() {
		colorController?.applyColorScheme()
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		print("Num rows")
		return AlarmStorage.storageObject.alarms.count
	 }
	  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		 let alarm = AlarmStorage.storageObject.alarms[row]
		var cell=NSTableCellView()
		if tableColumn == tableView.tableColumns[0] {
			cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AlarmTimeTableCellView"), owner: nil) as? AlarmTimeTableCellView) ?? NSTableCellView()
		} else if tableColumn == tableView.tableColumns[1] {
			cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AlarmStatusTableCellView"), owner: nil) as? AlarmStatusTableCellView) ?? NSTableCellView()
		} else if tableColumn == tableView.tableColumns[2] {
			cell = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AlarmSettingsTableCellView"), owner: nil) as? AlarmSettingsTableCellView) ?? NSTableCellView()
		}
		print("hello"+cell.description)
		return cell
	  }

}
