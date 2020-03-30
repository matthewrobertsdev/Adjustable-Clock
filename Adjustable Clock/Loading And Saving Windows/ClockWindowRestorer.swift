//
//  SavedClockState.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/21/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class ClockWindowRestorer: WindowFrameRestorer {
    private let xKey="clockXPosition"
    private let yKey="clockYPosition"
    private let widthKey="clockWidthKey"
    private let heightKey="clockHeightKey"
	private let minWidth: CGFloat=150
    private let minHeight: CGFloat=150
    init() {
		super.init(xKey: xKey, yKey: yKey, widthKey: widthKey, heightKey: heightKey,
				   minWidth: minWidth, minHeight: minHeight, maxWidth: nil, maxHeight: nil)
    }
	func getClockWidth() -> Int {
		return UserDefaults().integer(forKey: widthKey)
	}
}
