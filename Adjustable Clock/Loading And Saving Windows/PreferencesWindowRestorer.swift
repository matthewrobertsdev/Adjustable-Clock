//
//  SavedPreferencesState.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/21/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class PreferencesWindowRestorer: WindowFrameRestorer {
	private let xPositionKey="preferencesXPositionKey"
    private let yPositionKey="preferencesYPositionKey"
    private let widthKey="preferencesWidthKey"
	private let heightKey="preferencesHeightKey"
    private let minWidth: CGFloat=10
    private let minHeight: CGFloat=10
    init() {
        super.init(xPositionKey: xPositionKey, yPositionKey: yPositionKey, widthKey: widthKey, heightKey: heightKey, minWidth: minWidth, minHeight: minHeight)
    }
}
