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
        self.printToConsole()
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

}
