//
//  NSImageTemplateExtension.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 6/22/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
//credit to Satori Maru for this code snippet
// https://gist.github.com/usagimaru/c0a03ef86b5829fb9976b650ec2f1bf4
//changed from extension to global by Matt Roberts
import Cocoa
func imageWithTintColor(image: NSImage, tintColor: NSColor) -> NSImage {
        if image.isTemplate == false {
            return image
        }
		guard let newImage = image.copy() as? NSImage else {
			return NSImage()
		}
        newImage.lockFocus()
        tintColor.set()
        NSMakeRect(0, 0, image.size.width, image.size.height).fill(using: NSCompositingOperation.sourceAtop)
        newImage.unlockFocus()
        newImage.isTemplate = false
        return newImage
    }
    func backgroundWithTintColor(image: NSImage, tintColor: NSColor) -> NSImage {
        if image.isTemplate == false {
            return image
        }
		guard let newImage = image.copy() as? NSImage else {
			return NSImage()
		}
        newImage.lockFocus()
        tintColor.set()
        NSMakeRect(0, 0, image.size.width, image.size.height).fill(using: NSCompositingOperation.sourceOver)
        newImage.unlockFocus()
        newImage.isTemplate = false
        return newImage
    }
func tintExceptBorder(image: NSImage, tintColor: NSColor, borderPixels: CGFloat) -> NSImage {
        if image.isTemplate == false {
            return image
        }
		guard let newImage = image.copy() as? NSImage else {
			return NSImage()
		}
        newImage.lockFocus()
        tintColor.set()
		let sourceOver=NSCompositingOperation.sourceOver
        NSMakeRect(borderPixels, borderPixels, image.size.width-borderPixels*2,
				   image.size.height-borderPixels*2).fill(using: sourceOver)
        newImage.unlockFocus()
        newImage.isTemplate = false
        return newImage
    }
