//
//  SavedWindowState.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/21/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//
import Cocoa
class WindowFrameRestorer {
    private var xKey: String
    private var yKey: String
    private var widthKey: String
    private var heightKey: String
    private var minWidth: CGFloat
    private var minHeight: CGFloat
	private var maxWidth: CGFloat?
    private var maxHeight: CGFloat?
    init(xKey: String, yKey: String, widthKey: String, heightKey: String,
		 minWidth: CGFloat, minHeight: CGFloat, maxWidth: CGFloat?, maxHeight: CGFloat?) {
        self.xKey=xKey
        self.yKey=yKey
        self.widthKey=widthKey
        self.heightKey=heightKey
        self.minWidth=minWidth
        self.minHeight=minHeight
		self.maxWidth=maxWidth
		self.maxHeight=maxHeight
    }
    func windowSaveCGRect(window: NSWindow?) {
		print("saving")
        let userDefaults=UserDefaults()
        let savedWindowSize=window?.frame.size
        let savedWindowPosition=window?.frame.origin
        //turn into simple values
        let savedWidth=savedWindowSize?.width
        let savedHeight=savedWindowSize?.height
        let savedXPosition=savedWindowPosition?.x
        let savedYPosition=savedWindowPosition?.y
        //save the values
        userDefaults.set(savedWidth, forKey: widthKey)
        userDefaults.set(savedHeight, forKey: heightKey)
        userDefaults.set(savedXPosition, forKey: xKey)
        userDefaults.set(savedYPosition, forKey: yKey)
    }
    func loadSavedWindowCGRect(window: NSWindow?) {
        let userDefaults=UserDefaults()
        //get the window size
		let width=userDefaults.integer(forKey: widthKey)
		let height=userDefaults.integer(forKey: heightKey)
        var savedWindowSize=CGSize(width: width, height: height)
        //and the window origin
		let originX=userDefaults.integer(forKey: xKey)
		let originY=userDefaults.integer(forKey: yKey)
        var savedClockOrigin=CGPoint(x: originX, y: originY)
        //if it's too small in any way, give it a minimum
        if savedWindowSize.width<minWidth {
            savedWindowSize.width=minWidth
        }
		if savedWindowSize.height<minHeight {
			savedWindowSize.height=minHeight
		}
		if let width=maxWidth {
			if savedWindowSize.width>width {
				savedWindowSize.width=width
			}
		}
		if let height=maxHeight {
			if savedWindowSize.height>height {
				savedWindowSize.height=height
			}
		}
        //if it's off screen left, move to edge
        if savedClockOrigin.x<0 {
            savedClockOrigin.x=0
        }
        //if it's offscreen bottom, move to edge
        if savedClockOrigin.y<0 {
            savedClockOrigin.y=0
        }
        if let screenWidth=window?.screen?.frame.size.width {
			if savedClockOrigin.x>screenWidth {
				savedClockOrigin.x=screenWidth-savedWindowSize.width
            }
		}
		if let screenHeight=window?.screen?.frame.size.height {
            if savedClockOrigin.y>screenHeight {
				savedClockOrigin.y=screenHeight-savedWindowSize.height
            }
        }
        //make the rect
        let savedWindow=CGRect(origin: savedClockOrigin, size: savedWindowSize)
        //set the frame
        window?.setFrame(savedWindow, display: true)
    }
}
