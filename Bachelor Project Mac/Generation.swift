//
//  Generation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 26.08.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Generation {
    
    var factories: Set<Factory>
    
    var individuals: [Factory] { return Array(factories) }
    var size: Int { return factories.count }
    var shuffled: [Factory] { return factories.shuffled }
    
    mutating func insert(_ factory: Factory) {
        factories.insert(factory)
    }
    
}
