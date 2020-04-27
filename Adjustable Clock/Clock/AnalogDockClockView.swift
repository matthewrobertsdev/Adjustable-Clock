//
//  DockClockView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/12/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
import Cocoa
class AnalogDockClockView: BaseAnalogClockView {
	var backgroundColor=NSColor.labelColor
	var handsColor=NSColor.labelColor
	var secondsColor=NSColor.labelColor
	var displaySeconds=false
	var calendar=Calendar.autoupdatingCurrent
	var current=true
	var freezeDate=Date()
	var justColors=false
	let notifcationCenter=NotificationCenter.default
	var dark=false {
		didSet {
			if dark {
				notifcationCenter.post(name: NSNotification.Name.didChangToDarkMode, object: nil)
			} else {
				notifcationCenter.post(name: NSNotification.Name.didChangToLightMode, object: nil)
			}
		}
	}
	override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setUp()
    }
	private func setUp() {
	}
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		lineWidth=CGFloat(frame.size.width/25)
		let circle=NSBezierPath(ovalIn: NSRect(origin: CGPoint(x: frame.width/2-lineWidth/2, y: frame.width/2-lineWidth/2), size: CGSize(width: lineWidth, height: lineWidth)))
        let origin=CGPoint(x: bounds.width*0.05, y: bounds.height*0.05)
		let path=NSBezierPath(ovalIn: NSRect(origin: origin, size: CGSize(width: frame.size.width*0.9,
																		  height: frame.size.height*0.9)))
		//var backgroundColorCopy=NSColor.labelColor
		if hasDarkAppearance(view: self) && dark==false {
			dark=true
		} else if !hasDarkAppearance(view: self) && dark==true {
			dark=false
		}
		if ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.custom {
			if !hasDarkAppearance(view: self) ||  ClockPreferencesStorage.sharedInstance.colorForForeground { backgroundColor=ClockPreferencesStorage.sharedInstance.customColor
			} else {
				backgroundColor=ClockPreferencesStorage.sharedInstance.customColor.blended(withFraction: 0.4, of: NSColor.black) ?? NSColor.systemGray
			}
		} else if hasDarkAppearance(view: self) && !ClockPreferencesStorage.sharedInstance.colorForForeground {
		 backgroundColor=ColorModel.sharedInstance.darkColorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice]
			?? NSColor.systemGray
		} else {
			backgroundColor=ColorModel.sharedInstance.lightColorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice]
				?? NSColor.systemGray
			if backgroundColor==NSColor.black {
				backgroundColor=NSColor.systemGray
			}
		}
		if hasDarkAppearance(view: self) {
			backgroundColor.setFill()
			handsColor=NSColor.white
			if ClockPreferencesStorage.sharedInstance.colorForForeground {
				color=NSColor.black
				secondsColor=NSColor.white
			} else {
				color=ColorModel.sharedInstance.lightColorsDictionary[ClockPreferencesStorage.sharedInstance.colorChoice] ??
					ClockPreferencesStorage.sharedInstance.customColor.blended(withFraction: 0.2, of: NSColor.white)  ?? NSColor.black
				secondsColor=NSColor.black
			}
		} else if !hasDarkAppearance(view: self) {
			handsColor=NSColor.black
			color=NSColor.white
			secondsColor=NSColor.white
			backgroundColor.setFill()
		} else {
			handsColor=NSColor.white
			backgroundColor=NSColor.black
			backgroundColor.setFill()
		}
		if ClockPreferencesStorage.sharedInstance.colorForForeground {
			handsColor=NSColor.black
			color=NSColor.white
			secondsColor=NSColor.black
			backgroundColor.setFill()
		}
		if hasDarkAppearance(view: self) &&  (ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.systemColor ||
			ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.black) {
			color=NSColor.systemGray
			secondsColor=NSColor.systemGray
		} else if hasDarkAppearance(view: self) &&
		ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.white {
			handsColor=NSColor.black
			color=NSColor.systemGray
			secondsColor=NSColor.systemGray
		} else if hasDarkAppearance(view: self) &&
		ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.gray {
			handsColor=NSColor.white
			secondsColor=NSColor.black
			color=NSColor.systemGray
		} else if !hasDarkAppearance(view: self) && backgroundColor==NSColor.black {
			secondsColor=NSColor.systemGray
			color=NSColor.systemGray
		}
		if !hasDarkAppearance(view: self) &&  (ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.systemColor ||
			ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.white) {
			color=NSColor.systemGray
			secondsColor=NSColor.systemGray
		} else if !hasDarkAppearance(view: self) &&
			ClockPreferencesStorage.sharedInstance.colorChoice==ColorChoice.gray {
			color=NSColor.white
			secondsColor=NSColor.white
		}
		path.fill()
		handsColor.setFill()
		secondsColor.setFill()
		circle.fill()
		guard let cgContext=NSGraphicsContext.current?.cgContext else {
				return
		}
		for hour in 1...12 {
			drawDash(cgContext: cgContext, angle: CGFloat(2*Double.pi*Double(hour)/Double(12)),
					 start: 0.3, startProportion: 0, end: 0.4)
		}
		if displaySeconds {
			displayHandsWithSeconds()
		} else {
			displayeHandsNoSeconds()
		}
    }
	private func displayHandsWithSeconds() {
		let time=current ? Date() : freezeDate
		let hour=calendar.dateComponents([.hour], from: time).hour ?? 0
		let minute=calendar.dateComponents([.minute], from: time).minute ?? 0
		let second=calendar.dateComponents([.second], from: time).second ?? 0
		let totalSeconds=(Double(hour)*3600.0+Double(minute)*60.0+Double(second))
		displayHand(radians: -2*CGFloat.pi*CGFloat(totalSeconds/43200.0)+CGFloat.pi/2, endProportion: 0.3, relativeWidth: 1.2, color: handsColor)
		displayHand(radians: -CGFloat.pi*CGFloat(minute)/30+CGFloat.pi/2, endProportion: 0.4, relativeWidth: 1.2, color: handsColor)
		displayHand(radians: -CGFloat.pi*CGFloat(second)/30+CGFloat.pi/2, endProportion: 0.4, relativeWidth: 1, color: secondsColor)
	}
	private func displayeHandsNoSeconds() {
		let time=current ? Date() : freezeDate
		let hour=calendar.dateComponents([.hour], from: time).hour ?? 0
		let minute=calendar.dateComponents([.minute], from: time).minute ?? 0
		let second=calendar.dateComponents([.second], from: time).second ?? 0
		let totalSeconds=(Double(hour)*3600.0+Double(minute)*60.0+Double(second))
		displayHand(radians: -2*CGFloat.pi*CGFloat(totalSeconds/43200.0)+CGFloat.pi/2, endProportion: 0.3, relativeWidth: 1.2, color: handsColor)
		displayHand(radians: -CGFloat.pi*CGFloat(minute)/30+CGFloat.pi/2, endProportion: 0.4, relativeWidth: 1.2, color: handsColor)
	}
	private func displayHand(radians: CGFloat, endProportion: CGFloat, relativeWidth: CGFloat, color: NSColor) {
		guard let cgContext=NSGraphicsContext.current?.cgContext else {
				return
		}
		let line = CGMutablePath()
		let xStart=frame.width/2
		let yStart=frame.height/2
		line.move(to: CGPoint(x: xStart, y: yStart))
		let xEnd=cos(radians)*frame.size.width*endProportion+frame.width/2
		let yEnd=sin(radians)*frame.size.height*endProportion+frame.width/2
		line.addLine(to: CGPoint(x: xEnd, y: yEnd))
		line.closeSubpath()
		cgContext.addPath(line)
		cgContext.setStrokeColor(color.cgColor)
		cgContext.setLineWidth(lineWidth*relativeWidth)
		cgContext.setLineCap(.round)
		cgContext.strokePath()
	}
}
