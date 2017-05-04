//
//  StandardImplementation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 04.05.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation
@testable import Bachelor_Project_Mac

struct StandardImplementation {
    
    var position1: Position {
        return Position(x: 3, y: 2)
    }
    
    var position2: Position {
        return Position(x: 6, y: 2)
    }
    
    var field1: Field {
        return Field(at: position1)
    }
    
    var field2: Field {
        return Field(at: position2)
    }
    
    var emptyFactoryLayout: FactoryLayout {
        let entrance = Position(x: 2, y: 0)
        let exit = Position(x: 7, y: 4)
        return FactoryLayout(width: 10, length: 5, entrance: entrance, exit: exit)
    }
    
    var factoryLayout: FactoryLayout {
        var factoryLayout = emptyFactoryLayout
        factoryLayout.addWorkstation(workstation)
        return factoryLayout
    }
    
    var product: Product {
        return Product(type: .testProduct)
    }
    
    var workstation: Workstation {
        return Workstation(id: 0, type: .testWorkstation, at: position2)
    }
    
    var robot: Robot {
        return Robot(id: 0, product: product, in: factoryLayout)
    }
    
}
