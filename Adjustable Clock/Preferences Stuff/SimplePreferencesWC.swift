//
//  SimplePreferencesWC.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 8/4/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Cocoa

class SimplePreferencesWC: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.maxSize=CGSize(width: (window?.frame.width)!, height: (window?.frame.height)!)
        window?.minSize=CGSize(width: (window?.frame.width)!, height: (window?.frame.height)!)
    }
}
