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
    
    var backButton = SKSpriteNode()
    let backButtonTex = SKTexture(imageNamed: "back")
    
    let gemSource = SKSpriteNode(imageNamed: "asteroid1")
    let spaceship = SKSpriteNode(imageNamed: "Spaceship") //Temporary asset for what will become space mine cart
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
        backButton.position = CGPoint(x: size.width/6, y: size.height - size.height/24)
        addChild(backButton)
        
        
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
        
        let gem = Gem(imageNamed: "rock-gem")
        gem.setScale(2) // Double the size of the sprite.
        gem.name = "gem"
        gem.isUserInteractionEnabled = true
        
        // Calculate random position within upper half of the screen.
        let actualX = random(min: gem.size.width/2, max: size.width - gem.size.width/2)
        let actualY = random(min: size.height/2, max: size.height - gem.size.height/2)
        
        gem.position = CGPoint(x: actualX, y: actualY)
        
        addChild(gem)
    }
    
    
//    private func dragSprite(currNode: SKNode, translation: CGPoint){
//        // Dragging functionality
//        
//        let position = currNode.position
//        
//        if currNode.name == "gem" {
//            currNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Method to handle touch events.
        
        // Choose the first touch to work with.
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        
        let touchedNode = atPoint(touchLocation)
        
        if let name = touchedNode.name {
            if name == "gemSource" { // Add a gem if user touches asteroid.
                addGem()
//            } else if name == "gem" { // If user touches gem, remove it.
//                touchedNode.removeFromParent()
//            
//       }
            }
        }
    }
    
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
//        let positionInScene = touch.location(in: self)
//        let touchedNode = atPoint(positionInScene)
//        let previousPosition = touch.previousLocation(in: self)
//        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
//        
//        
//        dragSprite(currNode: touchedNode, translation: translation)
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            //transitions back to menu screen if back button is touched
            if node == backButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
    
}


// TODO: Create classes for asteroid and gems and handle touch events within those classes rather than in touchesBegan in GameScene.
