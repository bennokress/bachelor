//
//  Modificator.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 09.06.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

protocol Modificator: ActionPrintable {
    
    func execute(on generation: inout Generation)
    
}
