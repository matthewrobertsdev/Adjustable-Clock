//
//  AlarmCollectionViewItem.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 3/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class AlarmCollectionViewItem: NSCollectionViewItem {
	@IBOutlet weak var alarmTimeTextField: NSTextField!
	@IBOutlet weak var alarmRepeatTextField: NSTextField!
	@IBOutlet weak var alarmStatusSegmentedControl: NSSegmentedControl!
	@IBOutlet weak var alarmSettingsButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
