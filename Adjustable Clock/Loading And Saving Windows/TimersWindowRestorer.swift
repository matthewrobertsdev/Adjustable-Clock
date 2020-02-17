//
//  TimersWindowRestorer.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class TimersWindowRestorer: WindowFrameRestorer {
	private let xKey="timersXPosition"
	   private let yKey="timersYPosition"
	   private let widthKey="timersWidthKey"
	   private let heightKey="timersHeightKey"
	   private let minWidth: CGFloat=10
	   private let minHeight: CGFloat=10
	   init() {
		   super.init(xKey: xKey, yKey: yKey, widthKey: widthKey, heightKey: heightKey, minWidth: minWidth, minHeight: minHeight, maxWidth: nil, maxHeight: nil)
	   }
}
