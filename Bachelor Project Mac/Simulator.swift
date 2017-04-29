//
//  Simulator.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

class Simulator {
    
    let settings = SimulationSettings.shared
    
    static var shared = Simulator()
    private init() { }
    
    func start() {
        let generation = settings.getInitialGeneration()
        dump(generation)
    }
    
}
