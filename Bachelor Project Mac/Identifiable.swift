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

extension Identifiable {
    
    // Default Implementation for Hashable Conformance
    var hashValue: Int {
        return id
    }
    
    // Default Implementation for Equatable Conformance
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}

protocol IdentifiableEnum: Hashable {
    
    var id: Int { get }
    
}

extension IdentifiableEnum {
    
    // Default Implementation for Equatable Conformance
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}
