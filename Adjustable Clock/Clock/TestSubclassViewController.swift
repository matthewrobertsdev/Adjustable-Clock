//
//  TestSubclassViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/4/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class TestSubclassViewController: TestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.wantsLayer=true
		self.view.layer?.backgroundColor=NSColor.systemYellow.cgColor
    }
}
