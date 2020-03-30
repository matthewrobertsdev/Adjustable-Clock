//
//  WorldClockFrameRestorer.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/19/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class WorldClockWindowRestorer: WindowFrameRestorer {
    private let xKey="worldClockXPosition"
    private let yKey="worldClockYPosition"
    private let widthKey="worldClockWidthKey"
    private let heightKey="worldClockHeightKey"
	private let minWidth: CGFloat=150
    private let minHeight: CGFloat=150
    init() {
		super.init(xKey: xKey, yKey: yKey, widthKey: widthKey, heightKey: heightKey, minWidth: minWidth,
				   minHeight: minHeight, maxWidth: nil, maxHeight: nil)
    }
	func getClockWidth() -> Int {
		return UserDefaults().integer(forKey: widthKey)
	}
}
