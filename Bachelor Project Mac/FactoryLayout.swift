//
//  FactoryLayout.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation
import CryptoSwift

struct FactoryLayout: CustomPrintable, Encodable {
    
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
    
    var sortedWorkstations: [Workstation] {
        return workstations.sorted(by: { (ws1, ws2) -> Bool in
            if ws1.type.hashValue < ws2.type.hashValue {
                return true
            } else if ws1.position.x < ws2.position.x {
                return true
            } else if ws1.position.y < ws2.position.y {
                return true
            } else {
                return false
            }
        })
    }
    
    // MARK: Initializer
    
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
    
    func potentialTargetFields(around position: Position) -> [Field] {
        guard position.x >= 0, position.x <= xMax, position.y >= 0, position.y <= yMax else { return [] }
        var targetFields: [Field] = []
        for position in position.surroundingPositions {
            if let fieldnumber = position.getFieldnumber(in: self), fields[fieldnumber].hasRemainingCapacity {
                targetFields.append(fields[fieldnumber])
            }
        }
        return targetFields
    }
    
    func isEmptyField(at position: Position) -> Bool {
        guard let fieldnumber = position.getFieldnumber(in: self) else { return false }
        return fields[fieldnumber].isEmpty
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
    
    mutating func swap(_ oldWorkstation: Workstation, for newWorkstation: Workstation) {
        deleteWorkstation(oldWorkstation)
        addWorkstation(newWorkstation)
    }
    
    /// Adds a new robot to the entrance of the factory layout
    mutating func addRobot(_ robot: inout Robot) {
        guard var entrance = entranceField, let entranceFieldnumber = entrance.position.getFieldnumber(in: self) else { fatalError("No entrance found!") }
        entrance.addRobot(robot)
        updateField(at: entranceFieldnumber, to: entrance)
    }
    
    /// Modifies an existing robot in place - to move it use moveRobot()
    mutating func modifyRobot(_ robot: Robot, to modifiedRobot: inout Robot) {
        guard let oldFieldnumber = robot.position.getFieldnumber(in: self) else { fatalError("Robot was already outside factory layout!") }
        fields[oldFieldnumber].removeRobot(robot)
        
        guard let newFieldnumber = modifiedRobot.position.getFieldnumber(in: self) else { fatalError("Target position is outside factory layout!") }
        fields[newFieldnumber].addRobot(modifiedRobot)
    }
    
    private mutating func deleteWorkstation(_ workstation: Workstation) {
        guard let fieldnumber = workstation.position.getFieldnumber(in: self), fields[fieldnumber].workstation != nil else {
            fatalError("Workstation not found in factory layout")
        }
        updateField(at: fieldnumber, to: Field(at: workstation.position, type: .empty))
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
        width: Int = SimulationSettings.shared.factoryWidth,
        length: Int = SimulationSettings.shared.factoryLength,
        entrance: Position = SimulationSettings.shared.entrance,
        exit: Position = SimulationSettings.shared.exit) -> [Field] {
        
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
    
    var hash: String {
        var workstationLayoutDescription: String {
            var wsLayout = "workstations"
            for ws in sortedWorkstations { wsLayout.append(" |\(ws.type.rawValue):\(ws.position.x),\(ws.position.y)") }
            return wsLayout
        }
        let layoutString = "\(width),\(length),\(workstationLayoutDescription)"
        return layoutString.md5()
    }
    
    /// Factory Layouts are considered equal, if their empty layouts are equal (dimensions, entrance and exit position) and the workstations are positioned equally
    static func == (lhs: FactoryLayout, rhs: FactoryLayout) -> Bool {
        return lhs.hash == rhs.hash
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
