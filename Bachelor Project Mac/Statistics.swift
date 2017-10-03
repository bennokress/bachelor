//
//  Statistics.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 10.09.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

class Statistics: Encodable {
    
    private init() { }
    static var shared = Statistics()
    
    private var evolution: [RoundStatistics] = []
    
    func save(_ generation: Generation, forRound round: Int) {
        let roundStatistics = RoundStatistics(from: generation, inRound: round)
        evolution.append(roundStatistics)
    }
    
    func createJSON() {
        // TODO: Save to file instead of console
//        self.printToConsole()
        self.generateCSV()
    }
    
    // MARK: Data Conversion Structure
    private struct RoundStatistics: Encodable {
        let simulationRound: Int
        let bestFitness: Int
        let worstFitness: Int
        let averageFitness: Double
        let individuals: [Factory]
        
        init(from generation: Generation, inRound round: Int) {
            guard let bestFitness = generation.bestFitness, let worstFitness = generation.worstFitness else { fatalError("Could not compute fitness metrics!") }
            self.simulationRound = round
            self.bestFitness = bestFitness
            self.worstFitness = worstFitness
            self.averageFitness = generation.averageFitness
            self.individuals = generation.sortedByFitness
        }
    }
    
    private func generateCSV() {
        var simulationRoundCSV = "Simulation Round;"
        var averageFitnessCSV = "Average Fitness;"
        var bestFitnessCSV = "Best Fitness;"
        var worstFitnessCSV = "Worst Fitness;"
        var averageDiversityCSV = "Average Diversity;"
        for round in evolution {
            simulationRoundCSV += "\(round.simulationRound);"
            averageFitnessCSV += "\(round.averageFitness);"
            bestFitnessCSV += "\(round.bestFitness);"
            worstFitnessCSV += "\(round.worstFitness);"
            averageDiversityCSV += getDiversityAverageCSV(from: round.individuals)
        }
        print(simulationRoundCSV)
        print(averageFitnessCSV)
        print(bestFitnessCSV)
        print(worstFitnessCSV)
        print(averageDiversityCSV)
    }
    
    private func getDiversityAverageCSV(from individuals: [Factory]) -> String {
        let generation = Generation(factories: Set(individuals))
        return "\(generation.averageDiversity);"
    }

}
