
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
                SKAction.run({self.animationManager.animateGemSource(gemSource: self.leftGemSource)}),
                SKAction.wait(forDuration: 0.35),
                    SKAction.run({self.animationManager.animateGemSource(gemSource: self.rightGemSource)}),
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
        animationManager.flashGemsLabelAnimation(color: SKColor.green, percentGrowth: 1.075, label: gemsLabel)
        animationManager.animateGemCollector(collector: collector, implosion: false, size: size, layer: gameLayer)
        audioManager.play(sound: .gemCollectedSound)
        gem.removeFromParent()
    }
    
    public func detonatorGemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        
        let shakeCollector = animationManager.shakeAction(positionX: RelativePositions.Collector.getAbsolutePosition(size: size).x)
        collector.run(shakeCollector)
        animationManager.animateGemCollector(collector: collector, implosion: true, size: size, layer: gameLayer)
        
        audioManager.play(sound: .collectorExplosionSound)
        
        let shakeGemLabel = animationManager.shakeAction(positionX: RelativePositions.GemsLabel.getAbsolutePosition(size: size).x)
        gemsLabel.run(shakeGemLabel)
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        minusAlert()
        gemsPlusMinus -= 5
        animationManager.flashGemsLabelAnimation(color: SKColor.red, percentGrowth: 1.0, label: gemsLabel)

        gem.removeFromParent()
        checkGameOver()
    }
    
    public func gemOffScreen(gem: SKSpriteNode) {
        // Removes gems from game scene when they fly off screen
        
        gemsPlusMinus -= 1
        animationManager.flashGemsLabelAnimation(color: SKColor.red, percentGrowth: 0.925, label: gemsLabel)
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
            isGameOver = true // This flag prevents the gameOverTransition from getting called multiple times.
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
            view?.presentScene(scene, transition: transition)
        }
        removeAllActions()
    }
    
    private func minusAlert() {
        // Notifies player that they lost points after collecting flashing gem
        
        let minus = SKLabelNode(fontNamed: "Menlo-Bold")
        minus.text = "-5"
        minus.fontColor = SKColor.red
        minus.fontSize = 40
        minus.position = RelativePositions.MinusAlert.getAbsolutePosition(size: size)
        gameLayer.addChild(minus)
        
        animationManager.animateMinusAlert(node: minus, size: size)
    }
    
//    private func animateGemSource(gemSourceLocation: GemSourceLocation) {
//        switch gemSourceLocation {
//        case .left:
//            leftGemSource.run(SKAction.animate(with: animationManager.hammerFrames, timePerFrame: 0.35)) // Animation consists of 2 frames.
//        case .right:
//            rightGemSource.run(SKAction.animate(with: animationManager.hammerFrames, timePerFrame: 0.35))
//        }
//    }
}
