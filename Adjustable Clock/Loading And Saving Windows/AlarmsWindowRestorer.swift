//
//  AlarmsWindowRestorer.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/21/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class AlarmsWindowRestorer: WindowFrameRestorer {
    private let xKey="alarmsXPosition"
    private let yKey="alarmsYPosition"
    private let widthKey="alarmWidthKey"
    private let heightKey="alarmHeightKey"
	private let minWidth: CGFloat=10
    private let minHeight: CGFloat=10
    init() {
		super.init(xKey: xKey, yKey: yKey, widthKey: widthKey, heightKey: heightKey, minWidth: minWidth, minHeight: minHeight)
    }
	func getAlarmsHeight() -> Int {
		return UserDefaults().integer(forKey: heightKey)
	}
}
