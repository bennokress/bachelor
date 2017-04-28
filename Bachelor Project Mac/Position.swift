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
    
    init?(fromFieldnumber fieldnumber: Int, withFactoryWidth width: Int, andFactoryHeight height: Int) {
        
        guard fieldnumber < width * height else {
            print("Invalid fieldnumber \(fieldnumber) for a factory of size \(width) x \(height)")
            return nil
        }
        
        let xValue = fieldnumber % width
        let yValue = (fieldnumber - xValue) / height
        
        self.x = xValue
        self.y = yValue
        
    }
    
    init?(fromFieldnumber fieldnumber: Int, in factorylayout: FactoryLayout) {
        self.init(fromFieldnumber: fieldnumber, withFactoryWidth: factorylayout.width, andFactoryHeight: factorylayout.height)
    }
    
    func getFieldnumber(in factorylayout: FactoryLayout) -> Int? {
        
        let fieldnumber = y * factorylayout.width + x
        
        guard fieldnumber < factorylayout.width * factorylayout.height else {
            print("Invalid fieldnumber \(fieldnumber) for a factory of size \(factorylayout.width) x \(factorylayout.height)")
            return nil
        }
        
        return fieldnumber
    }
    
}
