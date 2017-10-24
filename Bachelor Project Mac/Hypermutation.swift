//
//  Hypermutation.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 23.06.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct Hypermutation: Modificator {

    func execute(on generation: inout Generation) {

        let settings = SimulationSettings.shared
        
        if generation.hypermutationShouldTrigger {
            
            let tenPercentOfTargetGenerationSize = settings.generationSize / 10
            var hypermutationResults: [Factory] = []
            
            tenPercentOfTargetGenerationSize.times {
                // 1 - Generate new random factory
                let workstationBrakedownNeeded = generation.workstationBreakdownHappened
                let randomFactory = settings.generateRandomFactory(withBrokenWorkstation: workstationBrakedownNeeded)
                // 2 - Insert factory into generation
                generation.insert(randomFactory)
                // 3 - Save the factory for the console output
                hypermutationResults.append(randomFactory)
            }
            
            actionPrint(short: shortActionDescription(for: hypermutationResults), detailed: detailedActionDescription(for: hypermutationResults))
            
        }

    }

    private func shortActionDescription(for results: [Factory]) -> String {
        let sortedFactories = results.sorted { $0.fitness < $1.fitness }
        guard let bestFitness = sortedFactories.first?.fitness, let worstFitness = sortedFactories.last?.fitness else { return "--- Error retreiving fitness ---" }
        return "Hypermutation produced \(sortedFactories.count) factories with fitness between \(bestFitness) and \(worstFitness)"
    }

    private func detailedActionDescription(for results: [Factory]) -> [String] {
        let title = "HYPERMUTATION"
        var actionDescriptionLines = ["\n\(title.withAddedDivider("-", totalLength: 56))"]
        for factory in results.sorted(by: { $0.fitness < $1.fitness }) {
            actionDescriptionLines.append("  · #\(factory.id) (\(factory.fitness))")
        }
        return actionDescriptionLines
    }

}

