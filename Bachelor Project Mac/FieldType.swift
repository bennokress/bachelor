//
//  FieldType.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum FieldType {
    case wall
    case entrance(robots: [Robot])
    case exit(robots: [Robot])
    case workstation(object: Workstation)
    case robot(object: Robot)
    case empty
    
    var remainingCapacity: Int {
        switch self {
        case .entrance, .exit:
            return Int.max
        case .wall, .robot:
            return 0
        case .workstation(let workstation):
            return workstation.state == .idle ? 1 : 0
        case .empty:
            return 1
        }
    }
}

extension FieldType: Equatable {
    
    /// Field Types are considered equal, if their types and eventual objects match
    static func == (lhs: FieldType, rhs: FieldType) -> Bool {
        switch (lhs, rhs) {
        case (.wall, .wall), (.entrance, .entrance), (.exit, .exit), (.empty, .empty):
            return true
        case (.workstation(let lhsObject), .workstation(let rhsObject)):
            return lhsObject == rhsObject
        case (.robot(let lhsObject), .robot(let rhsObject)):
            return lhsObject == rhsObject
        default:
            return false
        }
    }
    
}

extension FieldType: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .wall: return "a wall"
        case .entrance(let robots):
            return "the entrance with \(robots.count) robots"
        case .exit(let robots):
            return "the exit with \(robots.count) robots"
        case .workstation: return "a workstation"
        case .robot: return "a robot"
        case .empty: return "empty"
        }
    }
    
    var shortInfo: String {
        switch self {
        case .wall:
            return "  X  "
        case .entrance(let robots), .exit(let robots):
            return " E\(robots.count.twoDigitRepresentation) "
        case .workstation(let workstation):
            return workstation.isIdle ? " \(workstation.type.rawValue)-0 " : " \(workstation.type.rawValue)-1 "
        case .robot:
            return "  R  "
        case .empty:
            return "     "
        }
    }
    
}
