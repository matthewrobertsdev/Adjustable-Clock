//
//  ColorfulProtocol.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/5/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import AppKit
protocol ForegroundColorView: NSView {
	var foregroundColor: NSColor { get set }
}
