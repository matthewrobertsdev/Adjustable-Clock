//
//  SavedPreferencesState.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/21/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class PreferencesWindowRestorer: WindowFrameRestorer {
	private let xKey="preferencesXPositionKey"
    private let yKey="preferencesYPositionKey"
    private let widthKey="preferencesWidthKey"
	private let heightKey="preferencesHeightKey"
    private let minWidth: CGFloat=10
    private let minHeight: CGFloat=10
    init() {
		super.init(xKey: xKey, yKey: yKey, widthKey: widthKey, heightKey: heightKey, minWidth: minWidth, minHeight: minHeight, maxWidth: nil, maxHeight: nil)
    }
}
