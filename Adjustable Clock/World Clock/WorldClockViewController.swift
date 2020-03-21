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
	var model=[WorldClockModel]()
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		model.count
	}
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		guard let worldClockCollectionViewItem=collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("WorldClockCollectionViewItem"), for: indexPath) as? WorldClockCollectionViewItem else {
			return NSCollectionViewItem()
		}
			let analogClock=worldClockCollectionViewItem.analogClock
		analogClock?.worldClock=true
		analogClock?.widthConstraint.constant=327
		guard let analogClockBounds=analogClock?.bounds else {
			return worldClockCollectionViewItem
		}
		//analogClock?.setNeedsDisplay(analogClockBounds)
		analogClock?.positionLabels()
		analogClock?.color=textColor
		analogClock?.draw(analogClockBounds)
		worldClockCollectionViewItem.cityTextField.textColor=textColor
		worldClockCollectionViewItem.digitalClock.textColor=textColor
		worldClockCollectionViewItem.animatedDate.textColor=textColor
		return worldClockCollectionViewItem
	}
	@IBOutlet weak var titleTextField: NSTextField!
	@IBOutlet weak var collectionView: NSCollectionView!
	@IBAction func addWorldClock(_ sender: Any) {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
					  guard let chooseCityViewController =
			   mainStoryBoard.instantiateController(withIdentifier:
						  "ChooseCityViewController") as? ChooseCityViewController else { return }
					self.presentAsSheet(chooseCityViewController)
		//model.append(WorldClockModel())
		//collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
	}
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
