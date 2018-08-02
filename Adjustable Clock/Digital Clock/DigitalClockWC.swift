//
//  DigitalClockWC.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//

import Cocoa

class DigitalClockWC : NSWindowController, NSWindowDelegate{
    
    var hideButtonsTimer: Timer?
    
    var backgroundView: NSView!
    
    var trackingArea: NSTrackingArea!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        print("Digital clock window did load")

        let digitalClockVC=window?.contentViewController as! DigitalClockVC
        backgroundView=digitalClockVC.view
        //setMaxSize()
        setMinSize()
        
        let userDefaults=UserDefaults()
        
        let hasLaunchedBefore=userDefaults.bool(forKey: AppUserDefaults.applicationHasLaunched)
        
        ClockPreferencesStorage.sharedInstance.loadUserPreferences()
        
        if hasLaunchedBefore{
            let clockWindowStateOperator=ClockWindowStateOperator()
            clockWindowStateOperator.loadSavedWindowCGRect(window: window)
        }
        
        userDefaults.set(true, forKey: AppUserDefaults.applicationHasLaunched)
        
        digitalClockVC.updateClock()
        
        window?.aspectRatio=(window?.frame.size)!
        
        setTrackingArea()
        
        window?.isMovableByWindowBackground=true
        window?.delegate=self
        
        if(!ClockPreferencesStorage.sharedInstance.fullscreen){
            flashButtons()
        }
        
