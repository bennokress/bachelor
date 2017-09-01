//
//  DistributionModel.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 15.07.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

enum DistributionModel: String, Encodable {
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
        let bounds = WorkstationBounds(from: layout)
        let centerPosition = bounds.centerPosition
        let distancesToCenter = layout.workstations.map { $0.position.distance(to: centerPosition) }
        guard let maxDistance = distancesToCenter.max else { fatalError("No distance could be calculated!") }
        return Double(maxDistance)
    }
    
    private func getAverageDistanceToCenter(of layout: FactoryLayout) -> Double {
        let bounds = WorkstationBounds(from: layout)
        let centerPosition = bounds.centerPosition
        let distancesToCenter = layout.workstations.map { $0.position.distance(to: centerPosition) }
        return distancesToCenter.average
    }
    
    private func getSurroundingRectangeScore(for layout: FactoryLayout) -> Double {
        let bounds = WorkstationBounds(from: layout)
        return Double(bounds.minPosition.distance(to: bounds.centerPosition))
    }
    
    private struct WorkstationBounds {
        
        let minX: Int
        let maxX: Int
        let minY: Int
        let maxY: Int
        
        var minPosition: Position { return Position(x: minX, y: minY) }
        var maxPosition: Position { return Position(x: maxX, y: maxY) }
        var centerPosition: Position {
            let centerX = maxX - ((maxX - minX) / 2)
            let centerY = maxY - ((maxY - minY) / 2)
            return Position(x: centerX, y: centerY)
        }
        
        init(from layout: FactoryLayout) {
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
            
            self.minX = minX
            self.maxX = maxX
            self.minY = minY
            self.maxY = maxY
        }
        
    }
    
}
