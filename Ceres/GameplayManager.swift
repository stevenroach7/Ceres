//
//  GameplayManager.swift
//  Ceres
//
//  Created by Steven Roach on 4/14/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import SpriteKit
import Foundation
import AudioToolbox.AudioServices

class GameplayManager {
    
    var gameScene:GameScene
    
    let losingGemPlusMinus = -1 // Make this lower during testing
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    public func beginGameplay() {
        // Adjust gravity of scene
        gameScene.physicsWorld.gravity = CGVector(dx: 0, dy: 0.27) // Gravity on Ceres is 0.27 m/s²
        
        gameScene.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(animateLeftHammer),
                SKAction.wait(forDuration: 0.35),
                SKAction.run(animateRightHammer),
                SKAction.wait(forDuration: 0.35),
                ])
        ))
        
        gameScene.run(SKAction.repeatForever( // Serves as timer, Could potentially refactor to use group actions later.
            SKAction.sequence([
                SKAction.run(spawnGems),
                SKAction.wait(forDuration: 1.0),
                SKAction.run(incrementTimer),
                ])
        ))
    }
    
    public func gemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        gameScene.gemsPlusMinus += 1
        gameScene.recolorScore()
        gameScene.collectGemAnimation(collector: collector)
        gem.removeFromParent()
        
        
    }
    
    public func detonatorGemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        
        let shakeCollector = shakeAction(positionX: gameScene.gemCollectorPosX)
        gameScene.collectGemAnimation(collector: collector)
        
        collector.run(shakeCollector)
        gameScene.run(gameScene.collectorExplosionSound)
        
        let shakeScore = shakeAction(positionX: gameScene.scoreLabel.position.x)
        gameScene.scoreLabel.run(shakeScore)
        minusFiveAlert()
        gameScene.recolorScore()
        gameScene.gemsPlusMinus -= 5
        
        gem.removeFromParent()
        checkGameOver()
    }
    
    public func gemOffScreen(gem: SKSpriteNode) {
        // Removes gems from game scene when they fly off screen
        gameScene.gemsPlusMinus -= 1
        gameScene.recolorScore()
        gem.removeFromParent()
        minusOneAlert()
        checkGameOver()
    }
    
    public func onLeftGemSourceTouch() {
        if !gameScene.isPaused && !gameScene.tutorialMode {
            addGemLeft()
            gameScene.run(gameScene.gemCreatedSound)
        }
    }
    
    public func onRightGemSourceTouch() {
        if !gameScene.isPaused && !gameScene.tutorialMode {
            addGemRight()
            gameScene.run(gameScene.gemCreatedSound)
        }
    }
    
    private func incrementTimer() {
        gameScene.timerSeconds += 1
        if (gameScene.timerSeconds % 10 >= 7){
            gameScene.timerLabel.fontSize += 1
            gameScene.run(gameScene.zoomTimerSound)
        } else if (gameScene.timerSeconds % 10 == 0 && gameScene.timerSeconds > 0){
            gameScene.run(gameScene.zipTimerSound)
            gameScene.timerLabel.fontSize -= 3
            gameScene.timerLabel.fontColor = SKColor.cyan
        } else {
            gameScene.timerLabel.fontColor = SKColor.white
        }
    }
    
    private func checkGameOver() {
        // Calculates score to figure out when to end the game
        if gameScene.gemsPlusMinus <= losingGemPlusMinus {
            gameOverTransition()
        }
    }
    
    private func gameOverTransition() {
        gameScene.isPaused = true
        if gameScene.view != nil {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = GameOverScene(size: gameScene.size)
            scene.setScore(score: gameScene.timerSeconds)
            gameScene.view?.presentScene(scene, transition: transition)
        }
        gameScene.removeAllActions()
    }
    
    
    private func spawnGems() { // TODO: Possibly refactor so that gamSpawn Sequences are in a sequence instead of being called based on the timerSeconds value.
        // Called every second, calls gem spawning sequences based on game timer
        if gameScene.timerSeconds % 10 == 0 {
            switch gameScene.timerSeconds {
            case 0:
                gemSpawnSequence1()
            case 10:
                gemSpawnSequence2()
            case 20:
                gemSpawnSequenceBasicDetonators()
            case 30:
                gemSpawnSequence3()
            case 40:
                gemSpawnSequence4()
            case 50:
                gemSpawnSequence4()
            case 60:
                gemSpawnSequence3()
            default:
                gemSpawnSequenceHard()
            }
        }
    }
    
    private func gemSpawnSequence1() {
        // Gem spawning routine
        gameScene.run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run(addGemLeft), SKAction.wait(forDuration: 1.0), SKAction.run(addGemRight)]), count: 5))
    }
    
    private func gemSpawnSequence2() {
        // Gem spawning routine
        gameScene.run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.25),
                                               SKAction.run(addGemRight),
                                               ]),
                            count: 8))
    }
    
    private func gemSpawnSequence3() {
        // Gem spawning routine
        gameScene.run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.25),
                                               SKAction.run(addGemRight),
                                               SKAction.run({self.detonateGemSequence(timeToExplosion: 2.0)}),
                                               SKAction.wait(forDuration: 0.25),
                                               SKAction.run(addGemLeft),
                                               SKAction.run(addGemRight),
                                               
                                               ]),
                            count: 7))
    }
    
    private func gemSpawnSequence4() {
        gameScene.run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 2.47),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run({self.detonateGemSequence(timeToExplosion: 2.0)}),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run({self.detonateGemSequence(timeToExplosion: 2.0)}),
                                               
                                               SKAction.wait(forDuration: 2.47),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run({self.detonateGemSequence(timeToExplosion: 2.0)}),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               ]),
                            count: 2))
    }
    
    private func gemSpawnSequenceBasicDetonators() {
        gameScene.run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 2.47),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run({self.detonateGemSequence(timeToExplosion: 2.0)}),
                                               
                                               
                                               SKAction.wait(forDuration: 2.47),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run({self.detonateGemSequence(timeToExplosion: 2.0)}),
                                               ]),
                            count: 2))
    }
    
    private func gemSpawnSequenceHard() {
        gameScene.run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 0.74),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run({self.detonateGemSequence(timeToExplosion: 2.0)}),
                                               
                                               SKAction.wait(forDuration: 0.2),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               SKAction.run(addGemRight),
                                               SKAction.run({self.detonateGemSequence(timeToExplosion: 2.0)}),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               ]),
                            count: 10))
    }
    
    // TODO: Refactor to make addGem one method that takes a parameter to change the spawning location
    private func addGemLeft() {
        // Produces a Gem from the left astronaut
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        let angle = random(min: CGFloat.pi * (1/4), max: CGFloat.pi * (1/2))
        let velocity = random(min: 170, max: 190)
        gem.setGemVelocity(velocity: velocity, angle: angle)
        gem.position = CGPoint(x: gameScene.size.width * 0.15, y: gameScene.size.height * 0.15)
        gameScene.addChild(gem)
    }
    
    private func addGemRight() {
        // Produces a Gem from the right astronaut
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        let angle = random(min: CGFloat.pi * (1/2), max: CGFloat.pi * (3/4))
        let velocity = random(min: 170, max: 190)
        gem.setGemVelocity(velocity: velocity, angle: angle)
        gem.position = CGPoint(x: gameScene.size.width * 0.85, y: gameScene.size.height * 0.15)
        gameScene.addChild(gem)
    }
    
    private func addDetonatorGem(detonatorGem: Gem) { // TODO: Refactor this to take a parameter for left and right.
        // Takes a gem and adds it to the scene in a manner specific to detonator gems
        detonatorGem.setGemProperties()  // Sets gem properties from Gem class
        detonatorGem.name = "detonatorGem"
        let angle = random(min: CGFloat.pi * (1/4), max: CGFloat.pi * (3/8))
        let velocity = random(min: 100, max: 120)
        detonatorGem.setGemVelocity(velocity: velocity, angle: angle)
        let spawnLocation = CGPoint(x: gameScene.size.width * 0.15, y: gameScene.size.height * 0.15)
        detonatorGem.position = spawnLocation
        gameScene.addChild(detonatorGem)
    }
    
    private func flashDetonatorGemAnimation(duration: Double) -> SKAction {
        // Takes an animation duration and returns an animation to flash a detonator gem once
        let flashAction = SKAction.setTexture(SKTexture(imageNamed: "mostlyWhiteRottenGem"))
        let unFlashAction = SKAction.setTexture(SKTexture(imageNamed: "rottenGem"))
        
        let flashAnimation = SKAction.sequence([
            flashAction,
            SKAction.wait(forDuration: duration / 2),
            unFlashAction,
            SKAction.wait(forDuration: duration / 2)
            ])
        return flashAnimation
    }
    
    private func animateDetonatorGem(detonatorGem: Gem) {
        // Takes a detonatorGem and runs a flashing animation on it
        let flashDuration = 0.25
        detonatorGem.run(SKAction.repeat(SKAction.sequence([
            {self.flashDetonatorGemAnimation(duration: flashDuration)}(),
            ]), count: 20))
    }
    
    private func detonateGem(detonatorGem: Gem, gravityFieldNode: SKFieldNode) {
        // Takes a detonator gem and a gravityFieldNode to add to the scene and simulates the gem exploding in the scene
        if detonatorGem.parent != nil { // Don't simulate explosion if gem has been removed
            let gemPosition = detonatorGem.position
            detonatorGem.removeFromParent()
            
            let gemExplosion = SKEmitterNode(fileNamed: "gemExplosion")!
            gemExplosion.position = gemPosition
            gameScene.addChild(gemExplosion)
            
            gameScene.run(gameScene.gemExplosionSound)
            
            gravityFieldNode.name = "gravityFieldNode"
            gravityFieldNode.strength = -30
            gravityFieldNode.position = gemPosition
            gameScene.addChild(gravityFieldNode)
        }
    }
    
    private func detonationCleanup(gravityFieldNode: SKFieldNode) {
        // Takes a gravityFieldNode and removes it from the scene to end the gem explosion simulation.
        if gravityFieldNode.parent != nil {
            gravityFieldNode.removeFromParent()
        }
    }
    
    private func detonateGemSequence(timeToExplosion: Double) {
        // Adds a detonating gem to the scene and makes it explode in timeToExplosion seconds.
        let detonatorGem = Gem(imageNamed: "rottenGem")
        let gravityFieldNode = SKFieldNode.radialGravityField()
        
        gameScene.run(SKAction.sequence([
            SKAction.run({self.addDetonatorGem(detonatorGem: detonatorGem)}),
            SKAction.run({self.animateDetonatorGem(detonatorGem: detonatorGem)}),
            SKAction.wait(forDuration: timeToExplosion),
            SKAction.run({self.detonateGem(detonatorGem: detonatorGem, gravityFieldNode: gravityFieldNode)}),
            SKAction.wait(forDuration: 0.25),
            SKAction.run({self.detonationCleanup(gravityFieldNode: gravityFieldNode)})
            ]))
    }
    
    private func minusOneAlert() {
        let minusOne = SKLabelNode(fontNamed: "Menlo-Bold")
        minusOne.text = "-1"
        minusOne.fontColor = SKColor.red
        minusOne.fontSize = 30
        minusOne.position = CGPoint(x: gameScene.size.width * 0.8, y: gameScene.size.height * 0.9)
        let moveDown = SKAction.moveTo(y: gameScene.size.height * 0.7, duration: 1.0)
        gameScene.addChild(minusOne)
        
        minusOne.run(moveDown)
        minusOne.run(SKAction.fadeOut(withDuration: 1.0))
    }
    
    private func minusFiveAlert(){
        let minusFive = SKLabelNode(fontNamed: "Menlo-Bold")
        minusFive.text = "-5"
        minusFive.fontColor = SKColor.red
        minusFive.fontSize = 32
        minusFive.position = CGPoint(x: gameScene.size.width * 0.5, y: gameScene.size.height * 0.15)
        let moveUp = SKAction.move(to: CGPoint(x: gameScene.size.width * 0.5, y: gameScene.size.height), duration: 2.5)
        gameScene.addChild(minusFive)
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        minusFive.run(moveUp)
        minusFive.run(SKAction.fadeOut(withDuration: 2.5))
    }

    private func animateLeftHammer() { // Need a function without arguments to be called in the SKAction
        gameScene.leftGemSource.run(SKAction.animate(with: gameScene.hammerFrames, timePerFrame: 0.35)) // Animation consists of 2 frames.
    }
    
    private func animateRightHammer() { // Need a function without arguments to be called in the SKAction
        gameScene.rightGemSource.run(SKAction.animate(with: gameScene.hammerFrames, timePerFrame: 0.35)) // Animation consists of 2 frames.
    }
    
    private func shakeAction(positionX : CGFloat) -> SKAction {
        //returns a shaking animation
        
        //defining a shake sequence
        var sequence = [SKAction]()
        
        //Filling the sequence
        for i in (1...4).reversed() {
            let moveRight = SKAction.moveBy(x: CGFloat(i*2), y: 0, duration: TimeInterval(0.05))
            sequence.append(moveRight)
            let moveLeft = SKAction.moveBy(x: CGFloat(-4*i), y: 0, duration: TimeInterval(0.1))
            sequence.append(moveLeft)
            let moveOriginal = SKAction.moveBy(x: CGFloat(i*2), y: 0, duration: (TimeInterval(0.05)))
            sequence.append(moveOriginal)
        }
        sequence.append(SKAction.moveTo(x: positionX, duration: 0.05)) //Return to original x position
        let shake = SKAction.sequence(sequence)
        return shake
    }
    
    // Helper methods to generate random numbers.
    private func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    private func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
