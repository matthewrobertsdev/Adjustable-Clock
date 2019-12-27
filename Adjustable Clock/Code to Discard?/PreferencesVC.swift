//
//  PreferencesVC.swift
//  Digital Clock
//
//  Created by Matt Roberts on 8/8/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//

//update ui based on new or saved preferences
//handle prefence actions

/*
 Choose color from model
 Choose color mode
 dark on light or light on dark
 */
/*
import Cocoa

class PreferencesVC: NSViewController{
    
    //windows preferences ui
    @IBOutlet var floatsCheckBox: NSButton!
    
    //time preferences ui
    @IBOutlet var showSecondsCheckBox: NSButton!
    @IBOutlet var use24HourClockRB: NSButton!
    @IBOutlet var useAMorPMRB: NSButton!
    
    //date prefrences ui
    @IBOutlet var showDateCheckBox: NSButton!
    
    //color preferences ui
    @IBOutlet var colorSchemPopUpButton: NSPopUpButton!
    @IBOutlet var colorSchemPopUpButtonCell: NSPopUpButtonCell!
    @IBOutlet var colorsMenu: NSMenu!
    
    //the controller
    var preferencesController: PreferencesController!
    
    override func viewDidLoad() {
        
        print("PreferencesVC view did load")
        
        preferencesController=PreferencesController(preferencesVC: self)
        
        //set-up view based on new or saved prferences
        preferencesController.setUpView()
        
    }
    
    //window preferences actions
    @IBAction func pressWindowFloatsOnTopCheckBox(button: NSButton){
        preferencesController.setFloatState()
    }
    
    //time preferences actions
    @IBAction func pressShowSecondsCheckBox(button: NSButton){
        preferencesController.changeShowSeconds()
    }
    @IBAction func pressHourModeRB(button: NSButton){
        preferencesController.handleHourModePress(button: button)
    }
    
    //date preferences actions
    @IBAction func pressShowDateCheckBox(button: NSButton){
        preferencesController.changeShowDate()
    }
    @IBAction func restoreDefaults(_ sender: Any) {
        preferencesController.restoreDefaults()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

}
 */
