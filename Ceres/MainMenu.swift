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
    
    let game = "Expedition Ceres"
    let title = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "play")
    
    var instructionsButton = SKSpriteNode()
    let instructionsButtonTex = SKTexture(imageNamed: "instructions")
    
    override func didMove(to view: SKView) {
        
        title.text = game
        title.fontSize = 45
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: size.height - size.height/4)
        addChild(title)
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.setScale(1/2)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playButton)
        
        instructionsButton = SKSpriteNode(texture: instructionsButtonTex)
        instructionsButton.setScale(1/2)
        instructionsButton.position = CGPoint(x: frame.midX, y: frame.midY - size.height/4)
        addChild(instructionsButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
