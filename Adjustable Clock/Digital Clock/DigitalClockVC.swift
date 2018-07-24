//
//  ViewController.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//

import Cocoa

//the clock vc
class DigitalClockVC: NSViewController {
    
    @IBOutlet weak var actionImageButton: NSButton!
    
    @IBOutlet weak var actionBackgroundBox: NSBox!
    
    @IBOutlet weak var animatedTime: NSTextField!
    
    @IBOutlet weak var animatedDayInfo: NSTextField!
    
    @IBOutlet weak var centerClockConstraint: NSLayoutConstraint!
    
    var clockAtTopConstraint: NSLayoutConstraint!
    
    var userDefaults=UserDefaults()
    
    let textClockModel=DigitalClockModel()

    @IBOutlet weak var clockStackView: NSStackView!
    
    var findingFontSemaphore=DispatchSemaphore(value: 1)
    
    var tellingTime: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Digital clock view did load")
        
        tellingTime = ProcessInfo().beginActivity(options: [ProcessInfo.ActivityOptions.userInitiated,ProcessInfo.ActivityOptions.latencyCritical], reason: "Need accurate time all the time")
        let nsColorLists=NSColorList.availableColorLists
        for colorList in nsColorLists{
            print("The color list is called"+colorList.name.debugDescription)
        }
        //setClockAtTop()
        /*
        let actionImageTemplate=NSImage(named: NSImageNameActionTemplate)
        
        let actionImage: NSImage!
        
        if #available(OSX 10.13, *) {
            actionImage=actionImageTemplate?.imageWithTintColor(tintColor: NSColor(named: "DarkGray")!)
        } else {
            // Fallback on earlier versions
            actionImage=actionImageTemplate?.imageWithTintColor(tintColor: ClockNSColors.darkGrayNSColor)
        }
        
        actionImageButton.image=actionImage
 */
        
        
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func actionButtonClick(_ sender: Any) {
        
        print("Action button clicked")
        
    }
    
    
    /*
    func updatePreferencesInClockModel(){
        textClockModel.showSeconds=ClockPreferencesStorage.sharedInstance.showSeconds
        textClockModel.use24hourClock=ClockPreferencesStorage.sharedInstance.use24hourClock
        textClockModel.showDate=ClockPreferencesStorage.sharedInstance.showDate
        textClockModel.clockFloats=ClockPreferencesStorage.sharedInstance.clockFloats
        textClockModel.fullscreen=ClockPreferencesStorage.sharedInstance.fullscreen
        textClockModel.color=ClockPreferencesStorage.sharedInstance.colorScheme
    }
 */
    
    func updateClockModel(){
        //updatePreferencesInClockModel()
        textClockModel.updateClockModelForPreferences()
    }
    
