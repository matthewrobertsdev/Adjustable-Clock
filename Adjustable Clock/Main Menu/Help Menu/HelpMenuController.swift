//
//  HelpMenuController.swift
//  Clock Suite
//
//  Created by Matt Roberts on 8/3/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import AppKit
class HelpMenuController: HelpMenuDelegate {
	var menu: HelpMenu?
	init(menu: HelpMenu) {
		self.menu=menu
		menu.helpMenuDelegate=self
	}
	func openContactTheDeveloperPage(){
		NSWorkspace.shared.open(URL(string: "https://matthewrobertsdev.github.io/clocksuite/contact")!)
	}
	func openPrivacyPolicyPage(){
		NSWorkspace.shared.open(URL(string: "https://matthewrobertsdev.github.io/clocksuite/privacy")!)
	}
}
