//
//  Astronaut.swift
//  Ceres
//
//  Created by Sean Cheng on 5/3/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class Astronaut: SKSpriteNode {
    
    func setAstronautProperties() {
        // Sets initial properties of astronauts
        
        setScale(0.175)
        zPosition = 2
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 0.8, height: size.height * 0.8))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = false // Change this to true to be amused
        isUserInteractionEnabled = false // Must be set to false in order to register touch events.
    }
}
