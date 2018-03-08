//
//  Product.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Product {
    
    let type: ProductType
    
    var neededWorkstations: [WorkstationType] { return self.type.route }
    
    init(type: ProductType) {
        self.type = type
    }
    
}

// MARK: - 🔖 Equatable Conformance
extension Product: Equatable {
    
    /// Products are considered equal, if their types are equal
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.type == rhs.type
    }
    
}

// MARK: - 🔖 CustomStringConvertible Conformance
extension Product: CustomStringConvertible {
    
    var description: String {
        let workstationNames = neededWorkstations.map { $0.rawValue }.joined(separator: " - ")
        return "Product of Type \(type.rawValue) - Route of Workstations: \(workstationNames)"
    }
    
}
