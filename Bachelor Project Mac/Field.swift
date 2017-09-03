//
//  Field.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Field: CustomPrintable, Encodable {
    
    let position: Position
    var state: FieldType
    
    var isEmpty: Bool { return state == .empty }
    var hasRemainingCapacity: Bool { return state.remainingCapacity > 0 }
    
    var robot: Robot? {
        if case .robot(let robot) = state {
            return robot
        } else if case .workstation(let workstation) = state {
            if case .busy(let robot) = workstation.state {
                return robot
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    var robots: Set<Robot>? {
        if case .entrance(let robots) = state {
            return robots
        } else if case .exit(let robots) = state {
            return robots
        } else {
            return robot != nil ? [robot!] : nil
        }
    }
    
    var workstation: Workstation? {
        if case .workstation(let object) = state {
            return object
        } else {
            return nil
        }
    }
    
    init(at position: Position, type: FieldType = .empty) {
        self.position = position
        self.state = type
    }
    
    mutating func clear() {
        self.state = .empty
    }
    
    mutating func addWorkstation(_ workstation: Workstation) {
        if case .empty = state {
            state = .workstation(object: workstation)
        } else {
            fatalError("Target field was not empty!")
        }
    }
    
    mutating func addRobot(_ robot: Robot) {
        if case .entrance(var robots) = state {
            robots.insert(robot)
            state = .entrance(robots: robots)
        } else if case .exit(var robots) = state {
            robots.insert(robot)
            state = .exit(robots: robots)
        } else if case .workstation(var workstation) = state {
            workstation.state = .busy(robot: robot)
            state = .workstation(object: workstation)
        } else if case .empty = state {
            state = .robot(object: robot)
        } else {
            fatalError("Robot tried to move to restricted field")
        }
    }
    
    mutating func removeRobot(_ robot: Robot) {
        if case .entrance(var robots) = state {
            guard let index = robots.index(where: { $0 == robot }) else { fatalError("Desired robot not found at entrance!") }
            robots.remove(at: index)
            state = .entrance(robots: robots)
        } else if case .exit(var robots) = state {
            guard let index = robots.index(where: { $0 == robot }) else { fatalError("Desired robot not found at exit!") }
            robots.remove(at: index)
            state = .exit(robots: robots)
        } else if case .workstation(var workstation) = state {
            workstation.state = .idle
            state = .workstation(object: workstation)
        } else if case .robot = state {
            state = .empty
        } else {
            fatalError("No robot found on target field!")
        }
    }
    
}

extension Field: Equatable {
    
    /// Fields are considered equal, if their position and state are equal
    static func == (lhs: Field, rhs: Field) -> Bool {
        return (lhs.position == rhs.position) && (lhs.state == rhs.state)
    }
    
}

extension Field: CustomStringConvertible {
    
    var description: String {
        return "Field at \(position) is \(state)"
    }
    
}

// Custom Encodable
extension Field {
    
    private enum CodingKeys: String, CodingKey {
        case position
        case state = "content"
    }
    
}
