//
//  Interpreter.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

class Interpreter {
    
    private init() { }
    
    // MARK: - 🔨 Static Properties
    
    static var shared = Interpreter()
    
    // MARK: - 🔧 Properties
    // MARK: 🗝 Private Properties
    
    private var simulator = Simulator.shared
    
    // MARK: - ⚙️ Computed Properties
    // MARK: 🗝 Private Computed Properties
    
    private var presenter: Presenter {
        return Presenter.shared
    }
    
    // MARK: - 📗 Functions
    
    func startButtonPressed() {
        simulator.start()
    }
    
}
