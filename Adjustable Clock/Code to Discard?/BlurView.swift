//
//  BlurView.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 8/6/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

/*
import Cocoa

class BlurView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        //wantsLayer=true
        blur()
        // Drawing code here.
    }
    
    func blur() {
        //let blurView=NSView(frame: self.bounds)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        self.layer?.masksToBounds = true
        self.layerUsesCoreImageFilters = true
        self.layer?.needsDisplayOnBoundsChange = true
        
        let satFilter = CIFilter(name: "CIColorControls")
        satFilter?.setDefaults()
        satFilter?.setValue(NSNumber(value: 2.0), forKey: "inputSaturation")
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setDefaults()
        blurFilter?.setValue(NSNumber(value: 2.0), forKey: "inputRadius")
        
        self.layer?.backgroundFilters = [satFilter, blurFilter]
        
        if let blurFilter = CIFilter(name: "CIGaussianBlur",
                                     withInputParameters: [kCIInputRadiusKey: 2]) {
            layer?.filters = [blurFilter]
            print("Background filter applied")
        }
        //self.addSubview(blurView)
        
        layer?.needsDisplay
    }
    
}
*/
