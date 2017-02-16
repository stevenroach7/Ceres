//
//  GameScene.swift
//  Ceres
//
//  Created by Steven Roach on 2/15/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let asteroid = SKSpriteNode(imageNamed: "asteroid1")
    var starfield:SKEmitterNode!
    
    override func didMove(to view: SKView) {
        // Called immediately after scene is presented.
       
        backgroundColor = SKColor.black // Set background color of scene.
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y:size.height)
        starfield.advanceSimulationTime(10)
     
        
        
        self.addChild(starfield)
        
        starfield.zPosition = -1
        
        
        asteroid.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        asteroid.name = "asteroid"
        asteroid.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        addChild(asteroid)
        
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
        
        let gem = SKSpriteNode(imageNamed: "rock-gem")
        gem.setScale(2) // Double the size of the sprite.
        gem.name = "gem"
        
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
            if name == "asteroid" { // Add a gem if user touches asteroid.
                addGem()
            } else if name == "gem" { // If user touches gem, remove it.
                touchedNode.removeFromParent()
            }
        }
        
    }
    
}


// TODO: Create classes for asteroid and gems and handle touch events within those classes rather than in touchesBegan in GameScene.
