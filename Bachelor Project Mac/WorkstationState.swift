//
//  WorkstationState.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum WorkstationState {
    case busy(robot: Robot)     // when working on a docked robot
    case idle                   // when waiting for the next robot
}

extension WorkstationState: Equatable {
    
    static func == (lhs: WorkstationState, rhs: WorkstationState) -> Bool {
        switch (lhs, rhs) {
        case (.busy, .busy), (.idle, .idle):
            return true
        default:
            return false
        }
    }
    
}
