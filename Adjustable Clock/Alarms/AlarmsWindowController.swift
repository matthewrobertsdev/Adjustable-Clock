//
//  AlarmsWindowController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/21/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import Cocoa
class AlarmsWindowController: FullViewWindowController, NSWindowDelegate, NSToolbarDelegate {
	@IBOutlet weak var toolbar: NSToolbar!
	static var alarmsObject=AlarmsWindowController()
	var fullscreen=false
    override func windowDidLoad() {
		toolbar.items.first?.isEnabled=true
        super.windowDidLoad()
		toolbar.delegate=self
		WindowManager.sharedInstance.count+=1
		AlarmsWindowController.alarmsObject=AlarmsWindowController()
		window?.delegate=self
		AlarmsPreferencesStorage.sharedInstance.setWindowIsClosed()
		window?.minSize=CGSize(width: 317, height: 300)
		if AlarmsPreferencesStorage.sharedInstance.hasLaunchedBefore() {
			AlarmsWindowRestorer().loadSavedWindowCGRect(window: window)
		}
		//prepareWindowButtons()
    }
	@IBAction func addAlarm(_ sender: Any) {
		if AlarmCenter.sharedInstance.count>=24 {
			let alert=NSAlert()
			alert.messageText="Sorry, but Clock Suite does not allow more than 24 alarms."
			alert.runModal()
		} else {
		EditableAlarmWindowController.newAlarmConfigurer.showNewAlarmConfigurer()
		}
	}
	
	func windowWillClose(_ notification: Notification) {
		WindowManager.sharedInstance.count-=1
		saveState()
		AlarmsPreferencesStorage.sharedInstance.setAlarmsAsHasLaunched()
		if GeneralPreferencesStorage.sharedInstance.closing {
			AlarmsPreferencesStorage.sharedInstance.setWindowIsOpen()
		} else {
			AlarmsPreferencesStorage.sharedInstance.setWindowIsClosed()
		}
    }
	func saveState() {
		AlarmsWindowRestorer().windowSaveCGRect(window: window)
    }
	func showAlarms() {
		if alarmsWindowPresent()==false {
		let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let alarmsWindowController =
			mainStoryBoard.instantiateController(withIdentifier:
				"AlarmsWindowController") as? AlarmsWindowController else { return }
			AlarmsWindowController.alarmsObject=alarmsWindowController
		AlarmsWindowController.alarmsObject.loadWindow()
			AlarmsWindowController.alarmsObject.showWindow(nil)
		} else {
			let appObject = NSApp as NSApplication
	for window in appObject.windows where window.identifier==UserInterfaceIdentifier.alarmsWindow {
				if let alarmsWindowController=window.windowController as? AlarmsWindowController {
					AlarmsWindowController.alarmsObject=alarmsWindowController
						window.makeKeyAndOrderFront(nil)
					}
				}
			}
	}
	func alarmsWindowPresent() -> Bool {
		return isWindowPresent(identifier: UserInterfaceIdentifier.alarmsWindow)
	}
	func updateForPreferencesChange() {
        let appObject = NSApp as NSApplication
		for window in appObject.windows where window.identifier==UserInterfaceIdentifier.alarmsWindow {
			if let alarmsViewController=window.contentViewController as? AlarmsViewController {
					alarmsViewController.update()
            }
        }
    }
	func windowDidEnterFullScreen(_ notification: Notification) {
        removeTrackingArea()
		hideButtonsTimer?.cancel()
        updateClockMenuUI()
		fullscreen=true
        //showButtons(show: true)
		//reloadPreferencesWindowIfOpen()
    }
	func windowDidExitFullScreen(_ notification: Notification) {
		fullscreen=false
        window?.makeKey()
		//prepareWindowButtons()
        updateClockMenuUI()
		//reloadPreferencesWindowIfOpen()
    }
	func windowWillMiniaturize(_ notification: Notification) {
		WindowManager.sharedInstance.dockWindowArray.append(window ?? NSWindow())
	}
	func windowDidDeminiaturize(_ notification: Notification) {
		WindowManager.sharedInstance.dockWindowArray.removeAll { (dockWindow) -> Bool in
			return dockWindow==window
		}
	}
	func windowDidBecomeKey(_ notification: Notification) {
		/*
		if !fullscreen {
			flashButtons()
		}
*/
    }
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return [ .addAlarm ]
	}
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return [.addAlarm]
	}
}

private extension NSToolbarItem.Identifier {
	static let addAlarm: NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "AddAlarm")
}
