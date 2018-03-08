//
//  RunnableFactory.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 10.07.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

struct RunnableFactory {
    
    // MARK: - 🔧 Properties
    
    var layout: FactoryLayout
    
    // MARK: - ⚙️ Computed Properties
    // MARK: 🗝 Private Computed Properties
    
    private var settings: SimulationSettings {
        return SimulationSettings.shared
    }
    
    /// Returns all robots inside the factory
    private var robots: Set<Robot> {
        var robots: Set<Robot> = []
        for field in layout.fields {
            if let fieldRobots = field.robots {
                robots.formUnion(fieldRobots)
            }
        }
        return robots
    }
    
    /// Returns all workstations inside the factory
    private var workstations: Set<Workstation> {
        var workstations: Set<Workstation> = []
        for field in layout.fields {
            if let fieldWorkstation = field.workstation {
                workstations.insert(fieldWorkstation)
            }
        }
        return workstations
    }
    
    /// Returns true if all robots successfully completed their route
    private var allRobotsFinished: Bool {
        let unfinishedRobots = robots.filter { ($0.state != .finished) }
        return unfinishedRobots.count == 0
    }
    
    /// Returns true if the state of at least one robot in the factory is "blocked"
    private var atLeastOneRobotBlocked: Bool {
        let blockedRobots = robots.filter { ($0.state == .blocked) }
        return blockedRobots.count > 0
    }
    
    // MARK: - 📗 Functions
    
    /// Runs the simulation until all robots are either blocked or finished. Returns the rounds needed (aka the fitness).
    func calculateFitness() -> Int {
        var factoryCopy = self
        var stepCounter = 0
        repeat {
            factoryCopy.simulateNextStep()
            stepCounter += 1
        } while !(factoryCopy.allRobotsFinished || factoryCopy.atLeastOneRobotBlocked)
        return factoryCopy.atLeastOneRobotBlocked ? Int.max : stepCounter
    }
    
    // MARK: - 📕 Mutating Functions
    // MARK: 🔒 Private Mutating Functions
    
    /// Simulates one step for each robot
    private mutating func simulateNextStep() {
        for robot in robots {
            var modifiableRobot = robot
            var modifiedRobot = modifiableRobot.performStep(in: layout)
            layout.swap(robot, for: &modifiedRobot)
        }
    }
    
}
