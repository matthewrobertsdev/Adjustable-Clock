//
//  WCforSVforClock.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 7/20/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Cocoa

class WCforSVforClock : NSWindowController, NSWindowDelegate{
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.delegate=self
        
    }
    
    func windowWillResize(_ sender: NSWindow,
                          to frameSize: NSSize) -> NSSize{
        
        print("Digital clock window will resize")
        
        let svForClock=window?.contentViewController as! SVforClock
        
        let desiredWidth=frameSize.width*0.95
        let actualWidth=svForClock.stackView.fittingSize.width
        let desiredMagnification=desiredWidth/actualWidth
        svForClock.clockScrollView.magnification=desiredMagnification
        
        let windowWidth=frameSize.width
        let windowHeight=svForClock.stackView.fittingSize.height*desiredMagnification
        window?.aspectRatio=NSSize(width: windowWidth, height: windowHeight)
        
        print(svForClock.clockScrollView.magnification.description)
        print(svForClock.clockScrollView.frame.size.width.description)
        print(svForClock.stackView.frame.size.width)

        return frameSize
    }
    
    
}
