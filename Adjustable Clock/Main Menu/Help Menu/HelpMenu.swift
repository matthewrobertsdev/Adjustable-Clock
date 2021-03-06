//
//  HelpMenu.swift
//  Clock Suite
//
//  Created by Matt Roberts on 8/3/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import Cocoa

class HelpMenu: NSMenu {
	weak var helpMenuDelegate: HelpMenuDelegate!
	@IBAction func openHomepage(_ sender: Any) {
		helpMenuDelegate.openHomePage()
	}
	@IBAction func openContactTheDeveloperPage(_ sender: Any) {
		helpMenuDelegate.openContactTheDeveloperPage()
	}
	@IBAction func openPrivacyPolicyPage(_ sender: Any) {
		helpMenuDelegate.openPrivacyPolicyPage()
	}
	@IBAction func openFAQ_Page(_ sender: Any) {
		helpMenuDelegate.openFAQ_Page()
	}
}
