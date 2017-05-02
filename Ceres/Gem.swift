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
        isUserInteractionEnabled = false
        zPosition = 8
        physicsBody = SKPhysicsBody(circleOfRadius: (size.height / 2) - 2.0) // Makes physics body circle slightly smaller than gem shape.
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0.25
        physicsBody?.categoryBitMask = GameScene.PhysicsCategories.Gem;
        physicsBody?.contactTestBitMask = GameScene.PhysicsCategories.GemCollector;
        physicsBody?.collisionBitMask = GameScene.PhysicsCategories.Gem | GameScene.PhysicsCategories.GemSource | GameScene.PhysicsCategories.StagePlanet;
    }
    
    
    public func setGemVelocity(velocity: CGFloat, angle: CGFloat) {
        // Sets the Velocity Magnitude and angle of gem
        
        physicsBody?.velocity = createProjectileVector(velocity: velocity, angle: angle)
    }
    
    private func createProjectileVector(velocity: CGFloat, angle: CGFloat) -> CGVector {
        // Takes a velocity and an angle in radians and returns a vector with the inputted angle and velocity.
        
        let dx = cos(angle) * velocity
        let dy = sin(angle) * velocity
        return CGVector(dx: dx, dy: dy)
    }
    
}
