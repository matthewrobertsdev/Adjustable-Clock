//
//  TimerCollectionViewItem.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/4/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class TimerCollectionViewItem: NSCollectionViewItem {
	@IBOutlet weak var titleTextField: NSTextField!
	@IBOutlet weak var countdownTextField: NSTextField!
	@IBOutlet weak var stopTimeTextField: NSTextField!
	@IBOutlet weak var startPauseButton: NSButton!
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
