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
    let height: Int
    
    var fields: [Field]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        self.fields = FactoryLayout.getEmptyGrid(with: width, and: height)
    }
    
    /// Returns an array of fields with FieldType "Empty" surrounded by a wall
    static private func getEmptyGrid(with width: Int, and height: Int) -> [Field] {
        
        let size = width * height
        let xMax = width - 1
        let yMax = height - 1
        
        var grid: [Field] = []
        
        for i in 0..<size {
            guard let fieldPosition = Position(fromFieldnumber: i, withFactoryWidth: width, andFactoryHeight: height) else {
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
