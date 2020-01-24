//
//  Alarm.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/22/20.
//  Copyright © 2020 Matt Robertss. All rights reserved.
//
import Foundation
class Alarm {
	var date: Date
	var usesSong: Bool
	var repeats: Bool
	var song: String?
	var active=false
	init(date: Date, usesSong: Bool, repeats: Bool, song: String?, active: Bool){
		self.date=date
		self.usesSong=usesSong
		self.repeats=repeats
		self.song=song
		self.active=active
	}
}
