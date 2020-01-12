//
//  DockClockController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/12/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class DockClockController {
	static let dockClockObject=DockClockController()
	let dockClockView=DockClockView()
	let appObject = NSApp as NSApplication
	private init() {
	}
	func updateDockTile(){
		dockClockView.setFrameSize(appObject.dockTile.size)
		appObject.dockTile.contentView=dockClockView
		appObject.dockTile.display()
	}
}
