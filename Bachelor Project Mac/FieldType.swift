//
//  FieldType.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

enum FieldType {
    
    case wall
    case entrance(robots: Set<Robot>)
    case exit(robots: Set<Robot>)
    case workstation(object: Workstation)
    case robot(object: Robot)
    case empty
    
}

// MARK: - 🔖 Equatable Conformance
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

// MARK: - 🔖 CustomStringConvertible Conformance
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
    
}
