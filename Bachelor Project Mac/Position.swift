//
//  Position.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Position {
    
    let x, y: Int
    
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
        let yValue = (fieldnumber - xValue) / length
        
        self.x = xValue
        self.y = yValue
        
    }
    
    init?(fromFieldnumber fieldnumber: Int, in factorylayout: FactoryLayout) {
        self.init(fromFieldnumber: fieldnumber, withFactoryWidth: factorylayout.width, andFactoryLength: factorylayout.length)
    }
    
    func getFieldnumber(in factorylayout: FactoryLayout) -> Int? {
        
        let fieldnumber = y * factorylayout.width + x
        
        guard fieldnumber < factorylayout.width * factorylayout.length else {
            print("Invalid fieldnumber \(fieldnumber) for a factory of size \(factorylayout.width) x \(factorylayout.length)")
            return nil
        }
        
        return fieldnumber
    }
    
}

extension Position: Equatable {
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
    
}
