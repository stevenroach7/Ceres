//
//  MenuScene.swift
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
    
    let titleText = "Expedition Ceres"
    let titleLabel = SKLabelNode(fontNamed: "Optima-Bold")
    var ship = SKSpriteNode(imageNamed: "stellaNovaShip")
    var starfield:SKEmitterNode!
    
    var playButton = SKSpriteNode(imageNamed: "play")
    var instructionsButton = SKSpriteNode(imageNamed: "instructions")
    
    override func didMove(to view: SKView) {
        /***
        positions labels and nodes on screen
        */
        
        titleLabel.text = titleText
        titleLabel.fontSize = 32
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height - size.height/6)
        addChild(titleLabel)
        
        playButton.setScale(0.6)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY + size.height/12)
        addChild(playButton)
        
        instructionsButton.setScale(0.5)
        instructionsButton.position = CGPoint(x: frame.midX, y: frame.midY - size.height/8)
        addChild(instructionsButton)
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
        
        ship.setScale(0.5)
        ship.position = CGPoint(x: size.width/2, y: size.height/5)
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
                    scene.name = "game"
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            
            //transitions to instructions screen if instructions button is touched
            if node == instructionsButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    let scene:SKScene = InstructionsScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
