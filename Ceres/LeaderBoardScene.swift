//
//  LeaderBoardScene.swift
//  Ceres
//
//  Created by Sean Cheng on 5/3/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class LeaderBoardScene: SKScene {
    
    let title = "Leaderboard"
    let titleNode = SKLabelNode(fontNamed: "Menlo-Bold")
    
    var backButton = SKSpriteNode()
    let backButtonTex = SKTexture(imageNamed: "back")
    
    var starfield:SKEmitterNode!
    
    let leaderBoardManager = LeaderboardManager()
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        titleNode.text = title
        titleNode.fontSize = 32
        titleNode.fontColor = SKColor.white
        titleNode.position = RelativePositions.Title.getAbsolutePosition(size: size)
        addChild(titleNode)
        
        backButton = SKSpriteNode(texture: backButtonTex)
        let backButtonSize = RelativeScales.BackButton.getAbsoluteSize(screenSize: size, nodeSize: backButton.size)
        backButton.xScale = backButtonSize.width
        backButton.yScale = backButtonSize.height
        backButton.position = RelativePositions.BackButton.getAbsolutePosition(size: size)
        addChild(backButton)
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = RelativePositions.Starfield.getAbsolutePosition(size: size)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
        
        leaderBoardManager.showScores(scene: self, yDist: PositionConstants.leaderBoardScoresDistanceFactor, fontSize: 28, index: -1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            //transitions back to menu screen if back button is touched
            if node == backButton {
                if view != nil {
                    transitionHome()
                }
            }
        }
    }
    
    private func transitionHome() {
        let transition:SKTransition = SKTransition.fade(withDuration: 1)
        let scene:SKScene = MenuScene(size: self.size)
        self.view?.presentScene(scene, transition: transition)
    }
}
