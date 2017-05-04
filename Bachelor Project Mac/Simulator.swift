//
//  Simulator.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Simulator {
    
    let settings = SimulationSettings()
    
    func start() {
        let generation = settings.getInitialGeneration()
        runSimulation(on: generation)
    }
    
    func runSimulation(on generation: Set<Factory>) {
        for factory in generation { factory.debug() }
//        let rounds = settings.simulationRounds
    }
    
}
