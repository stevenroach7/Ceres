//
//  GemSource.swift
//  Ceres
//
//  Created by Sean Cheng on 3/23/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import GameplayKit

class GemSource: SKSpriteNode {
    
    func setGemSourceProperties() {
        // Sets initial properties of the gem source
        setScale(0.18)
        name = "gemSource"
        zPosition = 3
        // Currently using a rectangular body, may change to something more precise later
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.8*(size.width), height: 0.9*(size.height)))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = false
        isUserInteractionEnabled = false // Must be set to false in order to register touch events.
    }
}
