//
//  Dispathc.swift
//  Renfe trains checker
//
//  Created by José Estela on 4/12/17.
//  Copyright © 2017 jcarlosestela. All rights reserved.
//

import Foundation
import Dispatch

func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.global().asyncAfter(
        deadline: DispatchTime.now() + delay, execute: closure
    )
}

func async(closure: @escaping () -> Void) {
    delay(0, closure: closure)
}
