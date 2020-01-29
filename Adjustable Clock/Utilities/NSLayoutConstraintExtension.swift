//
//  NSLayoutConstraintExtension.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/7/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import AppKit
extension NSLayoutConstraint {
	//credit to Andrew Schreiber for this code snippet
	// https://stackoverflow.com/users/2854041/andrew-schreiber
	// https://stackoverflow.com/questions/19593641/can-i-change-multiplier-property-for-nslayoutconstraint
func setMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {

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
