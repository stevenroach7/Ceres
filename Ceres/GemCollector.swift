//
//  GemCollector.swift
//  Ceres
//
//  Created by Sean Cheng on 3/22/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import GameplayKit

class GemCollector: SKSpriteNode {
    
    func setGemCollectorProperties() {
        // Sets initial properties of the gem collector
        
        setScale(0.23)
        name = "gemCollector"
        zPosition = 5
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width - 17, height: size.height - 17))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = GameScene.PhysicsCategories.GemCollector;
        physicsBody?.contactTestBitMask = GameScene.PhysicsCategories.Gem;
        physicsBody?.collisionBitMask = GameScene.PhysicsCategories.None;
    }
}
