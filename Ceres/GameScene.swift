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
    let backButtonTex = SKTexture(imageNamed: "back")
    
    var pauseButton = SKSpriteNode()
    let pauseButtonTex = SKTexture(imageNamed: "pause")
    
    var scoreLabel: SKLabelNode!
    var gemsCollected = 0 {
        didSet {
            scoreLabel.text = "Gems Collected: \(gemsCollected)"
        }
    }
    
    let gemSource = SKSpriteNode(imageNamed: "asteroid1")
    let spaceship = SKSpriteNode(imageNamed: "Spaceship") // Temporary asset for what will become space mine cart
    var starfield:SKEmitterNode!
    
    
    override func didMove(to view: SKView) {
        // Called immediately after scene is presented.
       
        backgroundColor = SKColor.black // Set background color of scene.
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
        
        backButton = SKSpriteNode(texture: backButtonTex)
        backButton.setScale(1/3)
        backButton.position = CGPoint(x: size.width/6, y: size.height - size.height/24) // TODO: Change how to calculate hieght, use constants
        addChild(backButton)
        
        pauseButton = SKSpriteNode(texture: pauseButtonTex)
        pauseButton.setScale(1/4)
        pauseButton.position = CGPoint(x: 9*size.width/10, y: size.height - size.height/19) // TODO: Change how to calculate hieght
        addChild(pauseButton)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Gems Collected: 0"
        scoreLabel.fontSize = 13
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: size.width * (4/5), y: size.height - size.height/19)
        addChild(scoreLabel)
        
        gemSource.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        gemSource.name = "gemSource"
        gemSource.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        addChild(gemSource)
        
        //Replace this with space minecart when available
//        spaceship.setScale(1/4)
//        spaceship.position = CGPoint(x: size.width * 0.3, y: size.height * 0.40)
//        spaceship.name = "spaceship"
//        spaceship.isUserInteractionEnabled = true
//        
//        self.addChild(spaceship)
        
        let backgroundMusic = SKAudioNode(fileNamed: "cosmos.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
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
        
        // I changed the gem object back to being a SKSpriteNode because touch detection is now being handled in the Game Scene.
        let gem = SKSpriteNode(imageNamed: "rock-gem")
        gem.setScale(2) // Double the size of the sprite.
        gem.name = "gem"
        gem.isUserInteractionEnabled = false
        
        // Calculate random position within upper half of the screen.
        let actualX = random(min: gem.size.width/2, max: size.width - gem.size.width/2)
        let actualY = random(min: size.height/2, max: size.height - gem.size.height/2)
        
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
            
            //transitions back to menu screen if back button is touched
            if node == backButton {
                let okAction = UIAlertAction(title: "CONTINUE", style: UIAlertActionStyle.cancel)  { (action:UIAlertAction!) in
                    if self.view != nil {
                        let transition:SKTransition = SKTransition.fade(withDuration: 1)
                        let scene:SKScene = MenuScene(size: self.size)
                        self.view?.presentScene(scene, transition: transition)
                    }}
                
                createAlert(title: "WARNING", message: "You will lose your current progress", success: okAction)
            }
        }
    }
}
