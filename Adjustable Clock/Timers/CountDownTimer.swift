//
//  Timer.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class CountDownTimer: Codable {
	var secondsRemaining=0
	var totalSeconds=0
	var title=""
	var alertStyle=AlertStyle.sound
	var alertString="Ping"
	var song=""
	var active=false
	var going=false
	var playlistURL=""
	var reset=true
	static func == (left: CountDownTimer, right: CountDownTimer) -> Bool {
		return left.secondsRemaining==right.secondsRemaining && left.totalSeconds==right.totalSeconds
			&& left.title==right.title && left.alertStyle==right.alertStyle && left.song==right.song
    }
}
