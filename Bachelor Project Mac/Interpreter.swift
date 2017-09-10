//
//  Interpreter.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

class Interpreter {
    
    var presenter = Presenter.shared
    var simulator = Simulator()
    
    static var shared = Interpreter()
    private init() { }
    
    func startButtonPressed() {
        simulator.start()
    }
    
}
