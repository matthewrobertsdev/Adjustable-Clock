//
//  SimplePreferencesVC.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 8/5/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Cocoa
class SimplePreferencesViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func restoreDefaults(_ sender: Any) {
		ClockPreferencesStorage.sharedInstance.setDefaultUserDefaults()
        ClockPreferencesStorage.sharedInstance.loadUserPreferences()
        updateForPreferencesChange()
    }
    func updateForPreferencesChange() {
        ClockWindowController.clockObject.updateClockToPreferencesChange()
        updateClockMenuUI()
    }
    func updateClockMenuUI() {
		guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
			return
		}
		if let clockMenuController=appDelegate.clockMenuController as? ClockMenuController {
			clockMenuController.updateClockMenuUI()
		}
    }
}