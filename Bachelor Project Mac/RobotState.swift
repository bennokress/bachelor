//
//  RobotState.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum RobotState: String {
    case starting   // when waiting at the entrance
    case moving     // when moving towards the next position on the route
    case idle       // when waiting for the next field to be cleared
    case blocked    // TODO: when ??? 
    case docked     // when sitting in a workstation
    case finished   // when all waypoints of the route have been visited
}

extension RobotState: Equatable {
    
    static func == (lhs: RobotState, rhs: RobotState) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
