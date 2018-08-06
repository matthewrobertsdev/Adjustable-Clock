//
//  SimplePreferencesVC.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 8/5/18.
//  Copyright © 2018 Celeritas Apps. All rights reserved.
//

import Cocoa

class SimplePreferencesVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func restoreDefaults(_ sender: Any) {
        let appUserDefaults=AppUserDefaults()
        appUserDefaults.setDefaultUserDefaults()
        ClockPreferencesStorage.sharedInstance.loadUserPreferences()
    }
    
}
