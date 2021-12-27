//
//  Lap.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/21/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
class Lap: Codable {
	var lapNumber=0
	var timeInterval: TimeInterval=0
	var useSecondsPrecision=false
	var notes=""
	init(lapNumber: Int, timeInterval: TimeInterval, useSecondsPrecision: Bool) {
		self.lapNumber=lapNumber
		self.timeInterval=timeInterval
		self.useSecondsPrecision=useSecondsPrecision
	}
}
