//
//  ClockMenuController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/20/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class ClockMenu: NSMenu {
	weak var clockMenuDelegate: ClockMenuDelegate!
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
		clockMenuDelegate.useDigitalClicked()
    }
	@IBAction func clickAnalog(nsMenuItem: NSMenuItem) {
		clockMenuDelegate.useAnalogClicked()
    }
    @IBAction func clickClockFloats(nsMenuItem: NSMenuItem) {
		clockMenuDelegate.floatClicked()
    }
    @IBAction func clickShowSeconds(nsMenuItem: NSMenuItem) {
		clockMenuDelegate.showSecondsClicked()
    }
    @IBAction func clickUse24Hours(nsMenuItem: NSMenuItem) {
		clockMenuDelegate.useTwentyFourHourClicked()
    }
    @IBAction func clickShowDate(nsMenuItem: NSMenuItem) {
		clockMenuDelegate.showDateClicked()
    }
    @IBAction func showDayOfWeek(nsMenuItem: NSMenuItem) {
		clockMenuDelegate.showDayOfWeekClicked()
    }
    @IBAction func useNumericalDate(nsMenuItem: NSMenuItem) {
		clockMenuDelegate.useNumericalClicked()
    }
	@IBAction func showClock(nsMenuItem: NSMenuItem) {
		clockMenuDelegate.showClockClicked()
	}
}
