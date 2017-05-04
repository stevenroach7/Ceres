
//  GameScene+Gameplay.swift
//  Ceres
//
//  Created by Steven Roach on 4/14/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import SpriteKit
import Foundation
import AudioToolbox.AudioServices

extension GameScene { // Gameplay
    
    enum GemSourceLocation {
        // Enum holds the locations where gems sources are located which is where gems may spawn from.
        case left
        case right
    }
    
    
    public func beginGameplay() {
        // Adjust gravity of scene
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0.27) // Gravity on Ceres is 0.27 m/s²
        
        gameLayer.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run({self.animateGemSource(gemSourceLocation: .left)}),
                SKAction.wait(forDuration: 0.35),
                SKAction.run({self.animateGemSource(gemSourceLocation: .right)}),
                SKAction.wait(forDuration: 0.35),
                ])
        ))
        
        gameLayer.run(SKAction.repeatForever( // Serves as timer, Could potentially refactor to use group actions later.
            SKAction.sequence([
                SKAction.run(spawnGems),
                SKAction.wait(forDuration: 1.0),
                SKAction.run(incrementTimer),
                ])
        ))
    }
    
    public func gemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        
        gemsPlusMinus += 1
        flashGemsLabelAnimation(color: SKColor.green, percentGrowth: 1.075)
        collectGemAnimation(collector: collector, implosion: false)
        audioManager.play(sound: .gemCollectedSound)
        gem.removeFromParent()
    }
    
    public func detonatorGemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        
        let shakeCollector = shakeAction(positionX: RelativePositions.Collector.getAbsolutePosition(size: size).x)
        collectGemAnimation(collector: collector, implosion: true)
        
        collector.run(shakeCollector)
        audioManager.play(sound: .collectorExplosionSound)
        
        let shakeGemLabel = shakeAction(positionX: RelativePositions.GemsLabel.getAbsolutePosition(size: size).x)
        gemsLabel.run(shakeGemLabel)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        minusAlert()
        gemsPlusMinus -= 5
        flashGemsLabelAnimation(color: SKColor.red, percentGrowth: 1.0)

        gem.removeFromParent()
        checkGameOver()
    }
    
    public func gemOffScreen(gem: SKSpriteNode) {
        // Removes gems from game scene when they fly off screen
        
        gemsPlusMinus -= 1
        flashGemsLabelAnimation(color: SKColor.red, percentGrowth: 0.925)
        gem.removeFromParent()
        checkGameOver()
    }

    public func onGemSourceTouch(gemSourceLocation: GemSourceLocation) {
        if !isPaused && !tutorialMode {
            addRegularGem(location: gemSourceLocation)
            audioManager.play(sound: .gemCreatedSound)
        }
        
    }
    
    private func incrementTimer() {
        timerSeconds += 1
    }
    
    private func checkGameOver() {
        // Calculates score to figure out when to end the game
        if gemsPlusMinus <= losingGemPlusMinus && !isGameOver {
            isGameOver = true // This is a hack to prevent the gameOverTransition from getting called multiple times.
            // It is used because we want to pause the gameScene but not add the pauseLayer. Simply disabling touches does not work and I don't want to add a backdoor to change the value of isPaused. SR
            gameOverTransition()
        }
    }
    
    private func gameOverTransition() {
        audioManager.stopBackgroundMusic()
        
        if view != nil {
            let transition:SKTransition = SKTransition.doorsCloseVertical(withDuration: 1)
            let scene = GameOverScene(size: size)
            scene.setScore(score: timerSeconds)
            scene.setHighScore()
            view?.presentScene(scene, transition: transition)
        }
        removeAllActions()
    }
    
    private func minusAlert() {
        let minus = SKLabelNode(fontNamed: "Menlo-Bold")
        minus.text = "-5"
        minus.fontColor = SKColor.red
        minus.fontSize = 30
        minus.position = RelativePositions.MinusAlert.getAbsolutePosition(size: size)
        gameLayer.addChild(minus)
        
        let moveDown = SKAction.moveTo(y: size.height * 0.7, duration: 0.6)
        minus.run(moveDown)
        minus.run(SKAction.fadeOut(withDuration: 1.0))
    }
    
    private func animateGemSource(gemSourceLocation: GemSourceLocation) {
        switch gemSourceLocation {
        case .left:
            leftGemSource.run(SKAction.animate(with: hammerFrames, timePerFrame: 0.35)) // Animation consists of 2 frames.
        case .right:
            rightGemSource.run(SKAction.animate(with: hammerFrames, timePerFrame: 0.35))
        }
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
}
