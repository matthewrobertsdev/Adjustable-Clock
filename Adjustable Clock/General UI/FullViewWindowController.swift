//
//  FullViewWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/11/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class FullViewWindowController: NSWindowController {
    var backgroundView: NSView?
    override func windowDidLoad() {
        super.windowDidLoad()
		guard let contentViewController=window?.contentViewController else { return }
        backgroundView=contentViewController.view
		window?.isMovableByWindowBackground=true
    }
}
