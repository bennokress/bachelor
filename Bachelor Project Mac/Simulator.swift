//
//  Simulator.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Simulator {
    
    private var settings: SimulationSettings {
        return SimulationSettings.shared
    }
    
    private var statistics: Statistics {
        return Statistics.shared
    }
    
    var simulationNumber = 1
    
    mutating func start() {
        statistics.startTime = Date.now
        var generation = Generation.initial
        printSimulationNumber()
        runSimulation(on: &generation)
    }
    
    private mutating func runSimulation(on generation: inout Generation) {
        var currentRound = 0
        settings.generations.times {
            currentRound += 1
            if settings.simulatedWorkstationBreakdownActivated && currentRound == settings.workstationBreakdownTiming {
                deactivateWorkstations(withIDs: settings.brokenWorkstationIDs, in: &generation)
                generation.workstationBreakdownHappened = true
            }
            runSingleRoundOfGeneticAlgorithm(on: &generation)
            saveStats(on: &generation, inRound: currentRound)
            printProgressAndStats(for: generation, in: currentRound)
            
            // Only when last generation was just simulated ...
            if currentRound == settings.generations {
                statistics.generateFinalOutput() { successful in
                    guard successful else { return }
                    restartSimulation()
                }
            }
        }
    }
    
    private mutating func restartSimulation() {
        simulationNumber += 1
        statistics.reset()
        start()
    }
    
    private func deactivateWorkstations(withIDs workstationIDs: [Int], in generation: inout Generation) {
        for individual in generation.individuals {
            let individualWithBrokenWorkstations = Factory(from: individual, with: workstationIDs)
            generation.replace(individual, with: individualWithBrokenWorkstations)
        }
    }
    
    private func saveStats(on generation: inout Generation, inRound round: Int) {
        statistics.save(&generation, forRound: round)
    }
    
    private func printProgressAndStats(for generation: Generation, in round: Int) {
        let progressInPercent = (round * 100) / settings.generations
        let progressString = "\(progressInPercent.toString(length: 3))%"
        let progressBar = "[\(String.init(repeating: "=", count: (progressInPercent / 2)))\(String.init(repeating: " ", count: 50 - (progressInPercent / 2)))]"
        let roundString = "Round \(round.toString(length: 3))"
        if let bestFitness = generation.bestFitness, let worstFitness = generation.worstFitness {
            let bestFitnessString = "Best Fitness: \(bestFitness.toString(length: 3))"
            let worstFitnessString = "Worst Fitness: \(worstFitness.toString(length: 3))"
            print("\(roundString) | \(progressBar) | \(progressString) | \(bestFitnessString) | \(worstFitnessString)")
        } else {
            print("\(roundString) | \(progressBar) | \(progressString)")
        }
    }
    
    private func printSimulationNumber() {
        print("")
        print(String.init(repeating: "=", count: 112))
        print("Simulation # \(simulationNumber)")
        print(String.init(repeating: "-", count: 112))
    }
    
    private func runSingleRoundOfGeneticAlgorithm(on generation: inout Generation) {
        for phase in settings.phases {
            phase.execute(on: &generation)
        }
    }
    
}
