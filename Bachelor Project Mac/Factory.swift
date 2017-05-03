//
//  Factory.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Factory: CustomPrintable {
    
    var layout: FactoryLayout
    var state: FactoryState // TODO: Is this really neccessary?
    
    // MARK: Computed Properties
    
    var robots: [Robot] {
        var robots: [Robot] = []
        for field in layout.fields {
            if let fieldRobots = field.robots {
                robots.append(contentsOf: fieldRobots)
            }
        }
        return robots
    }
    
    var workstations: [Workstation] {
        var workstations: [Workstation] = []
        for field in layout.fields {
            if let fieldWorkstation = field.workstation {
                workstations.append(fieldWorkstation)
            }
        }
        return workstations
    }
    
    var fitness: Int {
        return run()
    }
    
}

// MARK: Genetic Algorithm
extension Factory {
    
    /// Runs the simulation until all robots are either blocked or finished. Returns the steps needed (fitness).
    fileprivate func run() -> Int {
        // FIXME: Implement this
        return 0
    }
    
}

extension Factory: Equatable {
    
    /// Factories are cosidered equal, if their empty layout and all workstations (type, position) are equal
    static func == (lhs: Factory, rhs: Factory) -> Bool {
        return (lhs.workstations == rhs.workstations) && (lhs.layout == rhs.layout)
    }
    
}

extension Factory: CustomStringConvertible {
    
    var description: String {
        return "Factory with fitness \(fitness):\n\n\(layout.description)\n\n"
    }
    
    func extensivePrint() {
        print(self)
        print("\(robots.count) Robots:")
        for robot in robots { print(robot) }
        print("\n\n")
        print("\(workstations.count) Workstations:")
        for workstation in workstations { print(workstation) }
        print("\n\n------------------------------------------------------------------------")
    }
    
}
