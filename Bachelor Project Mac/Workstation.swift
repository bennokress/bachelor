//
//  Workstation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum WorkstationState {
    case busy       // when working on a docked robot
    case idle       // when waiting for the next robot
}

enum WorkstationType {
    case a
    case b
    case c
    case d
    case e
    case f
}

struct Workstation {
    
    var state: WorkstationState
    
}

extension Workstation: Equatable {
    
    static func == (lhs: Workstation, rhs: Workstation) -> Bool {
        // FIXME: Implement this
        return false
    }
    
}
