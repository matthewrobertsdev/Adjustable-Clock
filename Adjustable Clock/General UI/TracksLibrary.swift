//
//  TrackLibrary.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/26/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Foundation
import iTunesLibrary
class TracksLibrary {
	static let sharedInstance=TracksLibrary()
	var playlists=[ITLibPlaylist]()
	var itunesLibrary: ITLibrary?
	private init() {
	}
	func populateLibrary(completionHandler:  () -> Void ) throws {
		try itunesLibrary=ITLibrary(apiVersion: "1.0")
		playlists=itunesLibrary?.allPlaylists ?? [ITLibPlaylist]()
		completionHandler()
	}
}
