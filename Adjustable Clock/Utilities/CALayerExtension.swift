//
//  CALayerExtension.swift
//  Adjustable Clock
//
//  Created by Matt Roberts on 1/10/20.
//  Copyright © 2020 Celeritas Apps. All rights reserved.
//

import AppKit
extension CALayer {
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void){
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}
