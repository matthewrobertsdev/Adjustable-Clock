//
//  SavedClockState.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/21/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//

import Cocoa

class ClockWindowStateOperator: WindowStateOperator{
    
    init() {
        super.init(xPositionKey: AppUserDefaults.clockXPositionKey, yPositionKey: AppUserDefaults.clockYPositionKey, widthKey: AppUserDefaults.clockWidthKey, heightKey: AppUserDefaults.clockHeightKey, minWidth: AppUserDefaults.clockMinWidth, minHeight: AppUserDefaults.clockMinHeight)
        
    }
    
}
