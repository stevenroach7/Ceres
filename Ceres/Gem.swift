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
        zPosition = 8
        physicsBody = SKPhysicsBody(circleOfRadius: max(size.width / 2, size.height / 2)) // Creating a circular physics body around each of the gems. Maybe change this shape later.
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0.5
        physicsBody?.categoryBitMask = GameScene.PhysicsCategory.Gem;
        physicsBody?.contactTestBitMask = GameScene.PhysicsCategory.GemCollector;
        physicsBody?.collisionBitMask = GameScene.PhysicsCategory.Gem | GameScene.PhysicsCategory.GemSource | GameScene.PhysicsCategory.StagePlanet;
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
