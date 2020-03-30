//
//  CALayerExtension.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//
// credit to CryingHippo for this code snippet
// https://stackoverflow.com/users/4720722/cryinghippo
// https://stackoverflow.com/questions/226354/how-do-you-move-a-calayer-instantly-without-animation
import AppKit
func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
func performAnimationWithDuration(seconds: Double, _ actionsWithAnimation: () -> Void) {
        CATransaction.begin()
		CATransaction.setValue(NSNumber(value: seconds), forKey: kCATransactionAnimationDuration)
        actionsWithAnimation()
        CATransaction.commit()
    }
