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
func imageFromView(view: NSView) -> NSImage {
	guard let imageRepresentation = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
			return NSImage()
		}
	view.cacheDisplay(in: view.bounds, to: imageRepresentation)
		guard let cgImage=imageRepresentation.cgImage else {
			return NSImage()
		}
	return NSImage(cgImage: cgImage, size: view.bounds.size)
    }
