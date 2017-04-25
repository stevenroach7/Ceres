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
        setScoreLabel(font: 30, position: CGPoint(x: size.width/2, y: size.height * 0.7))
        collectorGlow.position = CGPoint(x: size.width * 0.525, y: size.height * 0.125)
        addChild(collectorGlow)
    }
    
    public func addTutorialGem() {
        let gem = Gem(imageNamed: "gemShape1")
        gem.name = "gem"
        gem.setGemProperties()  // Calls gem properties from Gem class
        gem.position = CGPoint(x: size.width * 0.5, y: size.height / 2)
        addChild(gem)
    }
    
    private func makeTutorialHand() {
        let touch = SKAction.setTexture(SKTexture(imageNamed: "touch"))
        let drag  = SKAction.setTexture(SKTexture(imageNamed: "drag"))
        let flick = SKAction.setTexture(SKTexture(imageNamed: "flick"))
        
        flickHand.position = CGPoint(x: size.width * 0.65, y: size.height * 0.45)
        flickHand.setScale(0.3)
        flickHand.zPosition = 9
        addChild(flickHand)
        
        let initiateTouch = SKAction.move(to: CGPoint(x: size.width * 0.55, y: size.height * 0.45), duration: 0.6)
        let moveDownSlow = SKAction.move(to: CGPoint(x: size.width * 0.55, y: size.height * 0.4), duration: 0.75)
        let moveDownFast = SKAction.move(to: CGPoint(x: size.width * 0.55, y: size.height * 0.225), duration: 0.3)
        let release = SKAction.move(to: CGPoint(x: size.width * 0.575, y: size.height * 0.25), duration: 0.15)
        let resetHand = SKAction.move(to: CGPoint(x: size.width * 0.675, y: size.height * 0.45), duration: 0.1)
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
    
    private func setScoreLabel(font: CGFloat, position: CGPoint) {
        // Tracks current game score
        
        scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "+/-: \(gemsPlusMinus)"
        scoreLabel.fontSize = font
        //scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = position
        addChild(scoreLabel)
    }
    
    public func tutorialGemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        
        gemsPlusMinus += 1
        recolorScore()
        collectGemAnimation(collector: collector)
        gem.removeFromParent()
        endTutorial()
        beginGameplay()
    }
    
    public func endTutorial() {
        tutorialMode = false
        
        collectorGlow.removeFromParent()
        flickHand.removeFromParent() // TODO: Move this elsewhere later if we want hand to be removed when user touches gem
        let scaleDown = SKAction.scale(by: 2/3, duration: 0.75)
        let finalScoreLabelPosition = CGPoint(x: size.width * 0.8, y: size.height - size.height/20)
        let moveUp = SKAction.move(to: finalScoreLabelPosition, duration: 0.75)
        
        scoreLabel.run(scaleDown)
        scoreLabel.run(moveUp)
        
        let expand = SKAction.scale(by: 3/2, duration: 1.0)
        let shrink = SKAction.scale(by: 2/3, duration: 1.0)
        let expandAndShrink = SKAction.sequence([expand,shrink])
        timerLabel.run(expandAndShrink)
    }
}
