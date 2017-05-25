//
//  RobotState.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum RobotState {
    case starting           // when waiting at the entrance
    case moving             // when moving towards the next position on the route
    case blocked            // after being idle since 4 rounds and still stuck
    case docked             // when sitting in a workstation
    case finished           // when all waypoints of the route have been visited
    case idle(since: Int)   // when waiting for the next field to be cleared
}

extension RobotState: Identifiable {
    
    var id: Int {
        switch self {
        case .starting: return 1
        case .moving: return 2
        case .blocked: return 3
        case .docked: return 4
        case .finished: return 5
        case .idle(let rounds): return 5 + rounds // rounds is at least 1, so this returns 6 or more
        }
    }
    
}

extension RobotState: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .starting: return "starting"
        case .moving: return "moving"
        case .blocked: return "blocked"
        case .docked: return "docked"
        case .finished: return "finished"
        case .idle(let rounds): return "idle since \(rounds) \(rounds == 1 ? "round" : "rounds")"
        }
    }
    
}
