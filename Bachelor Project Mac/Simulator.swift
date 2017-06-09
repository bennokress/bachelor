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
        var generation = settings.getInitialGeneration()
        runSimulation(on: &generation)
    }
    
    private func runSimulation(on generation: inout Set<Factory>) {
        for factory in generation { factory.debug() }
        settings.simulationRounds.times {
            runSingleRoundOfGeneticAlgorithm(on: &generation)
            print("------------------------------------------------------")
            for factory in generation { factory.debug() }
        }
    }
    
    private func runSingleRoundOfGeneticAlgorithm(on generation: inout Set<Factory>) {
        for modificator in settings.modificators {
            modificator.execute(on: &generation)
        }
    }
    
}
