//
//  TimersViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/4/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class TimersViewController: ColorfulViewController, NSTableViewDataSource, NSTableViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegate {
	@IBOutlet weak var collectionView: NSCollectionView!
	var tellingTime: NSObjectProtocol?
	override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.dataSource=self
		collectionView.delegate=self
		collectionView.register(TimerCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerCollectionViewItem"))
		update()
		let processOptions: ProcessInfo.ActivityOptions=[ProcessInfo.ActivityOptions.userInitiatedAllowingIdleSystemSleep]
		tellingTime = ProcessInfo().beginActivity(options: processOptions, reason: "Need accurate time for timers")
    }
	func update() {
		applyColorScheme(views: [ColorView](), labels: [NSTextField]())
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
		return timerCollectionViewItem
	}
	func scrollToTimer(index: Int) {
		collectionView.scrollToItems(at: [IndexPath(item: index, section: 0)], scrollPosition: NSCollectionView.ScrollPosition.centeredVertically)
	}
	func updateTimer(index: Int) {
		TimersCenter.sharedInstance.timers[index].secondsRemaining-=1
	}
	private func animateTimer(index: Int) {
		displayTimer(index: index)
		TimersCenter.sharedInstance.gcdTimers[index].schedule(deadline: .now(), repeating: .milliseconds(1000), leeway: .milliseconds(0))
		TimersCenter.sharedInstance.gcdTimers[index].setEventHandler {
			self.updateTimer(index: index)
			self.displayTimer(index: index)
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
}
