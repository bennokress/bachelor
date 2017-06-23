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
        
        // DELETE LATER ...
        
        let sortedFactories = generation.sorted { $0.fitness < $1.fitness }
        for (index, factory) in sortedFactories.enumerated() {
            if let nextFactory = sortedFactories[safe: index + 1] {
                if factory.fitness == nextFactory.fitness {
                    print("----------------------------------------------------------------------------------------")
                    if factory.layout == nextFactory.layout {
                        print("Factory #\(factory.id) and factory #\(nextFactory.id) are equal!")
                        print("----------------------------------------------------------------------------------------")
                    }
                    print(factory.layout.hash)
                    print(factory)
                    print(nextFactory.layout.hash)
                    print(nextFactory)
                }
            }
        }
        
        // ... UNTIL THIS LINE
        
        let selectedIndividuals = generation.sorted { $0.fitness < $1.fitness }.firstHalf
        generation = Set(selectedIndividuals)
    }
    
}
