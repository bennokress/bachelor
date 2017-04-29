//
//  SimulationSettings.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

class SimulationSettings {
    
    static var shared = SimulationSettings()
    private init() { }
    
    // MARK: Factory Layout
    var factoryWidth = 10
    var factoryLength = 10
    var entrance: Position { return Position(x: 2, y: 0) }
    var exit: Position {
        let thirdLastFieldNumber = factoryWidth * factoryLength - 3
        return Position(fromFieldnumber: thirdLastFieldNumber, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength)!
    }
    
    // MARK: Products
    var products = [
        Product(),
        Product()
    ]
    
    
}
