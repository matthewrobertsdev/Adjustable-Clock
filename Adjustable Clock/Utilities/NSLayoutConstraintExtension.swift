//
//  NSLayoutConstraintExtension.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/7/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import AppKit
extension NSLayoutConstraint{
func setMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint {

	NSLayoutConstraint.deactivate([self])

	let newConstraint = NSLayoutConstraint(
		item: firstItem!,
		attribute: firstAttribute,
		relatedBy: relation,
		toItem: secondItem,
		attribute: secondAttribute,
		multiplier: multiplier,
		constant: constant)

	newConstraint.priority = priority
	newConstraint.shouldBeArchived = shouldBeArchived
	newConstraint.identifier = identifier

	NSLayoutConstraint.activate([newConstraint])
	return newConstraint
}
}
