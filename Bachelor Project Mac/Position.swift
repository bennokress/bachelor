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
    
    init?(fromFieldnumber fieldnumber: Int, in factorylayout: FactoryLayout) {
        
        guard fieldnumber < factorylayout.width * factorylayout.height else {
            print("Invalid fieldnumber \(fieldnumber) for a factory of size \(factorylayout.width) x \(factorylayout.height)")
            return nil
        }
        
        let xValue = fieldnumber % factorylayout.width
        let yValue = (fieldnumber - xValue) / factorylayout.height
        
        self.x = xValue
        self.y = yValue
        
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
