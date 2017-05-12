//
//  GameScene+Tutorial.swift
//  Ceres
//
//  Created by Steven Roach on 4/13/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene { // Tutorial 
    

    public func startTutorialMode() {
        tutorialMode = true
        prepareTutorial()
    }
    
    private func prepareTutorial() {
        // Sets up the tutorial at the beginning of the game
        physicsWorld.gravity = CGVector(dx: 0, dy: 0.0)
        addTutorialGem()
        makeTutorialHand()
        setGemsLabel(font: 20, position: RelativePositions.InitialGemsLabel.getAbsolutePosition(size: size))
        gemsLabel.setScale(3/2) // Set scale to be bigger than usual when label is first displayed
        collectorGlow.position = RelativePositions.CollectorGlow.getAbsolutePosition(size: size)
        gameLayer.addChild(collectorGlow)
    }
    
    public func addTutorialGem() {
        let gem = Gem(imageNamed: "gemShape1")
        gem.name = "gem"
        gem.setGemProperties()  // Calls gem properties from Gem class
        gem.position = RelativePositions.TutorialGem.getAbsolutePosition(size: size)
        gameLayer.addChild(gem)
    }
    
    private func makeTutorialHand() {
        // Creates hand that imitates a flicking motion
        
        flickHand.position = RelativePositions.FlickHand.getAbsolutePosition(size: size)
        flickHand.setScale(0.3)
        flickHand.zPosition = 9
        gameLayer.addChild(flickHand)
        
        animationManager.flickHandAnimation(size: size, node: flickHand)
    }
    
    private func setGemsLabel(font: CGFloat, position: CGPoint) {
        // Tracks current game score
        
        gemsLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        gemsLabel.text = "Gems: \(gemsPlusMinus)"
        gemsLabel.fontSize = font
        gemsLabel.position = position
        gameLayer.addChild(gemsLabel)
    }
    
    public func tutorialGemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        
        gemsPlusMinus += 1
        animationManager.flashGemsLabelAnimation(color: SKColor.green, percentGrowth: 1.0, label: gemsLabel)
        animationManager.animateGemCollector(collector: collector,implosion: false, size: size, layer: gameLayer)
        audioManager.play(sound: .gemCollectedSound)
        gem.removeFromParent()
        endTutorial()
        beginGameplay()
    }
    
    public func endTutorial() {
        // Transitions from tutorial to actual game
        
        tutorialMode = false
        
        collectorGlow.removeFromParent()
        flickHand.removeFromParent()
        let scaleDown = SKAction.scale(by: 2/3, duration: 0.75)
        let moveUp = SKAction.move(to: RelativePositions.GemsLabel.getAbsolutePosition(size: size), duration: 0.75)
        
        gemsLabel.run(scaleDown) // Scale gems label back to normal size
        gemsLabel.run(moveUp)
        
        let expand = SKAction.scale(by: 3/2, duration: 1.0)
        let shrink = SKAction.scale(by: 2/3, duration: 1.0)
        let expandAndShrink = SKAction.sequence([expand,shrink])
        scoreLabel.run(expandAndShrink)
    }
}
