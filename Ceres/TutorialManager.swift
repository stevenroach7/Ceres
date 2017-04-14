//
//  TutorialManager.swift
//  Ceres
//
//  Created by Steven Roach on 4/13/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialManager {
    
    var gameScene:GameScene
    let flickHand = SKSpriteNode(imageNamed: "touch")
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        gameScene.tutorialMode = true
    }
    
    public func startTutorialMode() {
        prepareTutorial()
    }
    
    private func prepareTutorial() {
        gameScene.physicsWorld.gravity = CGVector(dx: 0, dy: 0.01)
        addTutorialGem()
        makeTutorialHand()
    }
    
    private func makeTutorialHand() {
        let touch = SKAction.setTexture(SKTexture(imageNamed: "touch"))
        let drag  = SKAction.setTexture(SKTexture(imageNamed: "drag"))
        let flick = SKAction.setTexture(SKTexture(imageNamed: "flick"))
        
        flickHand.position = CGPoint(x: gameScene.size.width * 0.65, y: gameScene.size.height * 0.45)
        flickHand.setScale(0.3)
        flickHand.zPosition = 9
        gameScene.addChild(flickHand)
        
        let initiateTouch = SKAction.move(to: CGPoint(x: gameScene.size.width * 0.525, y: gameScene.size.height * 0.45), duration: 0.6)
        let moveDownSlow = SKAction.move(to: CGPoint(x: gameScene.size.width * 0.525, y: gameScene.size.height * 0.4), duration: 0.75)
        let moveDownFast = SKAction.move(to: CGPoint(x: gameScene.size.width * 0.525, y: gameScene.size.height * 0.15), duration: 0.5)
        let release = SKAction.move(to: CGPoint(x: gameScene.size.width * 0.55, y: gameScene.size.height * 0.175), duration: 0.15)
        let resetHand = SKAction.move(to: CGPoint(x: gameScene.size.width * 0.65, y: gameScene.size.height * 0.45), duration: 0.1)
        //let hide = SKAction.hide()
        //let show = SKAction.unhide()
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
            //show,
            ])
        flickHand.run(SKAction.repeatForever(tutorialAnimation))
    }
    
    public func addTutorialGem() {
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        gem.position = CGPoint(x: gameScene.size.width * 0.45, y: gameScene.size.height / 2)
        gameScene.addChild(gem)
    }
    
    public func tutorialGemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        gameScene.gemsPlusMinus += 1
        gameScene.recolorScore()
        gameScene.collectGemAnimation(collector: collector)
        gem.removeFromParent()
        endTutorial()
        gameScene.startGame()
    }
    
    public func endTutorial() {
        gameScene.tutorialMode = false
        
        flickHand.removeFromParent() // TODO: Move this elsewhere later if we want hand to be removed when user touches gem
        let scaleDown = SKAction.scale(by: 2/3, duration: 0.75)
        let finalScoreLabelPosition = CGPoint(x: gameScene.size.width * 0.75, y: gameScene.size.height - gameScene.size.height/20)
        let moveUp = SKAction.move(to: finalScoreLabelPosition, duration: 0.75)
        
        gameScene.scoreLabelPosX = finalScoreLabelPosition.x
        gameScene.scoreLabel.run(scaleDown)
        gameScene.scoreLabel.run(moveUp)
        
        let expand = SKAction.scale(by: 3/2, duration: 1.0)
        let shrink = SKAction.scale(by: 2/3, duration: 1.0)
        let expandAndShrink = SKAction.sequence([expand,shrink])
        gameScene.timerLabel.run(expandAndShrink)
    }
}
