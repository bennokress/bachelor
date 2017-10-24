//
//  ViewController.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var startButton: NSButton!
    
    var interpreter = Interpreter.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startButtonPressed(_ sender: Any) {
        interpreter.startButtonPressed()
        // TODO: [IMPROVEMENT] Disable Start Button until simulation is finished
    }

}

