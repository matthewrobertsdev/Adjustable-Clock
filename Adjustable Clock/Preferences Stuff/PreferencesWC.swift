//
//  PreferencesWC.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/18/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//

/*
 just make the preference window the right size
 could have used window restoration class
 */

import Cocoa

class PreferencesWC : NSWindowController,NSWindowDelegate {
    override func windowDidLoad() {
        super.windowDidLoad()
        
        //for debug
        print("PreferencesWC view did load")
        
        //make initial size permanent
        window?.maxSize=CGSize(width: (window?.frame.width)!, height: (window?.frame.height)!)
        window?.minSize=CGSize(width: (window?.frame.width)!, height: (window?.frame.height)!)
        
        let preferencesWindowStateOperator=PreferencesWindowStateOperator()
        preferencesWindowStateOperator.windowLoadOrigin(window: window)
    }
    
    //when closing, if appropraite save state
    func windowWillClose(_ notification: Notification) {
        ifAppropriatePreferencesSaveState()
    }
    func saveState(){
        let preferencesWindowStateOperator=PreferencesWindowStateOperator()
        preferencesWindowStateOperator.windowSaveOrigin(window: window)
    }
    
    @IBAction func doNothing(digitalClockToolBarIcon: NSToolbarItem){
        
    }
}
