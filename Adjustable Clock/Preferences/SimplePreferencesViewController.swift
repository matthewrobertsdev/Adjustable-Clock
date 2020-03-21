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
		TimersPreferenceStorage.sharedInstance.setDefaultUserDefaults()
		TimersPreferenceStorage.sharedInstance.loadPreferences()
		GeneralPreferencesStorage.sharedInstance.setDefaultUserDefaults()
		GeneralPreferencesStorage.sharedInstance.loadUserPreferences()
		
        updateForPreferencesChange()
    }
    func updateForPreferencesChange() {
		ClockWindowController.clockObject.updateClockToPreferencesChange()
		updateClockMenuUI()
		TimersWindowController.timersObject.update()
		updateTimerMenuUI()
		DockClockController.dockClockObject.updateClockForPreferencesChange()
		updateGeneralMenuUI()
		AlarmsWindowController.alarmsObject.updateForPreferencesChange()
    }
    func updateClockMenuUI() {
		guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
			return
		}
		if let clockMenuController=appDelegate.clockMenuController {
			clockMenuController.updateUserInterface()
		}
    }
	func updateTimerMenuUI() {
		guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
			return
		}
		if let timersMenuController=appDelegate.timersMenuController {
			timersMenuController.updateUI()
		}
    }
	func updateGeneralMenuUI() {
		guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
			return
		}
		if let generalMenuController=appDelegate.generalMenuController {
			generalMenuController.updateUI()
		}
    }
}
