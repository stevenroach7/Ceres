//
//  MainMenu.swift
//  Ceres
//
//  Created by Sean Cheng on 2/20/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    /***
    Initializes Nodes and Labels
    */
    
    let game = "Expedition Ceres"
    let title = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "play")
    
    var instructionsButton = SKSpriteNode()
    let instructionsButtonTex = SKTexture(imageNamed: "instructions")
    
    var starfield:SKEmitterNode!
    
    var ship = SKSpriteNode()
    let shipTex = SKTexture(imageNamed: "Spaceship")
    
    override func didMove(to view: SKView) {
        /***
        positions labels and nodes on screen
        */
        
        title.text = game
        title.fontSize = 45
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: size.height - size.height/6)
        addChild(title)
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.setScale(1/2)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY + size.height/12)
        addChild(playButton)
        
        instructionsButton = SKSpriteNode(texture: instructionsButtonTex)
        instructionsButton.setScale(1/2)
        instructionsButton.position = CGPoint(x: frame.midX, y: frame.midY - size.height/8)
        addChild(instructionsButton)
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
        
        ship = SKSpriteNode(texture: shipTex)
        ship.setScale(1/4)
        ship.position = CGPoint(x: size.width/2, y: size.height/2 - size.height/3)
        addChild(ship)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            //transitions to game screen if play button is touched
            if node == playButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            
            //transitions to instructions screen if instructions button is touched
            if node == instructionsButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = InstructionsScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
