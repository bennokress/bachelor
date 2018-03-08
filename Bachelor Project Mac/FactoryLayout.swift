//
//  FactoryLayout.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation
import CryptoSwift

struct FactoryLayout {
    
    // MARK: - 🔨 Static Properties
    
    /// Returns an empty factory layout
    static var empty: FactoryLayout { return FactoryLayout() }
    
    /// The width in fields
    let width: Int
    
    /// The length in fields
    let length: Int
    
    /// The fields present in the layout
    var fields: [Field]
    
    // MARK: - Computed Properties
    
    /// The maximum x-coordinate present in the layout grid
    var xMax: Int { return width - 1 }
    
    /// The maximum y-coordinate present in the layout grid
    var yMax: Int { return length - 1 }
    
    /// The amount of fields in the layout grid
    var size: Int { return width * length }
    
    /// The entrance field. Returns nil if not yet declared
    var entranceField: Field? {
        for field in self.fields {
            if case .entrance = field.state {
                return field
            }
        }
        return nil
    }
    
    /// The exit field. Returns nil if not yet declared
    var exitField: Field? {
        for field in self.fields {
            if case .exit = field.state {
                return field
            }
        }
        return nil
    }
    
    /// The position of the entrance field. Returns nil if not yet declared
    var entrancePosition: Position? {
        return entranceField?.position
    }
    
    /// The position of the exit field. Returns nil if not yet declared
    var exitPosition: Position? {
        return exitField?.position
    }
    
    /// The set containing all workstations present on the factory grid
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
    
    // MARK: - Initializers
    
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
    
    // MARK: - Functions
    
    func potentialTargetFields(around position: Position) -> [Field] {
        guard position.x >= 0, position.x <= xMax, position.y >= 0, position.y <= yMax else { return [] }
        var targetFields: [Field] = []
        for position in position.surroundingPositions {
            if let fieldnumber = position.getFieldNumber(in: self), fields[fieldnumber].hasRemainingCapacity {
                targetFields.append(fields[fieldnumber])
            }
        }
        return targetFields
    }
    
    /// Returns true, if the specified field is empty
    func isEmptyField(at position: Position) -> Bool {
        guard let fieldnumber = position.getFieldNumber(in: self) else { return false }
        return fields[fieldnumber].isEmpty
    }
    
    // MARK: - Mutating functions
    
    /// Adds the specified workstation at the position embedded in it
    mutating func addWorkstation(_ workstation: Workstation) {
        guard let fieldnumber = workstation.position.getFieldNumber(in: self) else {
            fatalError("Workstation position is outside of factory layout")
        }
        fields[fieldnumber].addWorkstation(workstation)
    }
    
    /// Removes the specified oldWorkstation and replaces it with the specified newWorkstation
    mutating func swap(_ oldWorkstation: Workstation, for newWorkstation: Workstation) {
        deleteWorkstation(oldWorkstation)
        addWorkstation(newWorkstation)
    }
    
    /// Adds a new robot to the entrance of the factory layout
    mutating func addRobot(_ robot: inout Robot) {
        guard var entrance = entranceField, let entranceFieldnumber = entrance.position.getFieldNumber(in: self) else { fatalError("No entrance found!") }
        entrance.addRobot(robot)
        updateField(at: entranceFieldnumber, to: entrance)
    }
    
    /// Removes the specified oldRobot and replaces it with the specified newRobot
    mutating func swap(_ oldRobot: Robot, for newRobot: inout Robot) {
        guard let oldFieldnumber = oldRobot.position.getFieldNumber(in: self) else { fatalError("Robot was already outside factory layout!") }
        fields[oldFieldnumber].removeRobot(oldRobot)
        
        guard let newFieldnumber = newRobot.position.getFieldNumber(in: self) else { fatalError("Target position is outside factory layout!") }
        fields[newFieldnumber].addRobot(newRobot)
    }
    
    /// Removes the specified workstation from the layout
    mutating func deleteWorkstation(_ workstation: Workstation) {
        guard let fieldnumber = workstation.position.getFieldNumber(in: self), fields[fieldnumber].workstation != nil else {
            fatalError("Workstation not found in factory layout")
        }
        updateField(at: fieldnumber, to: Field(at: workstation.position, type: .empty))
    }
    
    // MARK: Private Functions
    
    private mutating func updateField(at fieldnumber: Int, to newField: Field) {
        guard fields.contains(index: fieldnumber) else { fatalError("Fieldnumber is outside factory layout!") }
        fields[fieldnumber] = newField
    }

    // MARK: - Static functions
    
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

// MARK: - 🔖 Equatable Conformance
extension FactoryLayout: Equatable {
    
    /// A hash value based on the empty layout (dimension, entrance and exit position) and the workstations added to it (type and position)
    var hash: String {
        var workstationLayoutDescription: String {
            var workstationLayout = "workstations"
            for workstation in workstations { workstationLayout.append(" |\(workstation.type.rawValue):\(workstation.position.x),\(workstation.position.y)") }
            return workstationLayout
        }
        let layoutString = "\(width),\(length),\(workstationLayoutDescription)"
        return layoutString.md5()
    }
    
    /// Factory Layouts are considered equal, if their hash values are equal. See var hash for more information about the encoded values.
    static func == (lhs: FactoryLayout, rhs: FactoryLayout) -> Bool {
        return lhs.hash == rhs.hash
    }
    
}

// MARK: - 🔖 CustomStringConvertible Conformance
extension FactoryLayout: CustomStringConvertible {
    
    var description: String {
        var layout: String = "\n"
        for field in fields {
            layout.append(shortInfo(for: field))
            if field.position.x == xMax { layout.append("\n\n") }
        }
        return layout
    }
    
    private func shortInfo(for field: Field) -> String {
        switch field.state {
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
