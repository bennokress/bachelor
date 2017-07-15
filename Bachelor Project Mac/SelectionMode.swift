//
//  SelectionMode.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 10.07.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum SelectionMode {
    case random
    case fitness
    case diversity(target: DiversityTarget)
    case fitnessAndDiversity(target: DiversityTarget)
    case diversityAndFitness(target: DiversityTarget)
    case best(order: [SelectionMode])
    
    func basedOrder(of generation: [Factory], targetSize: Int? = nil, targetAverage: Double? = nil) -> [Factory] {
        let sortedGeneration: [Factory]
        switch self {
        case .fitness, .fitnessAndDiversity:
            sortedGeneration = generation.sorted { $0.fitness < $1.fitness }
        case .diversity(let target), .diversityAndFitness(let target):
            switch target {
            case .high:
                sortedGeneration = generation.sorted { $0.diversity > $1.diversity }
            case .medium:
                let averageDiversity = targetAverage ?? generation.map({ $0.diversity }).reduce(0,+) / Double(generation.count)
                sortedGeneration = generation.sorted { abs($0.diversity - averageDiversity) < abs($1.diversity - averageDiversity) }
            case .low:
                sortedGeneration = generation.sorted { $0.diversity < $1.diversity }
            }
        case .best(let order):
            sortedGeneration = sort(generation, by: order, until: targetSize)
        case .random:
            sortedGeneration = generation.shuffled
        }
        
        if let size = targetSize {
            return Array(sortedGeneration.prefix(size))
        } else {
            return sortedGeneration
        }
    }
    
    private func sort(_ generation: [Factory], by order: [SelectionMode], until targetSize: Int?) -> [Factory] {
        let averageDiversity = generation.map({ $0.diversity }).reduce(0,+) / Double(generation.count)
        var remainingFactories = generation
        var sortedGeneration: [Factory] = []
        let selectionRounds = targetSize ?? generation.count
        var currentSortingModeIndex = 0
        selectionRounds.times {
            let sortingMode = order[currentSortingModeIndex]
            remainingFactories = sortingMode.basedOrder(of: remainingFactories, targetAverage: averageDiversity)
            sortedGeneration.append(remainingFactories.removeFirst())
            currentSortingModeIndex = (currentSortingModeIndex + 1) % order.count
        }        
        return sortedGeneration
    }
}

enum DiversityTarget {
    case high
    case medium
    case low
}
