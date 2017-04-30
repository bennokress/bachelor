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
