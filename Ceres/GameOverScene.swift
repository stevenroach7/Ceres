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
    let finalScoreLabel = SKLabelNode(fontNamed: "GillSans")
    
    var replayButton = SKSpriteNode(imageNamed: "replay")
    var menuButton = SKSpriteNode(imageNamed: "menu")
    var starfield:SKEmitterNode!
    
    let defaultsManager = DefaultsManager()
    
    public func setScore(score: Int) {
        self.score = score
    }
    
    public func setHighScores(){
        var HighScores: [Int] = defaultsManager.getHighScores()
        print(HighScores)
        for var i in (0...4) {
            if (score > HighScores[i]) {
                insertArray(array: HighScores, value: score, index: i)
            }
        }
        defaultsManager.setHighScores(value: HighScores)
        print(defaultsManager.getHighScores())
    }
    
    private func insertArray(array: [Int], value: Int, index: Int){
        //Implement this
    }
    
    override func didMove(to view: SKView) {
        /***
         positions labels and nodes on screen
         */
        
        backgroundColor = SKColor.black
        
        title.text = gameLabel
        title.fontSize = 32
        title.fontColor = SKColor.white
        title.position = RelativePositions.Title.getAbsolutePosition(size: size)
        addChild(title)

        finalScoreLabel.text = "Score: \(score)"
        finalScoreLabel.fontSize = 28
        finalScoreLabel.fontColor = SKColor.white
        finalScoreLabel.position = RelativePositions.FinalScoreLabel.getAbsolutePosition(size: size)
        addChild(finalScoreLabel)
        
        replayButton.setScale(1/2)
        replayButton.position = RelativePositions.ReplayButton.getAbsolutePosition(size: size)
        addChild(replayButton)
        
        menuButton.setScale(3/5)
        menuButton.position = RelativePositions.MenuButton.getAbsolutePosition(size: size)
        addChild(menuButton)
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = RelativePositions.Starfield.getAbsolutePosition(size: size)
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
            if node == replayButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.doorsOpenVertical(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            //transitions to main menu if main menu button is touched
            if node == menuButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
