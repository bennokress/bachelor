//
//  Robot.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum RobotState {
    case starting   // when waiting at the entrance
    case moving     // when moving towards the next position on the route
    case idle       // when waiting for the next field to be cleared
    case docked     // when sitting in a workstation
    case finished   // when all waypoints of the route have been visited
}

struct Robot {
    
}
