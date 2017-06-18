//
//  Simulator.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Simulator {
    
    var settings = SimulationSettings.shared
    
    mutating func start() {
        var generation = settings.getInitialGeneration()
        runSimulation(on: &generation)
    }
    
    private func runSimulation(on generation: inout Set<Factory>) {
        printStatistics(for: generation)
        settings.generations.times {
            print("----------------------------------------------------------------------------------------")
            runSingleRoundOfGeneticAlgorithm(on: &generation)
            printStatistics(for: generation)
        }
    }
    
    private func runSingleRoundOfGeneticAlgorithm(on generation: inout Set<Factory>) {
        for modificator in settings.modificators {
            modificator.execute(on: &generation)
        }
    }
    
    private func printStatistics(for generation: Set<Factory>) {
        var bestFactory: Factory? = nil
        var bestFitness = Int.max
        for factory in generation {
            factory.debug()
            let fitness = factory.fitness
            if fitness < bestFitness {
                bestFactory = factory
                bestFitness = fitness
            }
            print("Factory #\(factory.id) has fitness \(fitness)")
        }
        print("\n--- BEST FACTORY SO FAR ---")
        print(bestFactory ?? "")
    }
    
}
