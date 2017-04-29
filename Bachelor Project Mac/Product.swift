//
//  Product.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum ProductType {
    case pA
    case pB
    case pC
    case pD
    case pE
    case pF
}

struct Product {
    
    let type: ProductType
    
    init(type: ProductType) {
        self.type = type
    }
    
}

extension Product: Equatable {
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.type == rhs.type
    }
    
}
