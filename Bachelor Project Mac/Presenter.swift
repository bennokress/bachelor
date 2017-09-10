//
//  Presenter.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import Foundation

class Presenter {
    
    static var shared = Presenter()
    
    private init() {
        
    }
    
    func displayInView(message: String) {
        // TODO: Add reference to ViewController in order to display something later on ...
        print("Display this message in View:")
        print(message)
    }
    
}
