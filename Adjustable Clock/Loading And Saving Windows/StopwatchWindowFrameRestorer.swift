//
//  StopwatchWindowFrameRestorer.swift
//  Clock Suite
//
//  Created by Matt Roberts on 12/21/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
class StopwatchWindowFrameRestorer: WindowFrameRestorer {
	private let xKey="stopwatchXPosition"
	private let yKey="stopwatchYPosition"
	private let widthKey="stopwatchWidthKey"
	private let heightKey="stopwatchHeightKey"
	private let minWidth: CGFloat=363
	private let minHeight: CGFloat=290
	init() {
		super.init(xKey: xKey, yKey: yKey, widthKey: widthKey, heightKey: heightKey,
					  minWidth: minWidth, minHeight: minHeight, maxWidth: nil, maxHeight: nil)
	}
}
