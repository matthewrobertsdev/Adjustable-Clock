//
//  ClockPreferencesModel.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 6/10/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Cocoa
/*
 In charge of retrieving from disk, storing in RAM, and saving to disk user preferences.
 It is a singleton (Except for some string keys used for saving)
 */
class ClockPreferencesStorage {
    static let sharedInstance=ClockPreferencesStorage()
    private init() {
    }
    let userDefaults=UserDefaults()
	//window
    var clockFloats = false
    var fullscreen = false
    var colorChoice = ""
    //time
    var showSeconds = false
    var use24hourClock = false
    //date
    var showDate = true
    var showDayOfWeek = true
    var useNumericalDate = false
    //color
    var colorForForeground = false
	var customColor=NSColor.systemGray
    var redComponent: CGFloat?
    var greenComponent: CGFloat?
    var blueComponent: CGFloat?
    //keys
    private let clockWindowFloatsKey="clockWindowFloats"
    private let showSeocndsKey="showSeconds"
    private let use24hourClockKey="use24hourClock"
    private let showDateKey="showDate"
    private let showDayOfWeekKey="showDayOfWeek"
    private let useNumericalDateKey="useNumericalDateKey"
    private let colorSchemeKey="colorScheme"
    private let colorChoiceKey="colorChoice"
    private let lightOnDarkKey="lightOnDark"
	private let customRedComponentKey="customRedComponentKey"
	private let customGreenComponentKey="customGreenComponentKey"
	private let customBlueComponentKey="customBlueComponentKey"
	private let applicationHasLaunched="applicationHasLaunched"
	func hasLaunchedBefore() -> Bool {
		return userDefaults.bool(forKey: applicationHasLaunched)
	}
	func setApplicationAsHasLaunched() {
	}
    func loadUserPreferences() {
        clockFloats=userDefaults.bool(forKey: clockWindowFloatsKey)
		showSeconds=userDefaults.bool(forKey: showSeocndsKey)
		use24hourClock=userDefaults.bool(forKey: use24hourClockKey)
		showDate=userDefaults.bool(forKey: showDateKey)
		showDayOfWeek=userDefaults.bool(forKey: showDayOfWeekKey)
		useNumericalDate=userDefaults.bool(forKey: useNumericalDateKey)
        if let colorChoice=userDefaults.string(forKey: colorChoiceKey) {
			self.colorChoice=colorChoice
        } else {
			self.colorChoice=ColorChoice.gray
        }
        colorForForeground=userDefaults.bool(forKey: lightOnDarkKey)
        redComponent=CGFloat(userDefaults.float(forKey: customRedComponentKey))
        greenComponent=CGFloat(userDefaults.float(forKey: customGreenComponentKey))
        blueComponent=CGFloat(userDefaults.float(forKey: customBlueComponentKey))
		customColor=NSColor(deviceRed: redComponent!, green: greenComponent!, blue: blueComponent!, alpha: 1)
    }
    func changeAndSaveUseAmPM() {
        use24hourClock=(!use24hourClock)
        userDefaults.set(use24hourClock, forKey: use24hourClockKey)
    }
    func changeAndSaveUseSeconds() {
        showSeconds=(!showSeconds)
        userDefaults.set(showSeconds, forKey: showSeocndsKey)
    }
    func changeAndSaveShowDate() {
        showDate=(!showDate)
        userDefaults.set(showDate, forKey: showDateKey)
    }
    func changeAndSaveShowDofW() {
        showDayOfWeek=(!showDayOfWeek)
        userDefaults.set(showDayOfWeek, forKey: showDayOfWeekKey)
    }
    func changeAndSaveUseNumericalDate() {
        useNumericalDate=(!useNumericalDate)
        userDefaults.set(useNumericalDate, forKey: useNumericalDateKey)
    }
    func changeAndSaveLonD() {
        colorForForeground=(!colorForForeground)
        userDefaults.set(colorForForeground, forKey: lightOnDarkKey)
    }
    func changeAndSaveColorSceme(colorChoice: String) {
        self.colorChoice=colorChoice
        userDefaults.set(self.colorChoice, forKey: colorChoiceKey)
    }
    func changeAndSaveClockFloats() {
        clockFloats=(!clockFloats)
        userDefaults.set(clockFloats, forKey: clockWindowFloatsKey)
    }
    func changeAndSaveCustomColor(customColor: NSColor) {
		self.customColor=customColor.usingColorSpace(NSColorSpace.deviceRGB) ?? NSColor.systemGray
        self.colorChoice=ColorChoice.custom
        userDefaults.set("custom", forKey: colorChoiceKey)
        redComponent=self.customColor.redComponent
        userDefaults.set(redComponent, forKey: customRedComponentKey)
        greenComponent=self.customColor.greenComponent
        userDefaults.set(greenComponent, forKey: customGreenComponentKey)
        blueComponent=self.customColor.blueComponent
        userDefaults.set(blueComponent, forKey: customBlueComponentKey)
    }
	func setDefaultUserDefaults() {
        userDefaults.set(false, forKey: clockWindowFloatsKey)
        userDefaults.set(false, forKey: showSeocndsKey)
        userDefaults.set(false, forKey: use24hourClockKey)
        userDefaults.set(false, forKey: showDateKey)
        userDefaults.set("", forKey: colorSchemeKey)
    }
}
