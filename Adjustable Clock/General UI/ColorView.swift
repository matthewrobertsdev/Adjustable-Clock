//
//  ColorView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/5/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
protocol ColorView: NSView {
	var color: NSColor { get set }
}
