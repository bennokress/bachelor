//
//  FactoryLayout.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct FactoryLayout {
    
    let width: Int
    let length: Int
    
    var fields: [Field]
    
    var entrancePosition: Position? {
        for field in self.fields {
            switch field.state {
            case .entrance:
                return field.position
            default:
                continue
            }
        }
        return nil
    }
    
    var exitPosition: Position? {
        for field in self.fields {
            switch field.state {
            case .exit:
                return field.position
            default:
                continue
            }
        }
        return nil
    }
    
    var workstations: [Workstation] {
        var workstationObjects: [Workstation] = []
        for field in self.fields {
            switch field.state {
            case .workstation(let foundWorkstation):
                workstationObjects.append(foundWorkstation)
            default:
                continue
            }
        }
        return workstationObjects
    }
    
    init(width: Int = SimulationSettings.shared.factoryWidth,
        length: Int = SimulationSettings.shared.factoryLength,
        entrance: Position = SimulationSettings.shared.entrance,
        exit: Position = SimulationSettings.shared.exit) {
        
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
        guard let index = workstation.position.getFieldnumber(in: self) else {
            fatalError("Workstation position is outside of factory layout")
        }
        // TODO: guard that target field is empty
        fields[index].state = .workstation(object: workstation)
    }
    
    mutating func addRobot(_ robot: Robot) {
        guard let index = robot.position.getFieldnumber(in: self) else {
            fatalError("Robot position is outside of factory layout")
        }
        // TODO: guard that target field has enough remaining capacity
        fields[index].state = .robot(object: robot)
    }
    
    mutating func moveRobot(_ robot: Robot, to position: Position) {
        // TODO: implement this method
        // 1 - change old field.state to empty
        // 2 - robot.position = position
        // 3 - addRobot(robot)
    }
    
}

// MARK: Static functions
extension FactoryLayout {
    
    /// Returns an array of fields with FieldType "Empty" surrounded by a wall
    static fileprivate func getBasicLayout(
        width: Int = SimulationSettings.shared.factoryWidth,
        length: Int = SimulationSettings.shared.factoryLength,
        entrance: Position = SimulationSettings.shared.entrance,
        exit: Position = SimulationSettings.shared.exit) -> [Field] {
        
        let size = width * length
        let xMax = width - 1
        let yMax = length - 1
        
        var grid: [Field] = []
        
        for i in 0..<size {
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
    
    static func == (lhs: FactoryLayout, rhs: FactoryLayout) -> Bool {
        return (lhs.width == rhs.width) && (lhs.length == rhs.length) && (lhs.fields == rhs.fields)
    }
    
}
