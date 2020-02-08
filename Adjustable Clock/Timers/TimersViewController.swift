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
	override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.dataSource=self
		collectionView.delegate=self
		collectionView.register(TimerCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimerCollectionViewItem"))
		update()
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
		return timerCollectionViewItem
	}
}
