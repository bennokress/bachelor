//
//  FactoryState.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 03.05.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

enum FactoryState: String, Encodable {
    case running
    case finished
}

extension FactoryState: IdentifiableEnum {
    
    var id: Int { return hashValue }
    
}
