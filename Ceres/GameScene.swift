//
//  GameScene.swift
//  Ceres
//
//  Created by Steven Roach on 2/15/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, Alerts {
    
    var backButton = SKSpriteNode()
    let backButtonTex = SKTexture(imageNamed: "backLogo")
    
    var pauseButton = SKSpriteNode()
    let pauseButtonTex = SKTexture(imageNamed: "pause")
    
    var scoreLabel: SKLabelNode!
    var gemsCollected = 0 {
        didSet {
            scoreLabel.text = "Gems: \(gemsCollected)"
        }
    }
    
    var timerLabel: SKLabelNode!
    var timerSeconds = 60 {
        didSet {
            timerLabel.text = "Time: \(timerSeconds)"
        }
    }
    
    let gemCollector = SKSpriteNode(imageNamed: "collectorActive")
    let stagePlanet = SKSpriteNode(imageNamed: "planet")
    let gemSource = SKSpriteNode(imageNamed: "astronaut")
    let spaceship = SKSpriteNode(imageNamed: "Spaceship") // Temporary asset for what will become space mine cart
    var starfield:SKEmitterNode!
    
    
    override func didMove(to view: SKView) {
        // Called immediately after scene is presented.
       
        backgroundColor = SKColor.black // Set background color of scene.
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        backButton = SKSpriteNode(texture: backButtonTex)
        backButton.setScale(3/4)
        backButton.position = CGPoint(x: size.width/6, y: size.height - size.height/24) // TODO: Change how to calculate hieght, use constants
        addChild(backButton)
        
        pauseButton = SKSpriteNode(texture: pauseButtonTex)
        pauseButton.setScale(0.175)
        pauseButton.position = CGPoint(x: 9*size.width/10, y: size.height - size.height/24) // TODO: Change how to calculate hieght
        addChild(pauseButton)
        
        scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "Gems: 0"
        scoreLabel.fontSize = 13
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: size.width * (4/5), y: size.height - size.height/19)
        addChild(scoreLabel)
        
        
        timerLabel = SKLabelNode(fontNamed: "American Typewriter")
        timerLabel.text = "Timer: 60"
        timerLabel.fontSize = 15
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: size.width * (11/20), y: size.height - size.height/19)
        addChild(timerLabel)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run(decrementTimer)
                ])
        ))
        

        stagePlanet.position = CGPoint(x: size.width * 0.5, y: size.height * 0.05)
        stagePlanet.setScale(0.55)
        stagePlanet.name = "stagePlanet"
        addChild(stagePlanet)
        
        gemCollector.position = CGPoint(x: size.width * 0.75, y: size.height * 0.075)
        gemCollector.setScale(0.2)
        gemCollector.name = "gemCollector"
        gemCollector.zPosition = 2
        //gemCollector.isUserInteractionEnabled = false
        addChild(gemCollector)
        
        
        gemSource.position = CGPoint(x: size.width * 0.25, y: size.height * 0.1)
        gemSource.setScale(0.175)
        gemSource.name = "gemSource"
        gemSource.zPosition = 3
        gemSource.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        addChild(gemSource)
        
        let backgroundMusic = SKAudioNode(fileNamed: "cosmos.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    
    private func decrementTimer() {
        
        timerSeconds -= 1
        if (timerSeconds <= 0) {
            
            self.isPaused = true
            
            let gameOverAction = UIAlertAction(title: "Back to Home", style: .default)  { (action:UIAlertAction!) in
                if self.view != nil {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }}
            
            createAlert(title: "Game Over", message: "Score is \(gemsCollected)", success: gameOverAction)
            removeAllActions()
        }
    }
    
    
    // Helper methods to generate random numbers.
    private func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    private func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    private func addGem() {
        // Creates a gem sprite node and adds it to a random position on the upper half of the screen.
        
        // I changed the gem object back to being a SKSpriteNode because touch detection is now being handled in the Game Scene. SR
        let gem = SKSpriteNode(imageNamed: "gemShape1")
        gem.setScale(0.18)
        gem.name = "gem"
        gem.isUserInteractionEnabled = false
        
        // Calculate random position within upper half of the screen.
        let actualX = random(min: gem.size.width/2, max: size.width - gem.size.width/2)
        let actualY = random(min: size.height * 0.25, max: size.height - pauseButton.size.height - gem.size.height/2)
        
        gem.position = CGPoint(x: actualX, y: actualY)
        addChild(gem)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Method to handle touch events.
        
        // Choose the first touch to work with.
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if let name = touchedNode.name {
            
            switch name {
            case "gemSource":
                addGem()
            case "gem":
                touchedNode.removeFromParent()
                gemsCollected += 1
            default: break
                
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = atPoint(pos)
            
            switch node {
            case backButton:
                // self.isPaused = true // Pause action events. Add this back after a function to restart the game is written
                
                let okAction = UIAlertAction(title: "CONTINUE", style: UIAlertActionStyle.cancel)  { (action:UIAlertAction!) in
                    if self.view != nil {
                        let transition:SKTransition = SKTransition.fade(withDuration: 1)
                        let scene:SKScene = MenuScene(size: self.size)
                        self.view?.presentScene(scene, transition: transition)
                    }}
                
                createAlert(title: "WARNING", message: "You will lose your current progress", success: okAction)
            case pauseButton:
                self.isPaused = !self.isPaused
            default: break
            }
        }
    }
}
