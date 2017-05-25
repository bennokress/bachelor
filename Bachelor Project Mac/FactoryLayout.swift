//
//  FactoryLayout.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct FactoryLayout: CustomPrintable {
    
    let width: Int
    let length: Int
    
    var fields: [Field]
    
    // MARK: Computed Properties
    
    var xMax: Int { return width - 1 }
    var yMax: Int { return length - 1 }
    var size: Int { return width * length }
    
    var entranceField: Field? {
        for field in self.fields {
            if case .entrance = field.state {
                return field
            }
        }
        return nil
    }
    
    var exitField: Field? {
        for field in self.fields {
            if case .exit = field.state {
                return field
            }
        }
        return nil
    }
    
    var entrancePosition: Position? {
        return entranceField?.position
    }
    
    var exitPosition: Position? {
        return exitField?.position
    }
    
    var workstations: Set<Workstation> {
        var workstationObjects: Set<Workstation> = []
        for field in self.fields {
            switch field.state {
            case .workstation(let foundWorkstation):
                workstationObjects.insert(foundWorkstation)
            default:
                continue
            }
        }
        return workstationObjects
    }
    
    // MARK: Initializer
    
    init(width: Int = SimulationSettings().factoryWidth,
        length: Int = SimulationSettings().factoryLength,
        entrance: Position = SimulationSettings().entrance,
        exit: Position = SimulationSettings().exit) {
        
        guard entrance.isInFactory(withWidth: width, andLength: length), exit.isInFactory(withWidth: width, andLength: length) else {
            fatalError("Entrance or Exit outside of Factory Layout!")
        }
        
        self.width = width
        self.length = length
        self.fields = FactoryLayout.getBasicLayout(width: width, length: length, entrance: entrance, exit: exit)
        
    }
    
}

// MARK: Mutating functions
extension FactoryLayout {
    
    mutating func addWorkstation(_ workstation: Workstation) {
        guard let fieldnumber = workstation.position.getFieldnumber(in: self) else {
            fatalError("Workstation position is outside of factory layout")
        }
        fields[fieldnumber].addWorkstation(workstation)
    }
    
    /// Adds a new robot to the entrance of the factory layout
    mutating func addRobot(_ robot: inout Robot) {
        guard var entrance = entranceField, let entranceFieldnumber = entrance.position.getFieldnumber(in: self) else { fatalError("No entrance found!") }
        entrance.addRobot(robot)
        updateField(at: entranceFieldnumber, to: entrance)
    }
    
    /// Moves an existing robot from one field of the factory layout to another
//    mutating func moveRobot(_ robot: inout Robot, to newPosition: Position) {
//        guard let oldFieldnumber = robot.position.getFieldnumber(in: self) else { fatalError("Robot was already outside factory layout!") }
//        fields[oldFieldnumber].removeRobot(robot)
//        
//        guard let newFieldnumber = newPosition.getFieldnumber(in: self) else { fatalError("Target position is outside factory layout!") }
//        fields[newFieldnumber].addRobot(&robot)
//    }
    
    /// Modifies an existing robot in place - to move it use moveRobot()
    mutating func modifyRobot(_ robot: Robot, to modifiedRobot: inout Robot) {
        guard let oldFieldnumber = robot.position.getFieldnumber(in: self) else { fatalError("Robot was already outside factory layout!") }
        fields[oldFieldnumber].removeRobot(robot)
        
        guard let newFieldnumber = modifiedRobot.position.getFieldnumber(in: self) else { fatalError("Target position is outside factory layout!") }
        fields[newFieldnumber].addRobot(modifiedRobot)
    }
    
    private mutating func updateField(at fieldnumber: Int, to newField: Field) {
        guard fields.contains(index: fieldnumber) else { fatalError("Fieldnumber is outside factory layout!") }
        fields[fieldnumber] = newField
    }
    
}

// MARK: Static functions
extension FactoryLayout {
    
    /// Returns an array of fields with FieldType "Empty" surrounded by a wall
    static fileprivate func getBasicLayout(
        width: Int = SimulationSettings().factoryWidth,
        length: Int = SimulationSettings().factoryLength,
        entrance: Position = SimulationSettings().entrance,
        exit: Position = SimulationSettings().exit) -> [Field] {
        
        let size = width * length
        let xMax = width - 1
        let yMax = length - 1
        
        var grid: [Field] = []
        
        for i in 0 ..< size {
            guard let fieldPosition = Position(fromFieldnumber: i, withFactoryWidth: width, andFactoryLength: length) else {
                fatalError("FieldPosition out of range!")
            }
            
            var field = Field(at: fieldPosition)
            
            if field.position == entrance {
                field.state = .entrance(robots: [])
            } else if field.position == exit {
                field.state = .exit(robots: [])
            } else if field.position.x == 0 || field.position.y == 0 || field.position.x == xMax || field.position.y == yMax {
                field.state = .wall
            }
            
            grid.append(field)
        }
        
        return grid
        
    }
    
}

extension FactoryLayout: Equatable {
    
    /// Factory Layouts are considered equal, if their empty layouts are equal (dimensions, entrance and exit position)
    static func == (lhs: FactoryLayout, rhs: FactoryLayout) -> Bool {
        return (lhs.width == rhs.width) && (lhs.length == rhs.length) && (lhs.entrancePosition == rhs.entrancePosition) && (lhs.exitPosition == rhs.exitPosition)
    }
    
}

extension FactoryLayout: CustomStringConvertible {
    
    var description: String {
        var layout: String = "\n"
        for field in fields {
            layout.append(field.state.shortInfo)
            if field.position.x == xMax { layout.append("\n\n") }
        }
        return layout
    }
    
}
