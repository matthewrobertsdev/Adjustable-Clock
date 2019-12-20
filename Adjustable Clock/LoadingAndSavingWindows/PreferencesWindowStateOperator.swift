//
//  SavedPreferencesState.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/21/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//

import Cocoa

class PreferencesWindowStateOperator:WindowFrameRestorer{
    init() {
        super.init(xPositionKey: AppUserDefaults.preferencesXPositionKey, yPositionKey: AppUserDefaults.preferencesYPositionKey, widthKey: AppUserDefaults.preferencesWidthKey, heightKey: AppUserDefaults.preferencesHeightKey, minWidth: AppUserDefaults.clockMinWidth, minHeight: AppUserDefaults.referencesMinHeight)
    }
}
