//
//  WindowRestoration.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/21/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import Cocoa

class AlarmsWindowRestoration: NSObject, NSWindowRestoration {
	static func restoreWindow(withIdentifier identifier: NSUserInterfaceItemIdentifier, state: NSCoder, completionHandler: @escaping (NSWindow?, Error?) -> Void) {
		AlarmsWindowController.alarmsObject.showAlarms()
	}
	

}
