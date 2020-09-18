//
//  SimplePreferencesVC.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 8/5/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Cocoa
class SimplePreferencesViewController: NSViewController {
	@IBOutlet weak var use24HourButton: NSButton!
	@IBOutlet weak var useTranslucentButton: NSButton!
	@IBOutlet weak var useDarkGrayButton: NSButton!
	@IBOutlet weak var useAnalogNoSecondsButton: NSButton!
	@IBOutlet weak var useAnlogWithSecondsButton: NSButton!
	@IBOutlet weak var useDigitalNoSecondsButton: NSButton!
	@IBOutlet weak var useDigitalWithSecondsButton: NSButton!
	let preferences=GeneralPreferencesStorage.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
	@IBAction func toggle24Hours(_ sender: Any) {
		self.use24HoursClicked()
	}
	@IBAction func useTranslucent(_ sender: Any) {
		GeneralPreferencesStorage.sharedInstance.useTranslucentBackground()
		updateForPreferencesChange()
		updateUI()
	}
	@IBAction func useDarkGray(_ sender: Any) {
		GeneralPreferencesStorage.sharedInstance.useGrayBackground()
		updateForPreferencesChange()
		updateUI()
	}
	/*
	@IBAction func useAnalogWithoutSeconds(_ sender: Any) {
		self.analogClockNoSecondsClicked()
	}
	@IBAction func useAnalogWithSeconds(_ sender: Any) {
		self.analogClockWithSecondsClicked()
	}
	@IBAction func useDigitalWithoutSeconds(_ sender: Any) {
		self.digitalClockNoSecondsClicked()
	}
	@IBAction func useDigitalWithSeconds(_ sender: Any) {
		self.digitalClockWithSecondsClicked()
	}
*/
    @IBAction func restoreDefaults(_ sender: Any) {
		ClockPreferencesStorage.sharedInstance.setDefaultUserDefaults()
        ClockPreferencesStorage.sharedInstance.loadUserPreferences()
		TimersPreferenceStorage.sharedInstance.setDefaultUserDefaults()
		TimersPreferenceStorage.sharedInstance.loadPreferences()
		GeneralPreferencesStorage.sharedInstance.setDefaultUserDefaults()
		GeneralPreferencesStorage.sharedInstance.loadUserPreferences()
        updateForPreferencesChange()
		updateUI()
    }
	func use24HoursClicked() {
			GeneralPreferencesStorage.sharedInstance.changeAndSaveUseAmPM()
			ClockWindowController.clockObject.updateClockToPreferencesChange()
			DockClockController.dockClockObject.updateModelToPreferencesChange()
			AlarmsWindowController.alarmsObject.updateForPreferencesChange()
			TimersWindowController.timersObject.update()
		}
		func updateUI() {
			if preferences.use24Hours {
				use24HourButton.state=NSControl.StateValue.on
			} else {
				use24HourButton.state=NSControl.StateValue.off
			}
			if preferences.usesTranslucentBackground {
			useDarkGrayButton.state=NSControl.StateValue.off
				useTranslucentButton.state=NSControl.StateValue.on
			} else {
				useDarkGrayButton.state=NSControl.StateValue.on
				useTranslucentButton.state=NSControl.StateValue.off
			}
		/*	useAnalogNoSecondsButton.state=NSControl.StateValue.off
			useAnlogWithSecondsButton.state=NSControl.StateValue.off
			useDigitalNoSecondsButton.state=NSControl.StateValue.off
			useDigitalWithSecondsButton.state=NSControl.StateValue.off
			switch preferences.dockClock {
			case preferences.useAnalogNoSeconds:
				useAnalogNoSecondsButton.state=NSControl.StateValue.on
			case preferences.useAnalogWithSeconds:
				useAnlogWithSecondsButton.state=NSControl.StateValue.on
			case preferences.useDigitalNoSeconds:
				useDigitalNoSecondsButton.state=NSControl.StateValue.on
			case preferences.useDigitalWithSeconds:
				useDigitalWithSecondsButton.state=NSControl.StateValue.on
			default:
				break
			}
*/
		}
	/*
		@objc func showPreventsSleep() {
			if AlarmCenter.sharedInstance.activeAlarms>0||TimersCenter.sharedInstance.activeTimers>0 {
				menu.preventingSleepMenuItem.title="Preventing Sleep"
			} else {
				menu.preventingSleepMenuItem.title="Can Sleep"
			}
		}
*/
		func analogClockNoSecondsClicked() {
			preferences.updateDockClockPreferences(mode: preferences.useAnalogNoSeconds)
			updateDockClockChoice()
		}
		func analogClockWithSecondsClicked() {
			preferences.updateDockClockPreferences(mode: preferences.useAnalogWithSeconds)
			updateDockClockChoice()
		}
		func digitalClockNoSecondsClicked() {
			preferences.updateDockClockPreferences(mode: preferences.useDigitalNoSeconds)
			updateDockClockChoice()
		}
		func digitalClockWithSecondsClicked() {
			preferences.updateDockClockPreferences(mode: preferences.useDigitalWithSeconds)
			updateDockClockChoice()
		}
		func updateDockClockChoice() {
			updateUI()
			preferences.updateModelToPreferences()
			DockClockController.dockClockObject.updateModelToPreferencesChange()
			DockClockController.dockClockObject.updateClockForPreferencesChange()
		}

    func updateForPreferencesChange() {
		ClockWindowController.clockObject.updateClockToPreferencesChange()
		updateClockMenuUI()
		TimersWindowController.timersObject.update()
		updateTimerMenuUI()
		DockClockController.dockClockObject.updateClockForPreferencesChange()
		updateDockClockMenuUI()
		updateDockClockPrefrencesMenuUI()
		AlarmsWindowController.alarmsObject.updateForPreferencesChange()
		updateColorMenuUI()
    }
	func updateColorMenuUI() {
		guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
			return
		}
		if let colorsMenuController=appDelegate.colorsMenuController {
			colorsMenuController.makeColorMenuUI()
			colorsMenuController.updateColorMenuUI()
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
	func updateDockClockPrefrencesMenuUI() {
		guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
			return
		}
		if let dockClockPreferencesController=appDelegate.dockClockPreferencesController {
			dockClockPreferencesController.updateUI()
		}
    }
	func updateDockClockMenuUI() {
		guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
			return
		}
		appDelegate.dockClockMenuController?.updateUI()
    }
}
