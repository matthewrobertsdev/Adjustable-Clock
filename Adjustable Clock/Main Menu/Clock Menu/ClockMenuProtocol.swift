//
//  ClockMenuDelegate.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/20/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
protocol ClockMenuDelegate: AnyObject {
	func useDigitalClicked()
	func useAnalogClicked()
	func floatClicked()
	func showSecondsClicked()
	func useTwentyFourHourClicked()
	func showDateClicked()
	func showDayOfWeekClicked()
	func useNumericalClicked()
	func showClockClicked()
}
