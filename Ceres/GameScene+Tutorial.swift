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
        physicsWorld.gravity = CGVector(dx: 0, dy: 0.0)
        addTutorialGem()
        makeTutorialHand()
        setGemsLabel(font: 20, position: relativePosToAbsolute(relativePos: RelativeNodePosition.InitialGemsLabel))
        gemsLabel.setScale(3/2) // Set scale to be bigger than usual when label is first displayed
        collectorGlow.position = relativePosToAbsolute(relativePos: RelativeNodePosition.CollectorGlow)
        addChild(collectorGlow)
    }
    
    public func addTutorialGem() {
        let gem = Gem(imageNamed: "gemShape1")
        gem.name = "gem"
        gem.setGemProperties()  // Calls gem properties from Gem class
        gem.position = relativePosToAbsolute(relativePos: RelativeNodePosition.TutorialGem)
        addChild(gem)
    }
    
    private func makeTutorialHand() {
        let touch = SKAction.setTexture(SKTexture(imageNamed: "touch"))
        let drag  = SKAction.setTexture(SKTexture(imageNamed: "drag"))
        let flick = SKAction.setTexture(SKTexture(imageNamed: "flick"))
        
        flickHand.position = relativePosToAbsolute(relativePos: RelativeNodePosition.FlickHand)
        flickHand.setScale(0.3)
        flickHand.zPosition = 9
        addChild(flickHand)
        
        let initiateTouch = SKAction.move(to: relativePosToAbsolute(relativePos: RelativeNodePosition.FlickHandTouch), duration: 0.6)
        let moveDownSlow = SKAction.move(to: relativePosToAbsolute(relativePos: RelativeNodePosition.FlickHandDownSlow), duration: 0.75)
        let moveDownFast = SKAction.move(to: relativePosToAbsolute(relativePos: RelativeNodePosition.FlickHandDownFast), duration: 0.3)
        let release = SKAction.move(to: relativePosToAbsolute(relativePos: RelativeNodePosition.FlickHandRelease), duration: 0.15)
        let resetHand = SKAction.move(to: relativePosToAbsolute(relativePos: RelativeNodePosition.FlickHandReset), duration: 0.1)
        let shortWait = SKAction.wait(forDuration: 0.2)
        let longWait = SKAction.wait(forDuration: 1.25)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let fadeIn  = SKAction.fadeIn(withDuration: 0.5)
        
        
        let tutorialAnimation = SKAction.sequence([
            touch,
            fadeIn,
            initiateTouch,
            drag,
            moveDownSlow,
            moveDownFast,
            flick,
            release,
            shortWait,
            fadeOut,
            resetHand,
            longWait,
            ])
        flickHand.run(SKAction.repeatForever(tutorialAnimation))
    }
    
    private func setGemsLabel(font: CGFloat, position: CGPoint) {
        // Tracks current game score
        
        gemsLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        gemsLabel.text = "Gems: \(gemsPlusMinus)"
        gemsLabel.fontSize = font
        //gemsLabel.horizontalAlignmentMode = .right
        gemsLabel.position = position
        addChild(gemsLabel)
    }
    
    public func tutorialGemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        
        gemsPlusMinus += 1
        flashGemsLabelAnimation(color: SKColor.green, percentGrowth: 1.0)
        collectGemAnimation(collector: collector,implosion: false)
        audioManager.play(sound: .gemCollectedSound)
        gem.removeFromParent()
        endTutorial()
        beginGameplay()
    }
    
    public func endTutorial() {
        tutorialMode = false
        
        collectorGlow.removeFromParent()
        flickHand.removeFromParent()
        let scaleDown = SKAction.scale(by: 2/3, duration: 0.75)
        let moveUp = SKAction.move(to: relativePosToAbsolute(relativePos: RelativeNodePosition.GemsLabel), duration: 0.75)
        
        gemsLabel.run(scaleDown) // / Scale gems label back to normal size
        gemsLabel.run(moveUp)
        
        let expand = SKAction.scale(by: 3/2, duration: 1.0)
        let shrink = SKAction.scale(by: 2/3, duration: 1.0)
        let expandAndShrink = SKAction.sequence([expand,shrink])
        scoreLabel.run(expandAndShrink)
    }
}
