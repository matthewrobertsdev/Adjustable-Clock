//
//  GeneralMenuProtocol.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/29/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
protocol DockClockMenuDelegate: AnyObject {
	func analogClockNoSecondsClicked()
	func analogClockWithSecondsClicked()
	func digitalClockNoSecondsClicked()
	func digitalClockWithSecondsClicked()
}
