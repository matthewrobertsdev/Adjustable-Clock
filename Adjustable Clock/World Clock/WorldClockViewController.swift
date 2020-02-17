//
//  WorldClockViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 2/13/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class WorldClockViewController: ColorfulViewController {
	@IBOutlet weak var titleTextField: NSTextField!
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		updateColors()
    }
	func update(){
		updateColors()
	}
	func updateColors(){
		applyColorScheme(views: [ColorView](), labels: [titleTextField])
	}
}
