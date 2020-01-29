//
//  NSViewToImage.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/24/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
// credit to Rob for this code snippet (revised by Matt Roberts)
// https://stackoverflow.com/users/1271826/rob
// https://stackoverflow.com/questions/41386423/get-image-from-calayer-or-nsview-swift-3
import AppKit
extension NSView {
    func image() -> NSImage {
		guard let imageRepresentation = bitmapImageRepForCachingDisplay(in: bounds) else {
			return NSImage()
		}
        cacheDisplay(in: bounds, to: imageRepresentation)
		guard let cgImage=imageRepresentation.cgImage else {
			return NSImage()
		}
        return NSImage(cgImage: cgImage, size: bounds.size)
    }
}
