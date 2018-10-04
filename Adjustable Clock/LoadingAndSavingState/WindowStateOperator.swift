//
//  SavedWindowState.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 12/21/17.
//  Copyright © 2017 Matt Roberts. All rights reserved.
//

import Cocoa

class WindowStateOperator{
    
    var xPositionKey: String
    var yPositionKey: String
    var widthKey: String
    var heightKey: String
    var minWidth: CGFloat
    var minHeight: CGFloat
    
    init(xPositionKey:String, yPositionKey:String, widthKey:String, heightKey:String,minWidth:CGFloat, minHeight:CGFloat) {
        self.xPositionKey=xPositionKey
        self.yPositionKey=yPositionKey
        self.widthKey=widthKey
        self.heightKey=heightKey
        self.minWidth=minWidth
        self.minHeight=minHeight
    }
    
    func windowSaveOrigin(window: NSWindow?){
        let userDefaults=UserDefaults()
        let savedWindowPosition=window?.frame.origin
        let savedXPosition=savedWindowPosition?.x
        let savedYPosition=savedWindowPosition?.y
        
        //save the values
        userDefaults.set(savedXPosition, forKey: xPositionKey)
        userDefaults.set(savedYPosition, forKey: yPositionKey)
    }
    
    
    func windowLoadOrigin(window: NSWindow?){
        /*
        let fullScreenScreen=NSScreen.main()
        let maxWidth=fullScreenScreen?.frame.width
        let maxHeight=fullScreenScreen?.frame.height
 */
        let userDefaults=UserDefaults()
        
        let savedWindowSize=CGSize(width: userDefaults.integer(forKey: widthKey), height: userDefaults.integer(forKey: heightKey))
        
        //and the window origin
        var savedClockOrigin=CGPoint(x: userDefaults.integer(forKey: xPositionKey), y: userDefaults.integer(forKey: yPositionKey))
        //if it's off screen left, move to edge
        if savedClockOrigin.x<0{
            savedClockOrigin.x=0
        }

        //if it's offscreen bottom, move to edge
        if savedClockOrigin.y<0{
            savedClockOrigin.y=0
        }
        
        let screenWidth=window?.screen?.frame.size.width
        let screenHeight=window?.screen?.frame.size.height
        if !(screenWidth==nil) && !(screenHeight==nil){
            
            //if it's offscreen right, move to edge
            if savedClockOrigin.x>screenWidth!{
                savedClockOrigin.x=screenWidth!-savedWindowSize.width
            }
            if savedClockOrigin.y>screenHeight!{
                savedClockOrigin.y=screenHeight!
            }
        }
        
        //assign the origin
        window?.setFrameOrigin(savedClockOrigin)
    }
 
    
    func windowSaveCGRect(window: NSWindow?){
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
        userDefaults.set(savedXPosition, forKey: xPositionKey)
        userDefaults.set(savedYPosition, forKey: yPositionKey)
        
        
    }
    
    func loadSavedWindowCGRect(window: NSWindow?){
        
        /*
        let fullScreenScreen=NSScreen.main()
        let maxWidth=fullScreenScreen?.frame.width
        let maxHeight=fullScreenScreen?.frame.height
 */
        let userDefaults=UserDefaults()
        
        //get the window size
        var savedWindowSize=CGSize(width: userDefaults.integer(forKey: widthKey), height: userDefaults.integer(forKey: heightKey))
        //and the window origin
        var savedClockOrigin=CGPoint(x: userDefaults.integer(forKey: xPositionKey), y: userDefaults.integer(forKey: yPositionKey))
        //if it's too small in any way, give it a minimum
        if savedWindowSize.width<minWidth{
            savedWindowSize.width=minWidth
            savedWindowSize.height=minHeight
        }
        
        //if it's off screen left, move to edge
        if savedClockOrigin.x<0{
            savedClockOrigin.x=0
        }
        
        //if it's offscreen bottom, move to edge
        if savedClockOrigin.y<0{
            savedClockOrigin.y=0
        }
        
        let screenWidth=window?.screen?.frame.size.width
        let screenHeight=window?.screen?.frame.size.height
        if !(screenWidth==nil) && !(screenHeight==nil){
            //if it's too big in any way, give it a maximum
            if savedWindowSize.width>screenWidth!{
                savedWindowSize.width=screenWidth!
            }
            //if it's offscreen right, move to edge
            if savedClockOrigin.x>screenWidth!{
                savedClockOrigin.x=screenWidth!-savedWindowSize.width
            }
            if savedClockOrigin.y>screenHeight!{
                savedClockOrigin.y=screenHeight!
            }
        }
        print("window width should be "+savedWindowSize.width.description)
        
        //make the rect
        let savedWindow=CGRect(origin: savedClockOrigin, size: savedWindowSize)
        //assign the rect
        window?.setFrame(savedWindow, display: true)
    }
}
