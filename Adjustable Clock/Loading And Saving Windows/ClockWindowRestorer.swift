//
//  SavedClockState.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/21/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class ClockWindowRestorer: WindowFrameRestorer{
    private let clockXPositionKey="clockXPosition"
    private let clockYPositionKey="clockYPosition"
    private let clockWidthKey="clockWidthKey"
    private let clockHeightKey="clockHeightKey"
	private let preferencesMinWidth: CGFloat=10
    private let preferencesMinHeight: CGFloat=10
    init() {
        super.init(xPositionKey: clockXPositionKey, yPositionKey: clockYPositionKey, widthKey: clockWidthKey, heightKey: clockHeightKey, minWidth: preferencesMinWidth, minHeight: preferencesMinHeight)
    }
	func getClockWidth()->Int{
		return UserDefaults().integer(forKey: clockWidthKey)
	}
}
