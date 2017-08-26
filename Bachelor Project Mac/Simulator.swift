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
    
    private func runSimulation(on generation: inout Generation) {
        actionPrint(short: shortInitialDescription(for: generation), detailed: detailedInitialDescription(for: generation))
        var currentRound = 0
        settings.generations.times {
            currentRound += 1
            runSingleRoundOfGeneticAlgorithm(on: &generation)
            if settings.isLastSimulationRound(currentRound) {
                actionPrint(fast: finishedNotification(), short: finishedNotification(), detailed: [finishedNotification()])
            }
            actionPrint(
                fast: fastRoundResultDescription(for: generation, afterRound: currentRound),
                short: shortRoundResultDescription(for: generation, afterRound: currentRound),
                detailed: detailedRoundResultDescription(for: generation, afterRound: currentRound)
            )
        }
    }
    
    private func runSingleRoundOfGeneticAlgorithm(on generation: inout Generation) {
        for modificator in settings.modificators {
            modificator.execute(on: &generation)
        }
    }
    
}

extension Simulator: ActionPrintable {
    
    // MARK: Initial Generation
    private func shortInitialDescription(for generation: Generation) -> String {
        let sortedGeneration = generation.factories.sorted { $0.fitness < $1.fitness }
        guard let bestFitness = sortedGeneration.first?.fitness, let worstFitness = sortedGeneration.last?.fitness else { return "--- Error retreiving fitness ---" }
        return "Initial generation of \(generation.size) factories with fitness between \(bestFitness) and \(worstFitness)"
    }
    
    private func detailedInitialDescription(for generation: Generation) -> [String] {
        let sortedGeneration = generation.factories.sorted { $0.id < $1.id }
        let title = "INITIAL GENERATION"
        var actionDescriptionLines = ["\n\(title.withAddedDivider("-", totalLength: 56))"]
        for factory in sortedGeneration { actionDescriptionLines.append("  · Factory #\(factory.id) with fitness \(factory.fitness)") }
        return actionDescriptionLines
    }
    
    // MARK: Round Result
    private func fastRoundResultDescription(for generation: Generation, afterRound round: Int) -> String? {
        return settings.isLastSimulationRound(round) ? shortRoundResultDescription(for: generation, afterRound: round) : "Finished round \(round) ..."
    }
    
    private func shortRoundResultDescription(for generation: Generation, afterRound round: Int) -> String {
        guard let bestFactory = generation.factories.sorted(by: { $0.fitness < $1.fitness }).first else { return "=== Error retreiving best factory ===" }
        let title = "BEST FACTORY AFTER ROUND \(round)"
        let description = settings.isLastSimulationRound(round) ? "\n" : "\n\(title.withAddedDivider("-", totalLength: 56))\n"
        return "\(description)\(bestFactory)"
    }
    
    private func detailedRoundResultDescription(for generation: Generation, afterRound round: Int) -> [String] {
        return [shortRoundResultDescription(for: generation, afterRound: round)]
    }
    
    // MARK: Simulation finished
    private func finishedNotification() -> String {
        let endTitle = "SIMULATION FINISHED"
        return "\n\(endTitle.withAddedDivider("=", totalLength: 56))"
    }
    
}
