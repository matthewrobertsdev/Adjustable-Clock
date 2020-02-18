//
//  WorldClockViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/13/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class WorldClockViewController: ColorfulViewController, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
	@IBOutlet weak var collectionViewFlowLayout: NSCollectionViewFlowLayout!
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		1
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		guard let worldClockCollectionViewItem=collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("WorldClockCollectionViewItem"), for: indexPath) as? WorldClockCollectionViewItem else {
			return NSCollectionViewItem()
		}
			let analogClock=worldClockCollectionViewItem.analogClock
		analogClock?.worldClock=true
		analogClock?.widthConstraint.constant=327
		//analogClock?.immutableBounds=NSRect(origin: CGPoint(x:0, y:0), size: CGSize(width: 327, height: 200))
		//analogClock?.layout()
		//analogClock?.display(analogClock?.frame ?? CGRect(x: 0, y: 0, width: 100, height: 100))
		//print("world "+(analogClock?.frame.width.description)!)
		//print("world "+(analogClock?.frame.height.description)!)
		//analogClock?.draw(analogClock?.frame ?? CGRect(x: 0, y: 0, width: 100, height: 100))
		analogClock?.setNeedsDisplay(analogClock!.bounds)
		analogClock?.positionLabels()
		analogClock?.setNeedsDisplay(analogClock!.bounds)
		return worldClockCollectionViewItem
	}
	@IBOutlet weak var titleTextField: NSTextField!
	@IBOutlet weak var collectionView: NSCollectionView!
	override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.register(WorldClockCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "WorldClockCollectionViewItem"))
		collectionView.dataSource=self
		collectionView.delegate=self
		updateColors()
    }
	func collectionView(_ collectionView: NSCollectionView,
		   layout collectionViewLayout: NSCollectionViewLayout,
		   sizeForItemAt indexPath: IndexPath) -> NSSize {
		return NSSize(width: 332, height: 563)
	}
	func update() {
		updateColors()
		collectionView.reloadData()
	}
	func updateColors() {
		applyColorScheme(views: [ColorView](), labels: [titleTextField])
	}
}
