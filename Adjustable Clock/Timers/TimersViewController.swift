//
//  TimersViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/4/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class TimersViewController: ColorfulViewController, NSTableViewDataSource, NSTableViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegate {
	let popover = NSPopover()
	@IBOutlet weak var titleTextField: NSTextField!
	@IBOutlet weak var collectionView: NSCollectionView!
	var tellingTime: NSObjectProtocol?
	override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.dataSource=self
		collectionView.delegate=self
		popover.appearance=NSAppearance(named: NSAppearance.Name.vibrantDark)
		collectionView.register(TimerCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerCollectionViewItem"))
		update()
		let processOptions: ProcessInfo.ActivityOptions=[ProcessInfo.ActivityOptions.userInitiatedAllowingIdleSystemSleep]
		tellingTime = ProcessInfo().beginActivity(options: processOptions, reason: "Need accurate time for timers")
    }
	func update() {
		applyColorScheme(views: [ColorView](), labels: [titleTextField])
		collectionView.reloadData()
	}
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		3
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		guard let timerCollectionViewItem=collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerCollectionViewItem"), for: indexPath) as? TimerCollectionViewItem else {
			return NSCollectionViewItem()
		}
		timerCollectionViewItem.titleTextField.textColor=textColor
		timerCollectionViewItem.countdownTextField.textColor=textColor
		timerCollectionViewItem.stopTimeTextField.textColor=textColor
		timerCollectionViewItem.countdownTextField.stringValue=TimersCenter.sharedInstance.getCountDownString(index: indexPath.item)
		timerCollectionViewItem.startPauseButton.action=#selector(startPauseAction(sender:))
		timerCollectionViewItem.startPauseButton.tag=indexPath.item
		timerCollectionViewItem.settingsButton.tag=indexPath.item
		timerCollectionViewItem.settingsButton.action=#selector(showPopover(sender:))
		return timerCollectionViewItem
	}
	func scrollToTimer(index: Int) {
		collectionView.scrollToItems(at: [IndexPath(item: index, section: 0)], scrollPosition: NSCollectionView.ScrollPosition.centeredVertically)
	}
	func animateTimer(index: Int) {
		displayTimer(index: index)
		TimersCenter.sharedInstance.gcdTimers[index].schedule(deadline: .now(), repeating: .milliseconds(1000), leeway: .milliseconds(0))
		TimersCenter.sharedInstance.gcdTimers[index].setEventHandler {
			TimersCenter.sharedInstance.updateTimer(index: index)
			self.displayTimer(index: index)
			if TimersCenter.sharedInstance.timers[index].active==false {
				if let timerCollectionViewItem=self.collectionView.item(at: index) as? TimerCollectionViewItem {
					timerCollectionViewItem.startPauseButton.title="Start"
				}
			}
		}
		TimersCenter.sharedInstance.gcdTimers[index].resume()
	}
	func displayTimer(index: Int) {
		if !TimersCenter.sharedInstance.timers[index].active {
			return
		}
		guard let colectionViewItem=collectionView.item(at: index) as? TimerCollectionViewItem else {
			return
		}
		colectionViewItem.countdownTextField.stringValue=TimersCenter.sharedInstance.getCountDownString(index: index)
	}
	@objc func startPauseAction(sender: Any?) {
		guard let startPauseButton=sender as? NSButton else {
			return
		}
		let index=startPauseButton.tag
		guard let timerCollectionViewItem=collectionView.item(at: index) as? TimerCollectionViewItem else {
			return
		}
		if TimersCenter.sharedInstance.timers[index].active {
			TimersCenter.sharedInstance.timers[index].active=false
			TimersCenter.sharedInstance.gcdTimers[index].suspend()
			timerCollectionViewItem.startPauseButton.title="Resume"
		} else {
		TimersCenter.sharedInstance.timers[index].active=true
			animateTimer(index: index)
			timerCollectionViewItem.startPauseButton.title="Pause"
		}
	}
	@objc func showPopover(sender: Any?) {
		guard let settingsButton=sender as? NSButton else {
			return
		}
		if  popover.isShown {
			popover.close()
		} else {
			let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
			   guard let editableTimerViewController =
				mainStoryBoard.instantiateController(withIdentifier:
				   "EditableTimerViewController") as? EditableTimerViewController else { return }
		let index=settingsButton.tag
			editableTimerViewController.closeAction = { () -> Void in self.popover.close() }
			popover.contentViewController = editableTimerViewController
			editableTimerViewController.index=index
			popover.show(relativeTo: settingsButton.bounds, of: settingsButton, preferredEdge: NSRectEdge.minY)
		}
	}
}