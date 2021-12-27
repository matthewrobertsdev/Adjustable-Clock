//
//  PrecisionMenuProtocol.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/26/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
protocol PrecisionMenuDelegate: AnyObject {
	func useSecondsClicked()
	func useTenthsOfSecondsClicked()
}
