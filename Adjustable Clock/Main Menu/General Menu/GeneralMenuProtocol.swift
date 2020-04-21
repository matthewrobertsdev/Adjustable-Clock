//
//  GeneralMenuProtocol.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/29/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
protocol GeneralMenuDelegate: AnyObject {
	func use24HoursClicked()
	func analogClockNoSecondsClicked()
	func analogClockWithSecondsClicked()
	func digitalClockNoSecondsClicked()
	func digitalClockWithSecondsClicked()
}
