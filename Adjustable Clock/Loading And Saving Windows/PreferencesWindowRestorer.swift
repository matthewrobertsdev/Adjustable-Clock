//
//  SavedPreferencesState.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/21/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class PreferencesWindowRestorer: WindowFrameRestorer{
	private let preferencesXPositionKey="preferencesXPositionKey"
    private let preferencesYPositionKey="preferencesYPositionKey"
    private let preferencesWidthKey="preferencesWidthKey"
	private let preferencesHeightKey="preferencesHeightKey"
    private let preferencesMinWidth: CGFloat=10
    private let preferencesMinHeight: CGFloat=10
    init() {
        super.init(xPositionKey: preferencesXPositionKey, yPositionKey: preferencesYPositionKey, widthKey: preferencesWidthKey, heightKey: preferencesHeightKey, minWidth: preferencesMinWidth, minHeight: preferencesMinHeight)
    }
}
