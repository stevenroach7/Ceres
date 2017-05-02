//
//  GameScene+Collision.swift
//  Ceres
//
//  Created by Daniel Ochoa on 4/22/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit


extension GameScene { // Collision logic

    // Determines collisions between different objects
    public struct PhysicsCategories {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let GemCollector   : UInt32 = 0b1
        static let Wall: UInt32 = 0b10
        static let Gem: UInt32 = 0b11
        static let GemSource: UInt32 = 0b100
        static let StagePlanet: UInt32 = 0b101
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Called every time two physics bodies collide
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // categoryBitMasks are UInt32 values
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // If the two colliding bodies are a gem and gemCollector, remove the gem
        if ((firstBody.categoryBitMask == PhysicsCategories.GemCollector) && (secondBody.categoryBitMask == PhysicsCategories.Gem)) {
            if let gem = secondBody.node as? SKSpriteNode, let collector = firstBody.node as? SKSpriteNode {
                switch gem.name! {
                case "gem":
                    if !tutorialMode { // Check for tutorialMode being false first because that is more common
                        gemDidCollideWithCollector(gem: gem, collector: collector)
                    } else {
                        tutorialGemDidCollideWithCollector(gem: gem, collector: collector)
                    }
                case "detonatorGem":
                    detonatorGemDidCollideWithCollector(gem: gem, collector: collector)
                default:
                    break
                }
            }
        }
        
        // If the two colliding bodies are a gem and wall, remove the gem
        if ((firstBody.categoryBitMask == PhysicsCategories.Wall) &&
            (secondBody.categoryBitMask == PhysicsCategories.Gem)) {
            if let gem = secondBody.node as? SKSpriteNode {
                if !tutorialMode { // Check for tutorialMode being false first because that is more common
                    if gem.name == "gem" { // Don't penalize detonator gems going of screen
                        gemOffScreen(gem: gem)
                    } else {
                        gem.removeFromParent()
                    }
                } else {
                    gem.removeFromParent()
                    addTutorialGem()
                }
            }
        }
    }
}
