//
//  SimplePreferencesVC.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 8/5/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
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
        updateForPreferencesChange()
    }
    func updateForPreferencesChange(){
        DigitalClockWC.clockObject.updateClockToPreferencesChange()
        updateClockMenuUI()
    }
    func updateClockMenuUI(){
        let appObject = NSApp as NSApplication
        let mainMenu=appObject.mainMenu as! MainMenu
        mainMenu.updateClockMenuUI()
    }
    
}
