//
//  StagePlanet.swift
//  Ceres
//
//  Created by Sean Cheng on 3/22/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import GameplayKit

class StagePlanet: SKSpriteNode {
    
    func setStagePlanetProperties() {
        // Sets initial properties of the stage
        
        setScale(0.55)
        name = "stagePlanet"
        zPosition  = -1
        physicsBody = SKPhysicsBody(circleOfRadius: 800, center: CGPoint(x: frame.midX-10, y: -790))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = GameScene.PhysicsCategories.StagePlanet;
        physicsBody?.contactTestBitMask = GameScene.PhysicsCategories.Gem;
        physicsBody?.collisionBitMask = GameScene.PhysicsCategories.None;
        
    }
}
