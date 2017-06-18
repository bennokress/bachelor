//
//  Modificator.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 09.06.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

protocol Modificator {
    
    func execute(on generation: inout Set<Factory>)
    
}