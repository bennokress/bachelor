//
//  Position.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Position: Encodable {
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init?(fromFieldnumber fieldnumber: Int, withFactoryWidth width: Int, andFactoryLength length: Int) {
        
        guard fieldnumber < width * length else {
            print("Invalid fieldnumber \(fieldnumber) for a factory of size \(width) x \(length)")
            return nil
        }
        
        let xValue = fieldnumber % width
        let yValue = (fieldnumber - xValue) / width
        
        self.x = xValue
        self.y = yValue
        
    }
    
    init?(fromFieldnumber fieldnumber: Int, in factorylayout: FactoryLayout) {
        self.init(fromFieldnumber: fieldnumber, withFactoryWidth: factorylayout.width, andFactoryLength: factorylayout.length)
    }
    
    // MARK: - 🔧 Properties
    
    let x: Int
    let y: Int
    
    // MARK: - ⚙️ Computed Properties
    
    /// Returns all positions in the valid moving directions (up, down, left, right)
    var surroundingPositions: [Position] {
        
        let up = Position(x: self.x, y: self.y - 1)
        let down = Position(x: self.x, y: self.y + 1)
        let left = Position(x: self.x - 1, y: self.y)
        let right = Position(x: self.x + 1, y: self.y)
        
        return [up, down, left, right]
        
    }
    
    // MARK: - 📘 Static Functions
    
    /// Returns the position of a randomly retrieved empty field in the given Factory Layout
    static func ofRandomEmptyField(in factoryLayout: FactoryLayout) -> Position {
        let emptyFields = factoryLayout.fields.filter { $0.isEmpty }
        guard let randomField = emptyFields.randomElement else { fatalError("No more empty field in factory layout found!") }
        return randomField.position
    }
    
    // MARK: - 📗 Functions
    
    /// Returns the convertion to a field number for the given factory layout
    func getFieldNumber(in factorylayout: FactoryLayout) -> Int? {
        return getFieldNumberInFactory(withWidth: factorylayout.width, andLength: factorylayout.length)
    }
    
    /// Returns the convertion to a field number for the given factory
    func getFieldNumberInFactory(withWidth width: Int, andLength length: Int) -> Int? {
        return self.isInFactory(withWidth: width, andLength: length) ? (y * width + x) : nil
    }
    
    /// Returns the valid moving distance in fields to the given position
    func distance(to otherPosition: Position) -> Int {
        return abs(self.x - otherPosition.x) + abs(self.y - otherPosition.y)
    }
    
    /// Returns all positions inside a given field radius in the specified factory layout
    func allPositions(inRadius radius: Int, inside layout: FactoryLayout) -> [Position] {
        let delta = (-radius...radius)
        let coordinates = delta.map { dx in delta.map { dy in (dx, dy) } }.joined().filter { $0.0 != 0 || $0.1 != 0 }
        let positions = coordinates.map { Position(x: self.x + $0.0, y: self.y + $0.1) }.filter { $0.isInFactory(withLayout: layout) }
        return positions
    }
    
    /// Returns true if the position is inside the given factory layout
    func isInFactory(withLayout factoryLayout: FactoryLayout) -> Bool {
        return isInFactory(withWidth: factoryLayout.width, andLength: factoryLayout.length)
    }
    
    /// Returns true if the position is inside any factory layout with the given measurements
    func isInFactory(withWidth width: Int, andLength length: Int) -> Bool {
        return x >= 0 && x < width && y >= 0 && y < length
    }
    
}

// MARK: - 🔖 Equatable Conformance
extension Position: Equatable {
    
    /// Positions are considered equal, if their x and y coordinates are equal
    static func == (lhs: Position, rhs: Position) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
    
}

// MARK: - 🔖 CustomStringConvertible Conformance
extension Position: CustomStringConvertible {
    
    var description: String {
        return "(\(x), \(y))"
    }
    
}
