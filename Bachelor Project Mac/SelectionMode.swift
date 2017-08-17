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
    case distribution(target: DistributionTarget)
    case fitnessAndDistribution(target: DistributionTarget)
    case distributionAndFitness(target: DistributionTarget)
    case best(order: [SelectionMode])
    
    func basedOrder(of generation: [Factory], targetSize: Int? = nil, targetAverage: Double? = nil) -> [Factory] {
        let sortedGeneration: [Factory]
        switch self {
        case .fitness, .fitnessAndDistribution:
            // TODO: implement combination
            sortedGeneration = generation.sorted { $0.fitness < $1.fitness }
        case .distribution(let target), .distributionAndFitness(let target):
            // TODO: implement combination
            switch target {
            case .high:
                sortedGeneration = generation.sorted { $0.distribution > $1.distribution }
            case .medium:
                let averageDistribution = targetAverage ?? generation.map({ $0.distribution }).reduce(0,+) / Double(generation.count)
                sortedGeneration = generation.sorted { abs($0.distribution - averageDistribution) < abs($1.distribution - averageDistribution) }
            case .low:
                sortedGeneration = generation.sorted { $0.distribution < $1.distribution }
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
        let averageDistribution = generation.map({ $0.distribution }).reduce(0,+) / Double(generation.count)
        var remainingFactories = generation
        var sortedGeneration: [Factory] = []
        let selectionRounds = targetSize ?? generation.count
        var currentSortingModeIndex = 0
        selectionRounds.times {
            let sortingMode = order[currentSortingModeIndex]
            remainingFactories = sortingMode.basedOrder(of: remainingFactories, targetAverage: averageDistribution)
            sortedGeneration.append(remainingFactories.removeFirst())
            currentSortingModeIndex = (currentSortingModeIndex + 1) % order.count
        }        
        return sortedGeneration
    }
}

enum DistributionTarget {
    case high
    case medium
    case low
}
