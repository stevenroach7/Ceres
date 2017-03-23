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
        setScale(0.2)
        name = "gemCollector"
        zPosition = 2
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = GameScene.PhysicsCategory.GemCollector;
        physicsBody?.contactTestBitMask = GameScene.PhysicsCategory.Gem;
        physicsBody?.collisionBitMask = GameScene.PhysicsCategory.None;
    }
}
