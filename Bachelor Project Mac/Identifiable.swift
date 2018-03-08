//
//  Identifiable.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 04.05.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

protocol Identifiable: Hashable {
    
    var id: Int { get }
    
}

// MARK: - Default Implementations
extension Identifiable {
    
    // Default Implementation for Hashable Conformance only considering var id
    var hashValue: Int {
        return id
    }
    
    // Default Implementation for Equatable Conformance only considering var id
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}
