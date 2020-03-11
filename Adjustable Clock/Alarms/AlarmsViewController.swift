//
//  AlarmsViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/20/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Foundation
import Cocoa
class AlarmsViewController: ColorfulViewController, NSTableViewDataSource, NSTableViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegate {
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return AlarmCenter.sharedInstance.count
	}
	
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		guard let alarmCollectionViewItem=collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AlarmCollectionViewItem"), for: indexPath) as? AlarmCollectionViewItem else {
			return NSCollectionViewItem()
		}
		return alarmCollectionViewItem
	}
	
	@objc var objectToObserve=AlarmCenter.sharedInstance
	var observation: NSKeyValueObservation?
	var observation2: NSKeyValueObservation?
	let timeFormatter=DateFormatter()
	let popover = NSPopover()
	//@IBOutlet weak var tableView: NSTableView!
	
	@IBOutlet weak var collectionView: NSCollectionView!
	@IBOutlet weak var titleTextField: NSTextField!
	@IBOutlet weak var alarmNotifierTextField: NSTextField!
	@IBAction func addAlarm(_ sender: Any) {
		EditableAlarmWindowController.newAlarmConfigurer.showNewAlarmConfigurer()
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.register(AlarmCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AlarmCollectionViewItem"))
       view.addSubview(backgroundView, positioned: .below, relativeTo: view)
		self.shorOrHideNotifier(numberOfAlarms: AlarmCenter.sharedInstance.count)
		popover.appearance=NSAppearance(named: NSAppearance.Name.vibrantDark)
		//tableView.selectionHighlightStyle=NSTableView.SelectionHighlightStyle.none
		timeFormatter.locale=Locale(identifier: "en_US")
		timeFormatter.setLocalizedDateFormatFromTemplate("hmm")
		collectionView.delegate=self
		collectionView.dataSource=self
		backgroundView.translatesAutoresizingMaskIntoConstraints=false
		//*
		let leadingConstraint=NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		let trailingConstraint=NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		let topConstraint=NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let bottomConstraint=NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
		observation = observe(
			\.objectToObserve.count,
            options: [.old, .new]
        ) { _, change in
			if change.newValue ?? 0>change.oldValue ?? 0 {
				self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
			}
        }
		observation2 = observe(
			\.objectToObserve.activeAlarms,
            options: [.old, .new]
        ) { _, change in
			self.shorOrHideNotifier(numberOfAlarms: change.newValue ?? 0)
        }
		update()
    }
	func shorOrHideNotifier(numberOfAlarms: Int) {
		if (numberOfAlarms)>0 {
			self.alarmNotifierTextField.isHidden=false
		} else {
			self.alarmNotifierTextField.isHidden=true
		}
	}
	func update() {
		applyColorScheme(views: [ColorView](), labels: [titleTextField, alarmNotifierTextField])
		collectionView.reloadData()
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return AlarmCenter.sharedInstance.count
	 }
	
	  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let alarm = AlarmCenter.sharedInstance.getAlarm(index: row)
		if tableColumn == tableView.tableColumns[0] {
			guard let cell0 = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AlarmTimeTableCellView"), owner: nil) as? AlarmTimeTableCellView) else { return NSTableCellView() }
		cell0.alarmTimeTextField.textColor=textColor
			cell0.alarmRepeatTextField.textColor=textColor
			cell0.alarmTimeTextField.stringValue=timeFormatter.string(from: alarm.time)
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
			cell1.alarmStatusSegmentedControl.action=#selector(onOffSelected(sender:))
			return cell1
		} else if tableColumn == tableView.tableColumns[2] {
			guard let cell2 = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AlarmSettingsTableCellView"), owner: nil) as? AlarmSettingsTableCellView) else {
				return NSTableCellView() }
			cell2.alarmSettingsButton.action=#selector(showPopover(sender:))
			return cell2
		}
		return NSTableCellView()
	  }
	@objc func onOffSelected(sender: Any) {
		if let segmentedControl=sender as? NSSegmentedControl {
			guard let tableViewCell=segmentedControl.superview as? AlarmStatusTableCellView else { return }
			guard let alarmTableView=collectionView else {
				return
			}
			guard let index: Int=indexPathForView(cellItem: tableViewCell, collectionView: collectionView)?.item else {
				return
			}
				let alarm=AlarmCenter.sharedInstance.getAlarm(index: index)
			switch segmentedControl.selectedTag() {
			case 0: alarm.active=false
			case 1: alarm.active=true
			alarm.setExpirationDate(currentDate: Date())
			default:
				alarm.active=true
			}
			alarmTableView.reloadData()
		}
		AlarmCenter.sharedInstance.saveAlarms()
		AlarmCenter.sharedInstance.setAlarms()
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
		guard let index=indexPathForView(cellItem: tableViewCell, collectionView: collectionView)?.item else {
		return
			}
			let alarm=AlarmCenter.sharedInstance.getAlarm(index: index)
			editableAlarmViewController.cancel = { () -> Void in self.popover.close() }
			editableAlarmViewController.delete = { () -> Void in
				AlarmCenter.sharedInstance.removeAlarm(index: index)
				self.collectionView.reloadData()
			}
			popover.contentViewController = editableAlarmViewController
			popover.show(relativeTo: settingsButton.bounds, of: settingsButton, preferredEdge: NSRectEdge.minY)
			editableAlarmViewController.settingsButton=settingsButton
			editableAlarmViewController.collectionView=collectionView
			editableAlarmViewController.assignAlarm(alarm: alarm)
		}
	}
	func indexPathForView(cellItem: NSView, collectionView: NSCollectionView) -> IndexPath? {
		let point = cellItem.convert(cellItem.bounds.origin, to: collectionView)
		if let indexPath = collectionView.indexPathForItem(at: point){
			return indexPath
		}
		return nil

	}

}
