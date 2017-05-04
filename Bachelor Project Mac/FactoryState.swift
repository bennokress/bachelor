//
//  FactoryState.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 03.05.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum FactoryState: String {
    case running
    case finished
}

extension FactoryState: Identifiable {
    
    var id: Int { return self.hashValue }
    
}