        enableClockMenu(enabled: true)
        updateClockMenuUI()
    }
    
    func setTrackingArea(){
        let rect=backgroundView.frame
        trackingArea=NSTrackingArea(rect: rect, options: [NSTrackingArea.Options.activeInKeyWindow,NSTrackingArea.Options.inVisibleRect,NSTrackingArea.Options.mouseMoved],owner: backgroundView.window, userInfo: nil)
        backgroundView.addTrackingArea(trackingArea)
    }
    
    func removeTrackingArea(){
        backgroundView.removeTrackingArea(trackingArea)
    }
    
    func sizeWindowToFitClock(newWidth: CGFloat){
        let digitalClockVC=window?.contentViewController as! DigitalClockVC
        let oldWidth=window?.frame.width
        let finalHeight=digitalClockVC.clockStackView.fittingSize.height
        /*
        let screenWidth=window?.screen?.frame.size.width
        let screenHeight=window?.screen?.frame.size.height
        if !(screenWidth==nil) && !(screenHeight==nil){
            while finalWidth>screenWidth!||finalHeight>screenHeight!
            {
                finalWidth*=0.9
                digitalClockVC.resizeText(maxWidth: finalWidth)
                finalHeight=digitalClockVC.clockStackView.fittingSize.height//+18
            }
        }
 */
        let newSize=NSSize(width: newWidth, height: finalHeight)
        let oldHeight=window?.frame.height
        let changeInHeight=finalHeight-oldHeight!
        let changeInWidth=newWidth-oldWidth!
        let newOrigin=CGPoint(x: (window?.frame.origin.x)!-changeInWidth, y: (window?.frame.origin.y)!-changeInHeight)
        let newRect=NSRect(origin: newOrigin, size: newSize)
        window?.setFrame(newRect, display: true)
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        
    }
    
    func windowDidResignKey(_ notification: Notification) {
        if(!ClockPreferencesStorage.sharedInstance.fullscreen){
            showButtons(show: false)
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        flashButtons()
    }
    
    func windowDidEndLiveResize(_ notification: Notification) {
        print("window did end live resize")
        
        let digitalClockVC=window?.contentViewController as! DigitalClockVC
        
        digitalClockVC.resizeClock()
    }
    
    func windowDidResize(_ notification: Notification) {
        print("Digital clock window will resize")
        
        let digitalClockVC=window?.contentViewController as! DigitalClockVC
        
        digitalClockVC.resizeText(maxWidth: (window?.frame.width)!)
        
        if !(window?.isZoomed)!{
            let newWidth=(window?.frame.width)!
            let newHeight=digitalClockVC.clockStackView.fittingSize.height
            let newAspectRatio=NSSize(width: newWidth, height: newHeight)
            window?.aspectRatio=newAspectRatio
        }
        
    }
    
    //when closing, if appropraite save state
    func windowWillClose(_ notification: Notification) {
        enableClockMenu(enabled: false)
        let appObject = NSApp as NSApplication
        appObject.terminate(self)
    }
 
    
    //if entering fullscreen
    func windowWillEnterFullScreen(_ notification: Notification) {

        saveState()
        
        ClockPreferencesStorage.sharedInstance.fullscreen=true
        
        let digitalClockVC=window?.contentViewController as! DigitalClockVC
        
        digitalClockVC.resizeText(maxWidth: (window?.screen?.frame.size)!.width)
    }
    
    //if entered fullscreen
    func windowDidEnterFullScreen(_ notification: Notification) {
        
        removeTrackingArea()
        hideButtonsTimer?.invalidate()
        showButtons(show: true)
        
        updateClockMenuUI()
        reloadPreferencesWindowIfOpen()
        
        window?.makeKey()
    }
    
    func windowWillExitFullScreen(_ notification: Notification) {
        ClockPreferencesStorage.sharedInstance.fullscreen=false
        let userDefaults=UserDefaults()
        let maxWidth=CGFloat(userDefaults.integer(forKey: AppUserDefaults.clockWidthKey))
        let digitalClockVC=window?.contentViewController as! DigitalClockVC
        digitalClockVC.resizeText(maxWidth: maxWidth)
    }
    
    func windowDidExitFullScreen(_ notification: Notification) {
        
        setTrackingArea()
        window?.makeKey()
        flashButtons()
        
        updateClockMenuUI()
        reloadPreferencesWindowIfOpen()
        
        sizeWindowToFitClock(newWidth: (window?.frame.width)!)
        window?.aspectRatio=(window?.frame.size)!
        
    }
    
    func windowWillUseStandardFrame(_ window: NSWindow,
                                    defaultFrame newFrame: NSRect) -> NSRect{
        print("window will use standard frame")
        
        return (window.screen?.visibleFrame)!
    }
    
    /*
    func setMaxSize(){
        
        let currentScreen=window?.screen
        if currentScreen==nil{
            
        }
        else{
            window?.maxSize=(currentScreen?.frame.size)!
        }
        
    }
 */
    
    func setMinSize(){
        window?.minSize=CGSize(width: 100, height: 1)
    }
    
    func updatePreferencesUI(){
        let appObject = NSApp as NSApplication
        for window in appObject.windows{
            //if window is found
            if window.identifier==UserInterfaceIdentifier.prefrencesWindow{
                let preferencesVC=window.contentViewController as! PreferencesVC
                preferencesVC.preferencesController.updatePreferencesUI()
            }
        }
    }
    
    func updateClockMenuUI(){
        let appObject = NSApp as NSApplication
        let mainMenu=appObject.mainMenu as! AdjustableClockMenu
        mainMenu.updateClockMenuUI()
    }
    
    func enableClockMenu(enabled: Bool){
        let appObject = NSApp as NSApplication
        let mainMenu=appObject.mainMenu as! AdjustableClockMenu
        mainMenu.enableClockMenuPreferences(enabled: enabled)
    }
    
    func flashButtons(){
        showButtons(show: true)
        hideButtonsTimer?.invalidate()
        //get new time every second
        hideButtonsTimer = Timer.scheduledTimer(timeInterval: 1,
                                                target: self,
                                                selector: #selector(hideButtons(timer:)),
                                                userInfo: nil,
                                                repeats:false)
    }
    
    @objc func hideButtons(timer: Timer){
        if(!ClockPreferencesStorage.sharedInstance.fullscreen){
            showButtons(show: false)
        }
    }
    
    func showButtons(show: Bool){

        self.window?.standardWindowButton(.closeButton)?.isHidden=(!show)
        self.window?.standardWindowButton(.zoomButton)?.isHidden=(!show)
        self.window?.standardWindowButton(.miniaturizeButton)?.isHidden=(!show)
        
    }
    
    func saveState(){
        let userDefaults=UserDefaults()
        //save window
        let clockWindowStateOperator=ClockWindowStateOperator()
        clockWindowStateOperator.windowSaveCGRect(window: window)
        //mark application as has launched
        userDefaults.set(true, forKey: "applicationHasLaunched")
        
    }
    
    func reloadPreferencesWindowIfOpen(){
        let appObject = NSApp as NSApplication
        let mainMenu=appObject.mainMenu as! AdjustableClockMenu
        mainMenu.reloadPreferencesWindowIfOpen()
    }

}
