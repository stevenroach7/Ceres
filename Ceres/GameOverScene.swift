//
//  GameOverScene.swift
//  Ceres
//
//  Created by Sean Cheng on 3/25/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    /***
     Initializes Nodes and Labels
     */
    
    let gameLabel = "Game Over"
    let title = SKLabelNode(fontNamed: "GillSans-Bold")
    
    
    
    var score = 0
    let gemsLabel = SKLabelNode(fontNamed: "GillSans")
    
    var playButton = SKSpriteNode(imageNamed: "replay")
    var menuButton = SKSpriteNode(imageNamed: "menu")
    var starfield:SKEmitterNode!
    
    
    public func setScore(score: Int) {
        self.score = score
    }
    
    override func didMove(to view: SKView) {
        /***
         positions labels and nodes on screen
         */
        
        backgroundColor = SKColor.black
        
        title.text = gameLabel
        title.fontSize = 32
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: size.height - size.height/6)
        addChild(title)

        gemsLabel.text = "Score: \(score)"
        gemsLabel.fontSize = 28
        gemsLabel.fontColor = SKColor.white
        gemsLabel.position = CGPoint(x: frame.midX, y: frame.midY + size.height/4)
        addChild(gemsLabel)
        
        playButton.setScale(1/2)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY - size.height/5)
        addChild(playButton)
        
        menuButton.setScale(3/5)
        menuButton.position = CGPoint(x: frame.midX, y: frame.midY - size.height*2/5)
        addChild(menuButton)
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
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
            //transitions to main menu if main menu button is touched
            if node == menuButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.doorsCloseHorizontal(withDuration: 1)
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
