//
//  Gem.swift
//  Ceres
//
//  Created by Daniel Ochoa on 2/21/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import GameplayKit

class Gem: SKSpriteNode {
        

    func setGemProperties() {
        // Initializes initial properties a gem should have.
        
        setScale(0.23)
        name = "gem"
        isUserInteractionEnabled = false
        physicsBody = SKPhysicsBody(circleOfRadius: max(size.width / 2, size.height / 2)) // Creating a circular physics body around each of the gems. Maybe change this shape later.
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0.9
        physicsBody?.velocity = CGVector(dx: 100, dy: 500)
    }
    
}
