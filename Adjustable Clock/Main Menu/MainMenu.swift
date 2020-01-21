//
//  AdjustableClockMainMenu.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 8/24/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import  Cocoa
class MainMenu: NSMenu {
    @IBOutlet weak var colorsMenu: NSMenu!
    let clockPreferences=ClockPreferencesStorage.sharedInstance
    @IBOutlet weak var clockMenu: NSMenu!
	//clock menu items
    @IBOutlet weak var clockFloatsMenuItem: NSMenuItem!
    @IBOutlet weak var showSecondsMenuItem: NSMenuItem!
    @IBOutlet weak var use24HourClockMenuItem: NSMenuItem!
    @IBOutlet weak var showDateMenuItem: NSMenuItem!
    @IBOutlet weak var showDayOfWeekMenuItem: NSMenuItem!
    @IBOutlet weak var datePreferencesMenu: NSMenu!
    @IBOutlet weak var useNumericalDateMenuItem: NSMenuItem!
	@IBOutlet weak var digitalMenuItem: NSMenuItem!
	@IBOutlet weak var analogMenuItem: NSMenuItem!
	@IBAction func clickDigital(nsMenuItem: NSMenuItem) {
		clockPreferences.changeAndSaveUseDigital()
		ClockWindowController.clockObject.showClock()
		updateClockMenuUI()
    }
	@IBAction func clickAnalog(nsMenuItem: NSMenuItem) {
		clockPreferences.changeAndSaveUseAnalog()
		ClockWindowController.clockObject.showClock()
		updateClockMenuUI()
    }
    @IBAction func clickClockFloats(nsMenuItem: NSMenuItem) {
		clockPreferences.changeAndSaveClockFloats()
        updateForPreferencesChange()
    }
    @IBAction func clickShowSeconds(nsMenuItem: NSMenuItem) {
        clockPreferences.changeAndSaveUseSeconds()
        updateForPreferencesChange()
    }
    @IBAction func clickUse24Hours(nsMenuItem: NSMenuItem) {
		clockPreferences.changeAndSaveUseAmPM()
        updateForPreferencesChange()
    }
    @IBAction func clickShowDate(nsMenuItem: NSMenuItem) {
        clockPreferences.changeAndSaveShowDate()
        updateForPreferencesChange()
    }
    @IBAction func showDayOfWeek(nsMenuItem: NSMenuItem) {
        clockPreferences.changeAndSaveShowDofW()
        updateForPreferencesChange()
    }
    @IBAction func useNumericalDate(nsMenuItem: NSMenuItem) {
		clockPreferences.changeAndSaveUseNumericalDate()
        updateForPreferencesChange()
    }
	@IBAction func showClock(nsMenuItem: NSMenuItem) {
		ClockWindowController.clockObject.showClock()
	}
	func updateClockMenuUI() {
        datePreferencesMenu.autoenablesItems=false
        if clockPreferences.fullscreen {
            clockFloatsMenuItem.isEnabled=false
        } else {
            clockFloatsMenuItem.isEnabled=true
        }
        if clockPreferences.clockFloats {
            clockFloatsMenuItem.state=NSControl.StateValue.on
        } else {
			clockFloatsMenuItem.state=NSControl.StateValue.off
        }
		if ClockPreferencesStorage.sharedInstance.useAnalog {
            analogMenuItem.state=NSControl.StateValue.on
			digitalMenuItem.state=NSControl.StateValue.off
        } else {
			analogMenuItem.state=NSControl.StateValue.off
            digitalMenuItem.state=NSControl.StateValue.on
        }
        if ClockPreferencesStorage.sharedInstance.showSeconds {
            showSecondsMenuItem.state=NSControl.StateValue.on
        } else {
            showSecondsMenuItem.state=NSControl.StateValue.off
        }
        if clockPreferences.use24hourClock {
            use24HourClockMenuItem.state=NSControl.StateValue.on
        } else {
            use24HourClockMenuItem.state=NSControl.StateValue.off
        }
        if clockPreferences.showDate {
            showDateMenuItem.state=NSControl.StateValue.on
            useNumericalDateMenuItem.isEnabled=true
        } else {
            showDateMenuItem.state=NSControl.StateValue.off
            useNumericalDateMenuItem.isEnabled=false
        }
        if clockPreferences.showDayOfWeek {
            showDayOfWeekMenuItem.state=NSControl.StateValue.on
        } else {
            showDayOfWeekMenuItem.state=NSControl.StateValue.off
        }
        if clockPreferences.useNumericalDate {
            useNumericalDateMenuItem.state=NSControl.StateValue.on
        } else {
            useNumericalDateMenuItem.state=NSControl.StateValue.off
        }
    }
    @IBAction func pressSimplePreferencesMenuItem(preferenceMenuItem: NSMenuItem) {
        let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.digitalClockWindow {
				guard let digitalClockVC=window.contentViewController as? ClockViewController else {
					return
				}
                if digitalClockVC.model.fullscreen==true {
                    for window in appObject.windows where window.identifier==UserInterfaceIdentifier.prefrencesWindow {
						if let preferencesWC=window.windowController as? SimplePreferenceWindowController {
							preferencesWC.close()
						}
                    }
                    showSimplePreferencesWindow()
				} else {
                    if isThereASimplePreferencesWindow() {
						SimplePreferenceWindowController.prefrencesObject.window?.makeKeyAndOrderFront(nil)
                    } else {
                        showSimplePreferencesWindow()
                    }
                }
            }
    }
    @IBAction func pressShowDigitalClockMenuItem(showClockMenuItem: NSMenuItem) {
		ClockWindowController.clockObject.showClock()
    }
    func showSimplePreferencesWindow() {
        let adjustableClockStoryboard = NSStoryboard(name: "Main", bundle: nil)
		guard let preferencesObject = adjustableClockStoryboard.instantiateController(withIdentifier:
			"SimplePreferencesWC") as? SimplePreferenceWindowController else {
				return
		}
		SimplePreferenceWindowController.prefrencesObject=preferencesObject
		SimplePreferenceWindowController.prefrencesObject.loadWindow()
		SimplePreferenceWindowController.prefrencesObject.showWindow(nil)
    }
	func reloadSimplePreferencesWindow() {
		SimplePreferenceWindowController.prefrencesObject.loadWindow()
		SimplePreferenceWindowController.prefrencesObject.showWindow(nil)
	}
    func updateForPreferencesChange() {
        updateClockMenuUI()
		ClockWindowController.clockObject.updateClockToPreferencesChange()
    }
    func enableClockMenuPreferences(enabled: Bool) {
        clockMenu.autoenablesItems=false
        clockFloatsMenuItem.isEnabled=enabled
        showSecondsMenuItem.isEnabled=enabled
        use24HourClockMenuItem.isEnabled=enabled
        showDateMenuItem.isEnabled=enabled
    }
}
