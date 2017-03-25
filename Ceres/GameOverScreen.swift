//
//  GameOverScreen.swift
//  Ceres
//
//  Created by Sean Cheng on 3/25/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScreen: SKScene {
    
    let gameLabel = "Game Over"
    let title = SKLabelNode(fontNamed: "GillSans-Bold")
    
    let playLabel = "Play Again"
    let replay = SKLabelNode(fontNamed: "GillSans")
    
    let menuLabel = "Back to Main Menu"
    let menu = SKLabelNode(fontNamed: "GillSans")
    
    var playButton = SKSpriteNode(imageNamed: "play")
    var menuButton = SKSpriteNode(imageNamed: "mainMenu")
    var starfield:SKEmitterNode!
    
    override func didMove(to view: SKView) {
        /***
         positions labels and nodes on screen
         */
        
        title.text = gameLabel
        title.fontSize = 32
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: size.height - size.height/6)
        addChild(title)
        
        replay.text = playLabel
        replay.fontSize = 26
        replay.fontColor = SKColor.white
        replay.position = CGPoint(x: size.width/2, y: size.height/2 + size.height/8)
        addChild(replay)
        
        playButton.setScale(3/5)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playButton)
        
        menu.text = menuLabel
        menu.fontSize = 26
        menu.fontColor = SKColor.white
        menu.position = CGPoint(x: size.width/2, y: size.height/2 - size.height/4)
        addChild(menu)
        
        menuButton.setScale(3/4)
        menuButton.position = CGPoint(x: frame.midX, y: frame.midY - size.height/3)
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
