//
//  Selection.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 09.06.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Selection: Modificator {
    
    func execute(on generation: inout Set<Factory>) {
        let selectedIndividuals = generation.sorted { $0.fitness < $1.fitness }.firstHalf
        generation = Set(selectedIndividuals)
    }
    
}
