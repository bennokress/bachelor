//
//  Position.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation
import SwifterSwift

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
        let yValue = (fieldnumber - xValue) / width
        
        self.x = xValue
        self.y = yValue
        
    }
    
    init?(fromFieldnumber fieldnumber: Int, in factorylayout: FactoryLayout) {
        self.init(fromFieldnumber: fieldnumber, withFactoryWidth: factorylayout.width, andFactoryLength: factorylayout.length)
    }
    
    func getFieldnumber(in factorylayout: FactoryLayout) -> Int? {
        return getFieldNumberInFactory(withWidth: factorylayout.width, andLength: factorylayout.length)
    }
    
    func getFieldNumberInFactory(withWidth width: Int, andLength length: Int) -> Int? {
        return self.isInFactory(withWidth: width, andLength: length) ? (y * width + x) : nil
    }
    
    func distance(to otherPosition: Position) -> Int {
        return abs(self.x - otherPosition.x) + abs(self.y - otherPosition.y)
    }
    
    func isInFactory(withLayout factoryLayout: FactoryLayout) -> Bool {
        return isInFactory(withWidth: factoryLayout.width, andLength: factoryLayout.length)
    }
    
    func isInFactory(withWidth width: Int, andLength length: Int) -> Bool {
        return (y * width + x) < (width * length)
    }
    
    static func ofRandomEmptyField(in factoryLayout: FactoryLayout) -> Position {
        let emptyFields = factoryLayout.fields.filter { $0.isEmpty }
        let randomField = emptyFields[Int.random(between: 1, and: emptyFields.count) - 1]
        return randomField.position
    }
    
}

extension Position: Equatable {
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
    
}
