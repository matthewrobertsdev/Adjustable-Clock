//
//  ViewController.swift
//  Digital Clock
//
//  Created by Matt Roberts on 7/14/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class DigitalClockViewController: NSViewController {
    @IBOutlet weak var animatedTime: NSTextField!
    @IBOutlet weak var animatedDayInfo: NSTextField!
    @IBOutlet weak var clockStackView: NSStackView!
	@IBOutlet weak var visualEffectView: NSVisualEffectView!
    let digitalClockModel=DigitalClockModel()
    var findingFontSemaphore=DispatchSemaphore(value: 1)
    var tellingTime: NSObjectProtocol?
	var updateTimer: DispatchSourceTimer?
    let workspaceNotifcationCenter=NSWorkspace.shared.notificationCenter
	func displayForDock() {
		guard let timer=updateTimer else {
			return
		}
		timer.cancel()
		self.animatedTime.stringValue=digitalClockModel.dockTimeString
		self.animatedDayInfo.stringValue=digitalClockModel.dockDateString
	}
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSleepObserver =
			workspaceNotifcationCenter.addObserver(forName:
			NSWorkspace.screensDidSleepNotification, object: nil, queue: nil) { (_) in
			guard let timer=self.updateTimer else {
				return
			}
			timer.cancel()
            self.updateTimer=nil
            self.animatedTime.stringValue="Relaunch To Resume"
            self.animatedDayInfo.stringValue=""
            self.resizeText(maxWidth: (self.view.window?.frame.width)!)
        }
        let screenWakeObserver =
			workspaceNotifcationCenter.addObserver(forName:
			NSWorkspace.screensDidWakeNotification, object: nil, queue: nil) { (_) in
            self.animateClock()
			guard let windowWidth=self.view.window?.frame.width else {
				return
			}
            self.resizeText(maxWidth: windowWidth)
        }
		let processOptions: ProcessInfo.ActivityOptions=[ProcessInfo.ActivityOptions.userInitiatedAllowingIdleSystemSleep]
        tellingTime = ProcessInfo().beginActivity(options: processOptions, reason: "Need accurate time all the time")
		let notifier=DistributedNotificationCenter.default
		let colorChangeNotification=NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification")
		let colorChangeObserver =
			notifier.addObserver(self, selector:
				#selector(applyColors(sender:)), name: colorChangeNotification, object: nil)
    }
    func updateClockModel() {
		digitalClockModel.updateClockModelForPreferences()
    }
    func updateClock() {
        updateClockModel()
		applyColorScheme()
        applyFloatState()
        animateClock()
        resizeClock()
    }
    func animateClock() {
        if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
			clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: animatedDayInfo!)
            animateTimeAndDayInfo()
        } else {
            clockStackView.setVisibilityPriority(NSStackView.VisibilityPriority.notVisible, for: animatedDayInfo!)
            animateTime()
        }
    }
    func resizeClock() {
        let windowWidth=view.window?.frame.size.width
        resizeText(maxWidth: windowWidth!)
		guard let digitalClockWC=view.window?.windowController as? DigitalClockWindowController else {
			return
		}
        if ClockPreferencesStorage.sharedInstance.fullscreen==false && self.view.window?.isZoomed==false {
			if let newWidth=self.view.window?.frame.width {
				digitalClockWC.sizeWindowToFitClock(newWidth: newWidth)
			}
        }
    }
    func resizeText(maxWidth: CGFloat) {
        findingFontSemaphore.wait()
        if ClockPreferencesStorage.sharedInstance.showDate||ClockPreferencesStorage.sharedInstance.showDayOfWeek {
            let projectedTimeHeight=makeTimeMaxSize(maxWidth: maxWidth).height
            let projectedDateHeight=makeDateMaxSize(maxWidth: maxWidth).height
            let projectedHeight=projectedTimeHeight+projectedDateHeight
            var newProportion: CGFloat=1
            if let maxHeight=self.view.window?.screen?.visibleFrame.height {
                if projectedHeight>maxHeight {
                    newProportion=(self.view.window?.screen?.visibleFrame.height)!/projectedHeight
                    findFittingFont(label: animatedDayInfo, size: makeDateMaxSize(maxWidth: maxWidth*newProportion))
                    findFittingFont(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth*newProportion))
                } else {
                findFittingFont(label: animatedDayInfo, size: makeDateMaxSize(maxWidth: maxWidth))
                findFittingFont(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth))
                }
            } else {
				findFittingFont(label: animatedDayInfo, size: makeDateMaxSize(maxWidth: maxWidth))
                findFittingFont(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth))
            }
        } else {
            let projectedHeight=makeDateMaxSize(maxWidth: (self.view.window?.frame.width)!).height
            var newProportion: CGFloat=1
            if let maxHeight=self.view.window?.screen?.visibleFrame.height {
                if projectedHeight>maxHeight {
                    newProportion=(self.view.window?.screen?.visibleFrame.height)!/projectedHeight
                    findFittingFont(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth*newProportion))
                } else {
                    findFittingFont(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth))
                }
            } else {
                findFittingFont(label: animatedTime, size: makeTimeMaxSize(maxWidth: maxWidth))
            }
        }
        findingFontSemaphore.signal()
    }
    func updateTime() {
        let timeString=digitalClockModel.getTime()
        if animatedTime?.stringValue != timeString {
            animatedTime?.stringValue=timeString
            if !(self.view.window?.frame.width==nil) {
                clockLiveResize(maxWidth: (self.view.window?.frame.width)!)
            }
        }
    }
    func updateTimeAndDayInfo() {
        let timeString=digitalClockModel.getTime()
        if animatedTime?.stringValue != timeString {
            animatedTime?.stringValue=timeString
            let dayInfo=digitalClockModel.getDayInfo()
                animatedDayInfo?.stringValue=dayInfo
			guard let windowWidth=self.view.window?.frame.width else {
				return
			}
                clockLiveResize(maxWidth: windowWidth)
        }
    }
    func animateTimeAndDayInfo() {
        animatedTime?.stringValue=digitalClockModel.getTime()
        animatedDayInfo?.stringValue=digitalClockModel.getDayInfo()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		guard let timer=updateTimer else {
			return
		}
		timer.schedule(deadline: .now(), repeating: .milliseconds(digitalClockModel.updateTime), leeway: .milliseconds(10))
		timer.setEventHandler {
                self.updateTimeAndDayInfo()
        }
        timer.resume()
    }
    func animateTime() {
		animatedTime?.stringValue=digitalClockModel.getTime()
		self.updateTimer=DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		guard let timer=updateTimer else {
			return
		}
		timer.schedule(deadline: .now(), repeating: .milliseconds(digitalClockModel.updateTime), leeway: .milliseconds(10))
        timer.setEventHandler {
                self.updateTime()
        }
        timer.resume()
    }
    func clockLiveResize(maxWidth: CGFloat) {
        animatedDayInfo.sizeToFit()
		guard let window=self.view.window else {
			return
		}
		let maxHeight=maxWidth*digitalClockModel.dateSizeRatio*0.9
        if !window.inLiveResize &&  ((clockStackView.fittingSize.width>maxWidth)||((animatedDayInfo.frame.width<maxWidth*0.9)&&(animatedDayInfo.frame.height<maxHeight))) {
			resizeText(maxWidth: window.frame.size.width)
            if !window.isZoomed && ClockPreferencesStorage.sharedInstance.fullscreen==false {
				guard let digitalClockWC=view.window?.windowController as? DigitalClockWindowController else {
					return
				}
				digitalClockWC.sizeWindowToFitClock(newWidth: (self.view.window?.frame.width)!)
            }
        }
    }
	@objc func applyColors(sender: NSNotification) {
		applyColorScheme()
	}
	func applyColorScheme() {
        var contrastColor: NSColor
        let clockNSColors=ColorDictionary()
                self.view.window?.isOpaque=false
        self.view.wantsLayer=true
            if ClockPreferencesStorage.sharedInstance.colorChoice=="custom"{
                contrastColor=ClockPreferencesStorage.sharedInstance.customColor
            } else {
				contrastColor =
					clockNSColors.colorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ?? NSColor.systemGray
            }
        if !ClockPreferencesStorage.sharedInstance.colorForForeground {
			visualEffectView.isHidden=true
			animatedTime.textColor=NSColor.labelColor
			animatedDayInfo.textColor=NSColor.labelColor
			if #available(OSX 10.14, *) {
				if let uiName=NSApp?.effectiveAppearance.name {
					//dark mode
					if uiName==NSAppearance.Name.darkAqua||uiName==NSAppearance.Name.accessibilityHighContrastDarkAqua||uiName==NSAppearance.Name.accessibilityHighContrastVibrantDark {
						if contrastColor==NSColor.white {
							contrastColor=NSColor.systemGray
						}
						//light mode
					} else {
						if contrastColor==NSColor.black {
							contrastColor=NSColor.systemGray
						}
					}
					} else {
						if contrastColor==NSColor.black {
							contrastColor=NSColor.systemGray
						}
					}
				} else {
				// Fallback on earlier versions
			}
		self.view.layer?.backgroundColor=contrastColor.cgColor
		animatedDayInfo.backgroundColor=contrastColor
	} else {
			visualEffectView.isHidden=false
			animatedTime.textColor=contrastColor
			animatedDayInfo.textColor=contrastColor
	self.view.layer?.backgroundColor = NSColor.labelColor.cgColor/*NSColor.clear.cgColor*/
		}
    }
    func applyFloatState() {
        if ClockPreferencesStorage.sharedInstance.clockFloats {
            self.view.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
            self.view.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow))-1)
        } else {
            self.view.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.normalWindow)))
        }
    }
	func makeNormalWindowLevel() {
		self.view.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.normalWindow)))
	}
    func findFittingFont(label: NSTextField, size: NSSize) {
        label.sizeToFit()
        var newWidth=label.frame.width
        let desiredWidth=0.95*Double(size.width)
        var newHeight=label.frame.height
        let desiredHeight=Double(size.height)
        var textSize=CGFloat((label.font?.pointSize)!)
        //make it big enough
        while (Double(newWidth)-desiredWidth < 2)&&(Double(newHeight)-desiredHeight<2) {
            textSize+=CGFloat(1)
            label.font=NSFont.userFont(ofSize: textSize)
            label.sizeToFit()
            newWidth=label.frame.width
            newHeight=label.frame.height
            if textSize>2000 {
                textSize=2000
                label.font=NSFont.userFont(ofSize: textSize)
                label.sizeToFit()
                break
            }
        }
        //make it small enough
		while (Double(newWidth)-desiredWidth>2)||(Double(newHeight)-desiredHeight>2) {
            textSize-=CGFloat(1)
            label.font=NSFont.userFont(ofSize: textSize)
            label.sizeToFit()
            newWidth=label.frame.width
            newHeight=label.frame.height
            if textSize<2 {
                textSize=1
                label.font=NSFont.userFont(ofSize: textSize)
                label.sizeToFit()
                break
            }
        }
    }
    func makeTimeMaxSize(maxWidth: CGFloat) -> CGSize {
        let maxHeight=maxWidth*digitalClockModel.timeSizeRatio
        return CGSize(width: maxWidth, height: maxHeight)
    }
    func makeDateMaxSize(maxWidth: CGFloat) -> CGSize {
        let maxHeight=maxWidth*digitalClockModel.dateSizeRatio
        return CGSize(width: maxWidth, height: maxHeight)
    }
    deinit {
		if let timeActivity=tellingTime {
			ProcessInfo().endActivity(timeActivity)
		}
		if let timer=updateTimer {
			timer.cancel()
		}
    }
}
