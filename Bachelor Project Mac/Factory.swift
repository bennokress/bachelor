//
//  Factory.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Factory {
    
    var layout: FactoryLayout
    var state: FactoryState
    
    var fitness: Int {
        return run()
    }
    
}

// MARK: Genetic Algorithm
extension Factory {
    
    /// Runs the simulation until all robots are either blocked or finished. Returns the steps needed (fitness).
    fileprivate func run() -> Int {
        // FIXME: Implement this
        return 0
    }
    
}

extension Factory: Equatable {
    
    static func == (lhs: Factory, rhs: Factory) -> Bool {
        // FIXME: Implement this
        return false // equal if factory layouts are equal
    }
    
}