    override func viewWillAppear() {
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    var updateTimer=Timer()
    
    func updateClock(){
        updateClockModel()
        applyColorSchemeV2()
        applyFloatState()
        animateClock()
        resizeClock()
    }
    
    func animateClock(){
        if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek{
            clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: animatedDayInfo!)
            animateTimeAndDayInfo()
        }
        else{
            clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: animatedDayInfo!)
            animateTime()
        }
    }
    
    func resizeClock(){
        let windowWidth=view.window?.frame.size.width
        resizeText(maxWidth: windowWidth!)
        let digitalClockWC=view.window?.windowController as! DigitalClockWC
        if ClockPreferencesStorage.sharedInstance.fullscreen==false{
            let newWidth=self.view.window?.frame.width
            digitalClockWC.sizeWindowToFitClock(newWidth: newWidth!)
            print("size window normally")
        }
        else{
            let newFrame=CGRect(origin: NSZeroPoint, size: (self.view.window?.screen?.frame.size)!)
            self.view.window?.setFrame(newFrame, display: true)
            print("size window for full screen")
        }
    }
    
    func resizeText(maxWidth: CGFloat){
        if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek{
            findFontThatFitsWithLinearSearchV2(label: animatedDayInfo, size: makeDateMaxSize(maxWidth: maxWidth))
        }
        findFontThatFitsWithLinearSearchV2(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth))
    }
    
    func resizeTextForScreen(fullWidth: CGFloat){
        resizeText(maxWidth: fullWidth)
        var finalWidth=fullWidth
        var finalHeight=clockStackView.fittingSize.height///0.975 //+18
        let screenWidth=self.view.window?.screen?.frame.size.width
        let screenHeight=self.view.window?.screen?.frame.size.height
        if !(screenWidth==nil) && !(screenHeight==nil){
            while finalWidth>screenWidth!||finalHeight>screenHeight!
            {
                finalWidth*=0.9
                resizeText(maxWidth: finalWidth)
                finalHeight=clockStackView.fittingSize.height//+18
            }
        }
    }
    
    @objc func updateTime(timer: Timer){
        let timeString=textClockModel.getTime()
        if animatedTime?.stringValue != timeString{
            animatedTime?.stringValue=timeString
            
            if !(self.view.window?.frame.width==nil){
                clockLiveResize(maxWidth: (self.view.window?.frame.width)!)
            }
            
        }
    }
    
    @objc func updateTimeAndDayInfo(timer: Timer){
        let timeString=textClockModel.getTime()
        if animatedTime?.stringValue != timeString{
            animatedTime?.stringValue=timeString
            animatedDayInfo?.stringValue=textClockModel.getDayInfo()
            if !(self.view.window?.frame.width==nil){
                clockLiveResize(maxWidth: (self.view.window?.frame.width)!)
            }
        }
    }
    
    
    func animateTimeAndDayInfo(){
        animatedTime?.stringValue=textClockModel.getTime()
        animatedDayInfo?.stringValue=textClockModel.getDayInfo()
        //get the initial time
        //stop the old timer
        updateTimer.invalidate()
        //get new time at given interval
        updateTimer = Timer.scheduledTimer(timeInterval: textClockModel.updateTime,
                                           target: self,
                                           selector: #selector(updateTimeAndDayInfo(timer:)),
                                           userInfo: nil,
                                           repeats:true)
    }
    
    //animate time to seconds
    func animateTime(){
        animatedTime?.stringValue=textClockModel.getTime()
        //get the initial time
        //stop the old timer
        updateTimer.invalidate()
        //get new time at given interval
        updateTimer = Timer.scheduledTimer(timeInterval: textClockModel.updateTime,
                                           target: self,
                                           selector: #selector(updateTime(timer:)),
                                           userInfo: nil,
                                           repeats:true)
    }
    
    func clockLiveResize(maxWidth: CGFloat){
        if clockStackView.fittingSize.width>maxWidth{
            resizeText(maxWidth: (self.view.window?.frame.width)!)
            let digitalClockWC=view.window?.windowController as! DigitalClockWC
            if clockStackView.fittingSize.width>(self.view.window?.frame.width)!{
                let newWidth=clockStackView.fittingSize.width/0.95
                digitalClockWC.sizeWindowToFitClock(newWidth: newWidth)
            }
            else
            {
                let newWidth=(self.view.window?.frame.width)!
                digitalClockWC.sizeWindowToFitClock(newWidth: newWidth)
            }
        }
    }
    
    func applyColorScheme(){
        var colorPair: (NSColor, NSColor)
        if let savedColors=textClockModel.standardColors[textClockModel.color]{
            colorPair=savedColors
        }
        else{
            colorPair=textClockModel.standardColors[ClockNSColors.blackOnMercury]!
        }
        animatedTime.textColor=colorPair.0
        animatedDayInfo.textColor=colorPair.0
        self.view.wantsLayer=true
        self.view.layer?.backgroundColor=colorPair.1.cgColor
    }
    
    
    func applyColorSchemeV2(){
        //self.view.layer?.backgroundColor=CGColor.black
        
        
        var contastingColor: NSColor
        let clockNSColors=ClockNSColors()
        self.view.wantsLayer=true
        if !(ClockPreferencesStorage.sharedInstance.colorChoice==nil){
            print("contasting color is "+ClockPreferencesStorage.sharedInstance.colorChoice)
            if ClockPreferencesStorage.sharedInstance.colorChoice=="custom"{
                contastingColor=ClockPreferencesStorage.sharedInstance.customColor
            }
            else{
                contastingColor=clockNSColors.standardColorsV2[ClockPreferencesStorage.sharedInstance.colorChoice]!
            }
        }
            
        else{
            contastingColor=ClockNSColors.mercuryNSColor
        }
        
        if !ClockPreferencesStorage.sharedInstance.lightOnDark{
            animatedTime.textColor=NSColor.black
            animatedDayInfo.textColor=NSColor.black
            self.view.layer?.backgroundColor=contastingColor.cgColor
        }
        else{
            animatedTime.textColor=contastingColor
            animatedDayInfo.textColor=contastingColor
            self.view.layer?.backgroundColor=CGColor.black
        }
 
    }
 
    
    func applyFloatState(){
        if ClockPreferencesStorage.sharedInstance.clockFloats{
            self.view.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
            self.view.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
        }
        else{
            self.view.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.normalWindow)))
        }
    }
    
    func findFontThatFitsWithLinearSearchV2(label: NSTextField, size: NSSize){
        
        findingFontSemaphore.wait()
        
        label.sizeToFit()
        
        var newWidth=label.frame.width
        
        let desiredWidth=0.95*Double(size.width)
        
        var newHeight=label.frame.height
        
        let desiredHeight=Double(size.height)
        
        var textSize=CGFloat((label.font?.pointSize)!)
        
        //make it big enough
        while((Double(newWidth)-desiredWidth < 2)&&(Double(newHeight)-desiredHeight<2)){
            textSize+=CGFloat(1)
            label.font=NSFont.userFont(ofSize: textSize)
            label.sizeToFit()
            newWidth=label.frame.width
            newHeight=label.frame.height
            Swift.print("textSize has grown to "+textSize.description)
            Swift.print("label width has grown to "+(newWidth.description))
            if(textSize>2000){
                Swift.print("textSize became greater than 2000")
                textSize=2000;
                label.font=NSFont.userFont(ofSize: textSize)
                label.sizeToFit()
                Swift.print("textSize set to 2000")
                break;
            }
        }
        //make it small enough
        while((Double(newWidth)-desiredWidth>2)||(Double(newHeight)-desiredHeight>2)){
            textSize-=CGFloat(1)
            label.font=NSFont.userFont(ofSize: textSize)
            label.sizeToFit()
            newWidth=label.frame.width
            newHeight=label.frame.height
            Swift.print("textSize has decreased to "+textSize.description)
            Swift.print("label width has decreased to "+(newWidth.description))
            if(textSize<2){
                Swift.print("textSize became less than 2")
                textSize=1;
                label.font=NSFont.userFont(ofSize: textSize)
                label.sizeToFit()
                Swift.print("textSize was set to 1")
                break;
            }
            Swift.print("done finding correct size font")
        }
        
        findingFontSemaphore.signal()
        
    }
    
    
    func makeTimeMaxSize(maxWidth: CGFloat)->CGSize{
        //let maxWidth=(view.window?.frame.size.width)!
        let maxHeight=maxWidth*textClockModel.timeSizeRatio
        return CGSize(width: maxWidth, height: maxHeight)
    }
    
    func makeDateMaxSize(maxWidth: CGFloat)->CGSize{
        //let maxWidth=(view.window?.frame.size.width)!
        let maxHeight=maxWidth*textClockModel.dateSizeRatio
        return CGSize(width: maxWidth, height: maxHeight)
    }
    
    /*
    func centerClockVertically(){
        if clockAtTopConstraint != nil{
            clockAtTopConstraint.isActive=false
        }
        centerClockConstraint=NSLayoutConstraint(item: clockStackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        centerClockConstraint.isActive=true
    }
    
    func setClockAtTop(){
        if centerClockConstraint != nil{
            centerClockConstraint.isActive=false
        }
        clockAtTopConstraint=NSLayoutConstraint(item: clockStackView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0)
        clockAtTopConstraint.isActive=true
    }
 */
    deinit {
        if !(tellingTime==nil){
            ProcessInfo().endActivity(tellingTime!)
        }
        updateTimer.invalidate()
    }
}

