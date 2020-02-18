//
//  WorldClockCollectionViewItem.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/17/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class WorldClockCollectionViewItem: NSCollectionViewItem {
	@IBOutlet weak var analogClock: AnalogClockView!
	override func viewDidLoad() {
        super.viewDidLoad()
    }
}
