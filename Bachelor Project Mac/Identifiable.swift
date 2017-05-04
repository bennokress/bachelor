//
//  Identifiable.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 04.05.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

protocol Identifiable: Hashable {
    
    var id: Int { get }
    
}

// MARK: Default Implementation for Hashable Conformance (Equatable has to be implemented separately)
extension Identifiable {
    
    var hashValue: Int {
        return id
    }
    
}
