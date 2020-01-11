//
//  FullViewWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/11/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class FullViewWindowController: NSWindowController {
	var hideButtonsTimer: Timer?
    var backgroundView: NSView?
    var trackingArea: NSTrackingArea?
    override func windowDidLoad() {
        super.windowDidLoad()
		guard let clockViewController=window?.contentViewController else { return }
        backgroundView=clockViewController.view
		window?.isMovableByWindowBackground=true
    }
	func prepareWindowButtons() {
		showButtons(show: false)
        flashButtons()
        setTrackingArea()
	}
    func removeTrackingArea() {
		guard let view=backgroundView else { return }
		guard let area=trackingArea else { return }
		view.removeTrackingArea(area)
    }
    @objc func hideButtons(timer: Timer) {
		if ClockPreferencesStorage.sharedInstance.fullscreen==false {
            showButtons(show: false)
        }
    }
    func showButtons(show: Bool) {
		if show==true {
			self.window?.standardWindowButton(.closeButton)?.isHidden=(false)
			self.window?.standardWindowButton(.zoomButton)?.isHidden=(false)
			self.window?.standardWindowButton(.miniaturizeButton)?.isHidden=(false)
		} else {
			self.window?.standardWindowButton(.closeButton)?.isHidden=(true)
			self.window?.standardWindowButton(.zoomButton)?.isHidden=(true)
			self.window?.standardWindowButton(.miniaturizeButton)?.isHidden=(true)
			}
    }
    func flashButtons() {
        showButtons(show: true)
        hideButtonsTimer?.invalidate()
        hideButtonsTimer = Timer.scheduledTimer(timeInterval: 1,
                                                target: self,
                                                selector: #selector(hideButtons(timer:)),
                                                userInfo: nil,
                                                repeats: false)
    }
    override func mouseMoved(with event: NSEvent) {
        flashButtons()
    }
	func setTrackingArea() {
		guard let view=backgroundView else { return }
		let rect=view.frame
		let trackingOptions: NSTrackingArea.Options =
			[NSTrackingArea.Options.activeInKeyWindow, NSTrackingArea.Options.inVisibleRect, NSTrackingArea.Options.mouseMoved]
        trackingArea=NSTrackingArea(rect: rect, options: trackingOptions, owner: view.window, userInfo: nil)
		guard let area=trackingArea else { return }
        view.addTrackingArea(area)
    }
}
