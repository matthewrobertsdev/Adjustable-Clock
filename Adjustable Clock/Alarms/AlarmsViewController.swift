//
//  AlarmsViewController.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/20/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Cocoa
class AlarmsViewController: NSViewController {
	var colorController: AlarmsColorController?
	@IBOutlet weak var visualEffectView: NSVisualEffectView!
	var backgroundView=DarkAndLightBackgroundView()
	@IBOutlet weak var titleTextField: NSTextField!
	override func viewDidLoad() {
        super.viewDidLoad()
       view.addSubview(backgroundView, positioned: .below, relativeTo: view)
		backgroundView.translatesAutoresizingMaskIntoConstraints=false
		//*
		let leadingConstraint=NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		let trailingConstraint=NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		let topConstraint=NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let bottomConstraint=NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
		colorController=AlarmsColorController(visualEffectView: visualEffectView, view: backgroundView, titleTextField: titleTextField)
		colorController?.applyColorScheme()
    }
	func update(){
		colorController?.applyColorScheme()
	}
}
