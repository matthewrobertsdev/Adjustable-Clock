//
//  AlarmSettingsTableViewCell.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class AlarmSettingsTableCellView: NSTableCellView {
	@IBOutlet weak var alarmSettingsButton: NSButton!
	/*required init?(coder: NSCoder) {
		super.init(coder: coder)
		let xConstraint=NSLayoutConstraint(item: alarmSettingsButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
		let yConstraint=NSLayoutConstraint(item: alarmSettingsButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([xConstraint, yConstraint])
	}*/
	override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        
    }
    
}
