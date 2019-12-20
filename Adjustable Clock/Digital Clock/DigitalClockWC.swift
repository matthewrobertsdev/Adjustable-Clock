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
        let digitalClockVC=window?.contentViewController as! DigitalClockVC
        backgroundView=digitalClockVC.view
        //setMaxSize()
        setMinSize()
        let userDefaults=UserDefaults()
        let hasLaunchedBefore=userDefaults.bool(forKey: AppUserDefaults.applicationHasLaunched)
        
        ClockPreferencesStorage.sharedInstance.loadUserPreferences()
        
        if hasLaunchedBefore{
			ClockWindowRestorer().loadSavedWindowCGRect(window: window)
        }
        userDefaults.set(true, forKey: AppUserDefaults.applicationHasLaunched)
        digitalClockVC.updateClock()
		if let windowSize=window?.frame.size{
			window?.aspectRatio=windowSize
		}
        setTrackingArea()
        window?.isMovableByWindowBackground=true
        window?.delegate=self
		if(!ClockPreferencesStorage.sharedInstance.fullscreen){
            showButtons(show: false)
            flashButtons()
        }
        else{
            showButtons(show: true)
        }
        enableClockMenu(enabled: true)
        updateClockMenuUI()
        window?.isOpaque=false
    }
    func setTrackingArea(){
        let rect=backgroundView.frame
        trackingArea=NSTrackingArea(rect: rect, options: [NSTrackingArea.Options.activeInKeyWindow,NSTrackingArea.Options.inVisibleRect,NSTrackingArea.Options.mouseMoved],owner: backgroundView.window, userInfo: nil)
        backgroundView.addTrackingArea(trackingArea)
    }
    func sizeWindowToFitClock(newWidth: CGFloat){
		guard let digitalClockVC=window?.contentViewController as? DigitalClockVC else {
			return
		}
        let oldWidth=window?.frame.width
        let finalHeight=digitalClockVC.clockStackView.fittingSize.height
        let newSize=NSSize(width: newWidth, height: finalHeight)
        let oldHeight=window?.frame.height
        let changeInHeight=finalHeight-oldHeight!
        let changeInWidth=newWidth-oldWidth!
		guard let windowOrigin=window?.frame.origin else {
			return
		}
        let newOrigin=CGPoint(x: windowOrigin.x-changeInWidth, y: windowOrigin.y-changeInHeight)
        let newRect=NSRect(origin: newOrigin, size: newSize)
        window?.setFrame(newRect, display: true)
    }
    func windowDidBecomeKey(_ notification: Notification) {
		flashButtons()
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
        
		guard let digitalClockVC=window?.contentViewController as? DigitalClockVC else {
			return
		}
        
        digitalClockVC.resizeClock()
    }
    
    func windowDidResize(_ notification: Notification) {
        
		guard let digitalClockVC=window?.contentViewController as? DigitalClockVC else {
			return
		}
        
        digitalClockVC.resizeText(maxWidth: (window?.frame.width)!)
		guard let windowIsZoomed=window?.isZoomed else {
			return
		}
        if !windowIsZoomed && ClockPreferencesStorage.sharedInstance.fullscreen==false{
            let newWidth=(window?.frame.width)!
            let newHeight=digitalClockVC.clockStackView.fittingSize.height
            let newAspectRatio=NSSize(width: newWidth, height: newHeight)
            window?.aspectRatio=newAspectRatio
            showButtons(show: false)
        }
        else{
            showButtons(show: true)
        }
    }
    func windowWillClose(_ notification: Notification) {
        enableClockMenu(enabled: false)
        let appObject = NSApp as NSApplication
        appObject.terminate(self)
    }
    func windowWillEnterFullScreen(_ notification: Notification) {
		//save for exit fullscreen
        saveState()
        ClockPreferencesStorage.sharedInstance.fullscreen=true
        
		guard let digitalClockVC=window?.contentViewController as? DigitalClockVC else {
			return
		}
		guard let windowSize=window?.screen?.frame.size else {
			return
		}
        digitalClockVC.resizeText(maxWidth: windowSize.width)
    }
    //if entered fullscreen
    func windowDidEnterFullScreen(_ notification: Notification) {
        removeTrackingArea()
        hideButtonsTimer?.invalidate()
        updateClockMenuUI()
        reloadPreferencesWindowIfOpen()
        window?.makeKey()
        showButtons(show: true)
    }
    
    func windowWillExitFullScreen(_ notification: Notification) {
		ClockPreferencesStorage.sharedInstance.fullscreen=false
        let userDefaults=UserDefaults()
        let maxWidth=CGFloat(userDefaults.integer(forKey: AppUserDefaults.clockWidthKey))
		guard let digitalClockVC=window?.contentViewController as? DigitalClockVC else {
			return
		}
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
        showButtons(show: false)
        
    }
    func windowWillUseStandardFrame(_ window: NSWindow,
                                    defaultFrame newFrame: NSRect) -> NSRect{
		return newFrame
        //return (window.screen?.visibleFrame)!
    }
    func setMaxSize(){
		guard let screenSize=window?.screen else {
			return
		}
		window?.maxSize=screenSize.frame.size
    }
    func setMinSize(){
        window?.minSize=CGSize(width: 100, height: 1)
    }
    func updateClockMenuUI(){
        let appObject = NSApp as NSApplication
		if let mainMenu=appObject.mainMenu as? MainMenu{
			mainMenu.updateClockMenuUI()
		}
    }
    func enableClockMenu(enabled: Bool){
        let appObject = NSApp as NSApplication
		if let mainMenu=appObject.mainMenu as? MainMenu{
			mainMenu.enableClockMenuPreferences(enabled: enabled)
		}
    }
    
    func flashButtons(){
        showButtons(show: true)
        hideButtonsTimer?.invalidate()
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
        ClockWindowRestorer().windowSaveCGRect(window: window)
        //mark application as has launched
        userDefaults.set(true, forKey: "applicationHasLaunched")
        
    }
    func removeTrackingArea(){
        backgroundView.removeTrackingArea(trackingArea)
    }
    func reloadPreferencesWindowIfOpen(){
        let appObject = NSApp as NSApplication
		guard let mainMenu=appObject.mainMenu as? MainMenu else {
			return
		}
		if isThereAPreferencesWindow() {
			mainMenu.showSimplePreferencesWindow()
		}
    }
    
}
