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
        
        let angle = GameScene.random(min: CGFloat.pi/4, max: CGFloat.pi * (3/4))
        physicsBody?.velocity = createProjectileVector(velocity: 250, angle: angle)
    }
    
    private func createProjectileVector(velocity: CGFloat, angle: CGFloat) -> CGVector {
        // Takes a velocity and an angle in radians and returns a vector with the inputted angle and velocity.
        let dx = cos(angle) * velocity
        let dy = sin(angle) * velocity
        return CGVector(dx: dx, dy: dy)
    }
}
