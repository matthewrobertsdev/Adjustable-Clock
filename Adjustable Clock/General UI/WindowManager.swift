//
//  WindowManager.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 3/14/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
class WindowManager {
	static let sharedInstance=WindowManager()
	private init(){
	}
	var dockWindowArray=[NSWindow]()
}
