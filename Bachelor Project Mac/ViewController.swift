//
//  ViewController.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    // MARK: - 🏀 Outlets
    
    @IBOutlet weak var startButton: NSButton!
    
    // MARK: - ⚙️ Computed Properties
    // MARK: 🗝 Private Computed Properties
    
    private var interpreter: Interpreter {
        return Interpreter.shared
    }
    
    // MARK: - ⛹🏼‍♂️ Actions
    
    @IBAction func startButtonPressed(_ sender: Any) {
        interpreter.startButtonPressed()
        // TODO: [IMPROVEMENT] Disable Start Button until simulation is finished
    }
    
    // MARK: - 📗 Functions
    // MARK: 📱 View Functions (Override)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}

