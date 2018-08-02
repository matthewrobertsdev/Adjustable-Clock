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
    
    @IBOutlet weak var animatedTime: NSTextField!
    
    @IBOutlet weak var animatedDayInfo: NSTextField!
    
    var userDefaults=UserDefaults()
    
    let digitalClockModel=DigitalClockModel()

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
        
        // Do any additional setup after loading the view.
        
    }
    
    func updateClockModel(){
        digitalClockModel.updateClockModelForPreferences()
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
        applyColorScheme()
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
        if ClockPreferencesStorage.sharedInstance.fullscreen==false && self.view.window?.isZoomed==false{
            let newWidth=self.view.window?.frame.width
            digitalClockWC.sizeWindowToFitClock(newWidth: newWidth!)
            print("size window normally")
        }
    }
    
    func resizeText(maxWidth: CGFloat){
        if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek{
            
            let projectedTimeHeight=makeTimeMaxSize(maxWidth: maxWidth).height
            let projectedDateHeight=makeDateMaxSize(maxWidth: maxWidth).height
            let projectedHeight=projectedTimeHeight+projectedDateHeight
            
            var newProportion: CGFloat=1
            
            if let maxHeight=self.view.window?.screen?.visibleFrame.height{
                if projectedHeight>maxHeight{
                    newProportion=0.9*(self.view.window?.screen?.visibleFrame.height)!/projectedHeight
                    findFontThatFitsWithLinearSearchV2(label: animatedDayInfo, size: makeDateMaxSize(maxWidth: maxWidth*newProportion))
                    findFontThatFitsWithLinearSearchV2(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth*newProportion))
                }
                else{
                findFontThatFitsWithLinearSearchV2(label: animatedDayInfo, size: makeDateMaxSize(maxWidth: maxWidth))
                findFontThatFitsWithLinearSearchV2(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth))
                }
            }
            else{
                
                findFontThatFitsWithLinearSearchV2(label: animatedDayInfo, size: makeDateMaxSize(maxWidth: maxWidth))
                findFontThatFitsWithLinearSearchV2(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth))
            }
        }
        else{
            let projectedHeight=makeDateMaxSize(maxWidth: (self.view.window?.frame.width)!).height
            var newProportion: CGFloat=1
            if let maxHeight=self.view.window?.screen?.visibleFrame.height{
                if projectedHeight>maxHeight{
                    newProportion=0.9*(self.view.window?.screen?.visibleFrame.height)!/projectedHeight
                    findFontThatFitsWithLinearSearchV2(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth*newProportion))
                }
                else{
                    findFontThatFitsWithLinearSearchV2(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth))
                }
            }
            else{
                findFontThatFitsWithLinearSearchV2(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth))
            }
        }
    }
    
    @objc func updateTime(timer: Timer){
        let timeString=digitalClockModel.getTime()
        if animatedTime?.stringValue != timeString{
            animatedTime?.stringValue=timeString
            
            if !(self.view.window?.frame.width==nil){
                clockLiveResize(maxWidth: (self.view.window?.frame.width)!)
            }
            
        }
    }
    
    @objc func updateTimeAndDayInfo(timer: Timer){
        let timeString=digitalClockModel.getTime()
        if animatedTime?.stringValue != timeString{
            animatedTime?.stringValue=timeString
            animatedDayInfo?.stringValue=digitalClockModel.getDayInfo()
            if !(self.view.window?.frame.width==nil){
                clockLiveResize(maxWidth: (self.view.window?.frame.width)!)
            }
        }
    }
    
    
    func animateTimeAndDayInfo(){
        animatedTime?.stringValue=digitalClockModel.getTime()
        animatedDayInfo?.stringValue=digitalClockModel.getDayInfo()
        updateTimer.invalidate()
        updateTimer = Timer.scheduledTimer(timeInterval: digitalClockModel.updateTime,
                                           target: self,
                                           selector: #selector(updateTimeAndDayInfo(timer:)),
                                           userInfo: nil,
                                           repeats:true)
    }
    
    func animateTime(){
        animatedTime?.stringValue=digitalClockModel.getTime()
        updateTimer.invalidate()
        updateTimer = Timer.scheduledTimer(timeInterval: digitalClockModel.updateTime,
                                           target: self,
                                           selector: #selector(updateTime(timer:)),
                                           userInfo: nil,
                                           repeats:true)
    }
    
    func clockLiveResize(maxWidth: CGFloat){
        if clockStackView.fittingSize.width>maxWidth||clockStackView.fittingSize.width<maxWidth*0.9{
            resizeText(maxWidth: (self.view.window?.frame.width)!)
            
            let digitalClockWC=view.window?.windowController as! DigitalClockWC
            digitalClockWC.sizeWindowToFitClock(newWidth: (self.view.window?.frame.width)!)
            /*
            if clockStackView.fittingSize.width>(self.view.window?.frame.width)!{
                let newWidth=clockStackView.fittingSize.width/0.95
                digitalClockWC.sizeWindowToFitClock(newWidth: newWidth)
            }
            else
            {
                let newWidth=(self.view.window?.frame.width)!
                digitalClockWC.sizeWindowToFitClock(newWidth: newWidth)
            }
 */
        }
    }
    
    func applyColorScheme(){

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
        let maxHeight=maxWidth*digitalClockModel.timeSizeRatio
        return CGSize(width: maxWidth, height: maxHeight)
    }
    
    func makeDateMaxSize(maxWidth: CGFloat)->CGSize{
        let maxHeight=maxWidth*digitalClockModel.dateSizeRatio
        return CGSize(width: maxWidth, height: maxHeight)
    }
    
    deinit {
        if !(tellingTime==nil){
            ProcessInfo().endActivity(tellingTime!)
        }
        updateTimer.invalidate()
    }
}

