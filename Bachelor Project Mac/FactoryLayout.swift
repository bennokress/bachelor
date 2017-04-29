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
    
    init(width: Int, length: Int) {
        self.width = width
        self.length = length
        
        self.fields = FactoryLayout.getEmptyGrid(with: width, and: length)
    }
    
    init(width: Int, length: Int, entrancePosition: Position, exitPosition: Position) {
        self.init(width: width, length: length)
        
        guard let entranceFieldNumber = entrancePosition.getFieldnumber(in: self), let exitFieldNumber = exitPosition.getFieldnumber(in: self) else {
            fatalError("Entrance or Exit outside of Factory Layout!")
        }
        
        self.fields[entranceFieldNumber].state = .entrance(robots: [])
        self.fields[exitFieldNumber].state = .exit(robots: [])
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
        // TODO: guard that target field is entrance, exit or empty
        fields[index].state = .robot(object: robot)
    }
    
    mutating func moveRobot(_ robot: Robot, to position: Position) {
        // TODO: implement this method
    }
    
}

// MARK: Static functions
extension FactoryLayout {
    
    /// Returns an array of fields with FieldType "Empty" surrounded by a wall
    static fileprivate func getEmptyGrid(with width: Int, and length: Int) -> [Field] {
        
        let size = width * length
        let xMax = width - 1
        let yMax = length - 1
        
        var grid: [Field] = []
        
        for i in 0..<size {
            guard let fieldPosition = Position(fromFieldnumber: i, withFactoryWidth: width, andFactoryLength: length) else {
                fatalError("FieldPosition out of range!")
            }
            
            var field = Field(at: fieldPosition)
            
            // TODO: Add entrance and exit according to settings
            if field.position.x == 0 || field.position.y == 0 || field.position.x == xMax || field.position.y == yMax {
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
