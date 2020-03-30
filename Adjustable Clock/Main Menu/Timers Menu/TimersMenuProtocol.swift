//
//  TimersMenuProtocol.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
protocol TimerMenuDelegate: AnyObject {
	func toggleTimerFloatsClicked()
	func showTimerOneClicked()
	func showTimerTwoClicked()
	func showTimerThreeClicked()
	func showTimersClicked()
	func asSecondsClicked()
}
