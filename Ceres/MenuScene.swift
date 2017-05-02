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
    Initializes Nodes
    */
    
    let gameTitle = SKSpriteNode(imageNamed: "expeditionCeresTitle")
    var ship = SKSpriteNode(imageNamed: "stellaNovaShip")
    var starfield:SKEmitterNode!
    var leftExhaust:SKEmitterNode!
    var rightExhaust:SKEmitterNode!
    
    var playButton = SKSpriteNode(imageNamed: "play")
    var instructionsButton = SKSpriteNode(imageNamed: "instructions")
    var aboutButton = SKSpriteNode(imageNamed: "about")

    var settingsButton = SKSpriteNode(imageNamed: "settings")
    
    override func didMove(to view: SKView) {
        /***
        positions labels and nodes on screen
        */
        
        backgroundColor = SKColor.black
        
        gameTitle.position = RelativePositions.Title.getAbsolutePosition(size: size)
        gameTitle.setScale(0.75)
        addChild(gameTitle)
        
        playButton.setScale(0.6)
        playButton.position = RelativePositions.PlayButton.getAbsolutePosition(size: size)
        addChild(playButton)
        
        instructionsButton.setScale(0.5)
        instructionsButton.position = RelativePositions.InstructionsButton.getAbsolutePosition(size: size)
        addChild(instructionsButton)
        
        aboutButton.setScale(0.5)
        aboutButton.position = RelativePositions.AboutButton.getAbsolutePosition(size: size)
        addChild(aboutButton)
        
        settingsButton.setScale(0.375)
        settingsButton.position = RelativePositions.SettingsButton.getAbsolutePosition(size: size)
        addChild(settingsButton)
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = RelativePositions.Starfield.getAbsolutePosition(size: size)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -2
        
        leftExhaust = SKEmitterNode(fileNamed: "shipExhaust")
        leftExhaust.position = RelativePositions.LeftExhaust.getAbsolutePosition(size: size)
        self.addChild(leftExhaust)
        leftExhaust.zPosition = -1
        
        rightExhaust = SKEmitterNode(fileNamed: "shipExhaust")
        rightExhaust.position = RelativePositions.RightExhaust.getAbsolutePosition(size: size)
        self.addChild(rightExhaust)
        rightExhaust.zPosition = -1
        
        ship.xScale = 0.3 * (size.width / ship.size.width)
        ship.yScale = 0.15 * (size.height / ship.size.height)
        ship.position = RelativePositions.Ship.getAbsolutePosition(size:size)
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
                    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    scene.name = "game"
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            
            //transitions to settings screen if settings button is touched
            else if node == settingsButton {
                let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
                let scene:SKScene = SettingsScene(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }
            
            //transitions to instructions screen if instructions button is touched
            else if node == instructionsButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    let scene:SKScene = InstructionsScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            
            //transitions to about screen if about button is touched
            else if node == aboutButton {
                let transition:SKTransition = SKTransition.flipVertical(withDuration: 1)
                let scene:SKScene = AboutScene(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
}
