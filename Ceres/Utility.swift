//
//  Utility.swift
//  Ceres
//
//  Created by Steven Roach on 4/22/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit


class Utility {
    
    // Helper methods to generate random numbers between min and max inclusive.
    private static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    // From http://stackoverflow.com/questions/24058195/what-is-the-easiest-way-to-generate-random-integers-within-a-range-in-swift
    public static func random(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
}
