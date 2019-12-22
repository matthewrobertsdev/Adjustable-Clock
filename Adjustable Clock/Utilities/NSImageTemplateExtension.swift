//
//  NSImageTemplateExtension.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 6/22/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import Cocoa
extension NSImage {
    func imageWithTintColor(tintColor: NSColor) -> NSImage {
        if self.isTemplate == false {
            return self
        }
        let image = self.copy() as! NSImage
        image.lockFocus()
        tintColor.set()
        NSMakeRect(0, 0, image.size.width, image.size.height).fill(using: NSCompositingOperation.sourceAtop)
        image.unlockFocus()
        image.isTemplate = false
        return image
    }
    func backgroundWithTintColor(tintColor: NSColor) -> NSImage {
        if self.isTemplate == false {
            return self
        }
        let image = self.copy() as! NSImage
        image.lockFocus()
        tintColor.set()
        NSMakeRect(0, 0, image.size.width, image.size.height).fill(using: NSCompositingOperation.sourceOver)
        image.unlockFocus()
        image.isTemplate = false
        return image
    }
    func tintExceptBorder(tintColor: NSColor, borderPixels: CGFloat) -> NSImage{
        if self.isTemplate == false {
            return self
        }
        let image = self.copy() as! NSImage
        image.lockFocus()
        tintColor.set()
        NSMakeRect(borderPixels, borderPixels, image.size.width-borderPixels*2, image.size.height-borderPixels*2).fill(using: NSCompositingOperation.sourceOver)
        image.unlockFocus()
        image.isTemplate = false
        return image
    }
}
