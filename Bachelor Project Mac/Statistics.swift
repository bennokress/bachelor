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
    
    var startTime: Date? = nil
    var endTime: Date? = nil
    
    var runtime: Double {
        guard let start = startTime, let finish = endTime else { return -1 }
        return finish.secondsSince(start)
    }
    
    private var evolution: [RoundStatistics] = []
    
    func save(_ generation: Generation, forRound round: Int) {
        let roundStatistics = RoundStatistics(from: generation, inRound: round)
        evolution.append(roundStatistics)
    }
    
    func generateFinalOutput() {
        // TODO: Save to file instead of console
        endTime = Date.now
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
        let runtime = "Runtime in Seconds;\(self.runtime)"
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
        
        let csvOutput = """
        \(runtime.excelFixed)
        \(simulationRoundCSV.excelFixed)
        \(averageFitnessCSV.excelFixed)
        \(bestFitnessCSV.excelFixed)
        \(worstFitnessCSV.excelFixed)
        \(averageDiversityCSV.excelFixed)
        """
        
        print(csvOutput)
    }
    
    private func getDiversityAverageCSV(from individuals: [Factory]) -> String {
        let generation = Generation(factories: Set(individuals))
        return "\(generation.averageDiversity);"
    }

}
