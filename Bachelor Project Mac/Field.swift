//
//  Field.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Field {
    
    init(at position: Position, type: FieldType = .empty) {
        self.position = position
        self.state = type
    }
    
    // MARK: - 🔧 Properties
    
    let position: Position
    var state: FieldType
    
    // MARK: - ⚙️ Computed Properties
    
    /// Returns true, if the field's state is empty
    var isEmpty: Bool {
        return state == .empty
    }
    
    /// Returns true, if the field is able to accomodate another robot
    var hasRemainingCapacity: Bool {
        return remainingCapacity > 0
    }
    
    /// Returns a single robot sitting on the field or nil in all other cases. See var robots for fields with multiple robots!
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
    
    /// Returns multiple robots sitting in the entrance and exit or nil on all other fields
    var robots: Set<Robot>? {
        if case .entrance(let robots) = state {
            return robots
        } else if case .exit(let robots) = state {
            return robots
        } else {
            return robot != nil ? [robot!] : nil
        }
    }
    
    /// Returns the workstation sitting on the field or nil if none present
    var workstation: Workstation? {
        if case .workstation(let object) = state {
            return object
        } else {
            return nil
        }
    }
    
    // MARK: 🗝 Private Computed Properties
    
    /// Returns the remaining roboter-capacity of the field
    private var remainingCapacity: Int {
        switch state {
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
    
    // MARK: - 📕 Mutating Functions
    
    /// Removes workstations and robots from the field
    mutating func clear() {
        self.state = .empty
    }
    
    /// Adds the specified workstation to the field
    mutating func addWorkstation(_ workstation: Workstation) {
        if case .empty = state {
            state = .workstation(object: workstation)
        } else {
            fatalError("Target field was not empty!")
        }
    }
    
    /// Adds the specified robot to the field
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
    
    /// Removes the specified robot from the field
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

// MARK: - 🔖 Equatable Conformance
extension Field: Equatable {
    
    /// Fields are considered equal, if their position and state are equal
    static func == (lhs: Field, rhs: Field) -> Bool {
        return (lhs.position == rhs.position) && (lhs.state == rhs.state)
    }
    
}

// MARK: - 🔖 CustomStringConvertible Conformance
extension Field: CustomStringConvertible {
    
    var description: String {
        return "Field at \(position) is \(state)"
    }
    
}
