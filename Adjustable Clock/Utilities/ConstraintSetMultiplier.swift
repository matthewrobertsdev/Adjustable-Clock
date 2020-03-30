//
//  NSLayoutConstraintExtension.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/7/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
//credit to Andrew Schreiber for this code snippet
// https://stackoverflow.com/users/2854041/andrew-schreiber
// https://stackoverflow.com/questions/19593641/can-i-change-multiplier-property-for-nslayoutconstraint
import AppKit
func setMultiplier(layoutConstraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {

	NSLayoutConstraint.deactivate([layoutConstraint])

	let newConstraint = NSLayoutConstraint(
		item: layoutConstraint.firstItem!,
		attribute: layoutConstraint.firstAttribute,
		relatedBy: layoutConstraint.relation,
		toItem: layoutConstraint.secondItem,
		attribute: layoutConstraint.secondAttribute,
		multiplier: multiplier,
		constant: layoutConstraint.constant)

	newConstraint.priority = layoutConstraint.priority
	newConstraint.shouldBeArchived = layoutConstraint.shouldBeArchived
	newConstraint.identifier = layoutConstraint.identifier

	NSLayoutConstraint.activate([newConstraint])
	return newConstraint
}
