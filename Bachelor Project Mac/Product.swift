//
//  Product.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Product: CustomPrintable {
    
    let type: ProductType
    
    var neededWorkstations: [WorkstationType] { return self.type.route }
    
    init(type: ProductType) {
        self.type = type
    }
    
}

extension Product: Equatable {
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.type == rhs.type
    }
    
}

extension Product: CustomStringConvertible {
    
    var description: String {
        let workstationNames = neededWorkstations.map { $0.rawValue }.joined(separator: " - ")
        return "Product of Type \(type.rawValue) - Route of Workstations: \(workstationNames)"
    }
    
}
