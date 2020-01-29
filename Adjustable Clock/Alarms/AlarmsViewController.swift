//
//  AlarmsViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/20/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Cocoa
class AlarmsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	@objc var objectToObserve=AlarmCenter.sharedInstance
	var observation: NSKeyValueObservation?
	var colorController: AlarmsColorController?
	let timeFormatter=DateFormatter()
	let popover = NSPopover()
	@IBOutlet weak var visualEffectView: NSVisualEffectView!
	var backgroundView=DarkAndLightBackgroundView()
	@IBOutlet weak var tableView: NSTableView!
	@IBOutlet weak var titleTextField: NSTextField!
	@IBOutlet weak var alarmNotifierTextField: NSTextField!
	@IBAction func addAlarm(_ sender: Any) {
		EditableAlarmWindowController.newAlarmConfigurer.showNewAlarmConfigurer()
	}
	override func viewDidLoad() {
        super.viewDidLoad()
       view.addSubview(backgroundView, positioned: .below, relativeTo: view)
		popover.appearance=NSAppearance(named: NSAppearance.Name.vibrantDark)
		tableView.selectionHighlightStyle=NSTableView.SelectionHighlightStyle.none
		timeFormatter.locale=Locale(identifier: "en_US")
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
		tableView.delegate=self
		tableView.dataSource=self
		backgroundView.translatesAutoresizingMaskIntoConstraints=false
		//*
		let leadingConstraint=NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		let trailingConstraint=NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		let topConstraint=NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let bottomConstraint=NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
		colorController=AlarmsColorController(visualEffectView: visualEffectView, view: backgroundView, titleTextField: titleTextField, notifierTextField: alarmNotifierTextField, tableView: tableView)
		colorController?.applyColorScheme()
		observation = observe(
			\.objectToObserve.count,
            options: [.old, .new]
        ) { _, change in
			if change.newValue ?? 0>change.oldValue ?? 0 {
				self.tableView.insertRows(at: [0], withAnimation: NSTableView.AnimationOptions.slideDown)
			}
        }
    }
	func update() {
		colorController?.applyColorScheme()
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return AlarmCenter.sharedInstance.count
	 }
	  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let alarm = AlarmCenter.sharedInstance.getAlarm(index: row)
		if tableColumn == tableView.tableColumns[0] {
			guard let cell0 = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AlarmTimeTableCellView"), owner: nil) as? AlarmTimeTableCellView) else { return NSTableCellView() }
		cell0.alarmTimeTextField.textColor=colorController?.textColor
			cell0.alarmRepeatTextField.textColor=colorController?.textColor
			cell0.alarmTimeTextField.stringValue=timeFormatter.string(from: alarm.date)
			cell0.alarmRepeatTextField.stringValue = !alarm.active ? "Off" : (alarm.repeats ? "Everyday" : "Just once")
			return cell0
		} else if tableColumn == tableView.tableColumns[1] {
			guard let cell1 = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AlarmStatusTableCellView"), owner: nil) as? AlarmStatusTableCellView) else {
				return NSTableCellView() }
			cell1.alarmStatusSegmentedControl.setTag(0, forSegment: 0)
			cell1.alarmStatusSegmentedControl.setTag(1, forSegment: 1)
			if alarm.active {
			cell1.alarmStatusSegmentedControl.selectSegment(withTag: 1)
			} else {
				cell1.alarmStatusSegmentedControl.selectSegment(withTag: 0)
			}
			return cell1
		} else if tableColumn == tableView.tableColumns[2] {
			guard let cell2 = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AlarmSettingsTableCellView"), owner: nil) as? AlarmSettingsTableCellView) else {
				return NSTableCellView() }
			cell2.alarmSettingsButton.action=#selector(showPopover(sender:))
			return cell2
		}
		return NSTableCellView()
	  }
	@objc func showPopover(sender: Any?) {
		guard let settingsButton=sender as? NSButton else {
			return
		}
		if  popover.isShown {
			popover.close()
		} else {
			let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
			   guard let editableAlarmViewController =
				mainStoryBoard.instantiateController(withIdentifier:
				   "NewAlarmViewController") as? EditableAlarmViewController else { return }
			editableAlarmViewController.new=false
			guard let tableViewCell=settingsButton.superview as? NSTableCellView else { return }
		let index=self.tableView.row(for: tableViewCell)
			let alarm=AlarmCenter.sharedInstance.getAlarm(index: index)
			editableAlarmViewController.cancel = { () -> Void in self.popover.close() }
			editableAlarmViewController.delete = { () -> Void in
				AlarmCenter.sharedInstance.removeAlarm(index: index)
				self.tableView.removeRows(at: [index], withAnimation: NSTableView.AnimationOptions.slideUp)
			}
			popover.contentViewController = editableAlarmViewController
			popover.show(relativeTo: settingsButton.bounds, of: settingsButton, preferredEdge: NSRectEdge.minY)
			editableAlarmViewController.settingsButton=settingsButton
			editableAlarmViewController.tableView=tableView
			editableAlarmViewController.assignAlarm(alarm: alarm)
		}
	}
}
