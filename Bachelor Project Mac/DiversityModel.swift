//
//  DiversityModel.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 15.07.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum DiversityModel {
    case maxDistanceToCenter        // calculates the center position of all workstations and outputs the max. distance
    case averageDistanceToCenter    // calculates the center position of all workstations and outputs the avg. distance
    case surroundingRectangle       // calculates the surrounding rectangle for all workstations and outputs 1/2 length of the diagonal (for comparability)
    
    func getScore(of layout: FactoryLayout) -> Double {
        switch self {
        case .maxDistanceToCenter:
            return getMaxDistanceToCenter(of: layout)
        case .averageDistanceToCenter:
            return getAverageDistanceToCenter(of: layout)
        case .surroundingRectangle:
            return getSurroundingRectangeScore(for: layout)
        }
    }
    
    private func getMaxDistanceToCenter(of layout: FactoryLayout) -> Double {
        return 0
    }
    
    private func getAverageDistanceToCenter(of layout: FactoryLayout) -> Double {
        return 0
    }
    
    private func getSurroundingRectangeScore(for layout: FactoryLayout) -> Double {
        var minX = Int.max
        var maxX = Int.min
        var minY = Int.max
        var maxY = Int.min
        for workstation in layout.workstations {
            let pos = workstation.position
            if pos.x < minX { minX = pos.x }
            if pos.x > maxX { maxX = pos.x }
            if pos.y < minY { minY = pos.y }
            if pos.y > maxY { maxY = pos.y }
        }
        let minPosition = Position(x: minX, y: minY)
        let maxPosition = Position(x: maxX, y: maxY)
        return Double(minPosition.distance(to: maxPosition)) / 2
    }
    
//    private func getSurroundingRectangeScore(for layout: FactoryLayout) -> Double {
//        let xValues = layout.workstations.map { $0.position.x }
//        let yValues = layout.workstations.map { $0.position.y }
//
//        guard let minX = xValues.min(), let maxX = xValues.max(), let minY = yValues.min(), let maxY = yValues.max() else {
//            fatalError("Minima or Maxima could not be determined!")
//        }
//
//        let minPosition = Position(x: minX, y: minY)
//        let maxPosition = Position(x: maxX, y: maxY)
//        return Double(minPosition.distance(to: maxPosition)) / 2
//    }
}
