//
//  Statistics.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 10.09.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation
import SwifterSwift

class Statistics {
    
    typealias Success = (Bool) -> ()
    
    private init() { }
    static var shared = Statistics()
    
    var startTime: Date? = nil
    var endTime: Date? = nil
    
    var runtime: Double {
        guard let start = startTime, let finish = endTime else { return -1 }
        return finish.secondsSince(start)
    }
    
    private var evolution: [RoundStatistics] = []
    
    func save(_ generation: inout Generation, forRound round: Int) {
        let roundStatistics = RoundStatistics(from: &generation, inRound: round)
        evolution.append(roundStatistics)
    }
    
    func reset() {
        startTime = nil
        endTime = nil
        evolution.removeAll()
    }
    
    func generateFinalOutput(completion: Success) {
        endTime = Date.now
        let csvData = generateCSV()
        let csvFileURL = SimulationSettings.shared.composeStatisticsURL(for: Date.now)
        do {
            try csvData.write(to: csvFileURL, atomically: true, encoding: String.Encoding.utf8)
            completion(true)
        } catch {
            print("File could not be created!")
            print(csvData)
            completion(false)
        }
    }
    
    // MARK: Data Conversion Structure
    private struct RoundStatistics {
        let simulationRound: Int
        let bestFitness: Int
        let worstFitness: Int
        let averageFitness: Double
        let individuals: [Factory]
        
        init(from generation: inout Generation, inRound round: Int) {
            generation.recalculateMeasures()
            guard let bestFitness = generation.bestFitness, let worstFitness = generation.worstFitness else { fatalError("Could not compute fitness metrics!") }
            guard let averageFitnessOfGeneration = generation.averageFitness else { fatalError("Average Fitness was never measured!") }
            self.simulationRound = round
            self.bestFitness = bestFitness
            self.worstFitness = worstFitness
            self.averageFitness = averageFitnessOfGeneration
            self.individuals = generation.sortedByFitness
        }
    }
    
    private func generateCSV() -> String {
        let runtime = "Runtime in Seconds;\(self.runtime)"
        var simulationRoundCSV = "Simulation Round;"
        var averageFitnessCSV = "Average Fitness;"
        var bestFitnessCSV = "Best Fitness;"
        var worstFitnessCSV = "Worst Fitness;"
        var averageFitnessSharingDiversityCSV = "Average Diversity (Fitness Sharing);"
        var averagegenomeDistanceBasedDiversityCSV = "Average Diversity (Genom Distance Based);"
        var averageGenealogicalDiversityCSV = "Average Diversity (Genealogical);"
        
        printHeader()
        
        for round in evolution {
            simulationRoundCSV += "\(round.simulationRound);"
            averageFitnessCSV += "\(round.averageFitness);"
            bestFitnessCSV += "\(round.bestFitness);"
            worstFitnessCSV += "\(round.worstFitness);"
            averageFitnessSharingDiversityCSV += getDiversityAverageCSV(from: round.individuals, diversityModel: .fitnessSharing)
            averagegenomeDistanceBasedDiversityCSV += getDiversityAverageCSV(from: round.individuals, diversityModel: .genomeDistanceBased)
            averageGenealogicalDiversityCSV += getDiversityAverageCSV(from: round.individuals, diversityModel: .genealogical)
            printProgress(for: round.simulationRound)
        }
        
        let csvOutput = """
        \(runtime.excelFixed)
        \(simulationRoundCSV.excelFixed)
        \(averageFitnessCSV.excelFixed)
        \(bestFitnessCSV.excelFixed)
        \(worstFitnessCSV.excelFixed)
        \(averageFitnessSharingDiversityCSV.excelFixed)
        \(averagegenomeDistanceBasedDiversityCSV.excelFixed)
        \(averageGenealogicalDiversityCSV.excelFixed)
        """
        
        return csvOutput
    }
    
    private func getDiversityAverageCSV(from individuals: [Factory], diversityModel: DiversityModel) -> String {
        let generation = Generation(factories: Set(individuals))
        let averageDiversityOfGeneration = diversityModel.averageDiversity(for: generation, with: diversityModel)
        return "\(averageDiversityOfGeneration);"
    }
    
    private func printHeader() {
        print("")
        print(String.init(repeating: "=", count: 71))
        print("Gathering Detailed Statistics for all Rounds")
        print(String.init(repeating: "-", count: 71))
    }
    
    private func printProgress(for round: Int) {
        let progressInPercent = (round * 100) / SimulationSettings.shared.generations
        let progressString = "\(progressInPercent.toString(length: 3))%"
        let progressBar = "[\(String.init(repeating: "=", count: (progressInPercent / 2)))\(String.init(repeating: " ", count: 50 - (progressInPercent / 2)))]"
        let roundString = "Round \(round.toString(length: 3))"
        print("\(roundString) | \(progressBar) | \(progressString)")
    }

}
