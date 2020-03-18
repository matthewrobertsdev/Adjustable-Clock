//
//  Timer.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
class CountDownTimer: Codable {
	var secondsRemaining=180
	var totalSeconds=180
	var title=""
	var alertStyle=AlertStyle.sound
	var alertString=""
	var song=""
	var active=false
	var going=false
	var playlistURL=""
}
