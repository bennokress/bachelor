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
        
        self.fields[entranceFieldNumber].state = .entrance
        self.fields[exitFieldNumber].state = .exit
    }
    
    /// Returns an array of fields with FieldType "Empty" surrounded by a wall
    static private func getEmptyGrid(with width: Int, and length: Int) -> [Field] {
        
        let size = width * length
        let xMax = width - 1
        let yMax = length - 1
        
        var grid: [Field] = []
        
        for i in 0..<size {
            guard let fieldPosition = Position(fromFieldnumber: i, withFactoryWidth: width, andFactoryLength: length) else {
                fatalError("FieldPosition out of range!")
            }
            
            var field = Field(at: fieldPosition)
            
            // TODO: Add settings file and set positions of entrance and exit
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
