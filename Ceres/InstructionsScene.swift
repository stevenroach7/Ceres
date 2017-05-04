//
//  InstructionsScene.swift
//  Ceres
//
//  Created by Sean Cheng on 2/20/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class InstructionsScene: SKScene {
    /***
     Initializes Nodes and Labels
     */
    
    let backButton = SKSpriteNode(imageNamed: "back")
    let text = SKSpriteNode(imageNamed: "instructionScreen")
    
    var starfield:SKEmitterNode!
    
    var collector = SKSpriteNode(imageNamed: "collectorActive")
    let collectorGlow = SKEmitterNode(fileNamed: "collectorGlow")!
    
    let swipeRightRec = UISwipeGestureRecognizer()
    
    
    override func didMove(to view: SKView) {
        /***
         positions labels and nodes on screen
         */
        
        backgroundColor = SKColor.black
        
        let backButtonSize = RelativeScales.BackButton.getAbsoluteSize(screenSize: size, nodeSize: backButton.size)
        backButton.xScale = backButtonSize.width
        backButton.yScale = backButtonSize.height
        backButton.position = RelativePositions.BackButton.getAbsolutePosition(size: size)
        addChild(backButton)
        
        text.setScale(0.9)
        let textSize = RelativeScales.InstructionsText.getAbsoluteSize(screenSize: size, nodeSize: text.size)
        text.xScale = textSize.width
        text.yScale = textSize.height
        text.position = RelativePositions.InstructionsText.getAbsolutePosition(size: size)
        addChild(text)
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = RelativePositions.Starfield.getAbsolutePosition(size: size)
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -10
        self.addChild(starfield)
        
        collector.setScale(1/4)
        collector.position = RelativePositions.Collector.getAbsolutePosition(size: size)
        collector.zPosition = 5
        addChild(collector)
        collectorGlow.position = RelativePositions.CollectorGlow.getAbsolutePosition(size: size)
        addChild(collectorGlow)
        
        let stagePlanet = StagePlanet(imageNamed: "planet")
        stagePlanet.setStagePlanetProperties()
        stagePlanet.position = RelativePositions.StagePlanet.getAbsolutePosition(size: size)
        addChild(stagePlanet)
        
        let scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.position = RelativePositions.ScoreLabel.getAbsolutePosition(size: size)
        addChild(scoreLabel)
        
        let gemsLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        gemsLabel.text = "Gems: 0"
        gemsLabel.fontSize = 20
        gemsLabel.position = RelativePositions.GemsLabel.getAbsolutePosition(size: size)
        addChild(gemsLabel)
        
        swipeRightRec.addTarget(self, action: #selector(InstructionsScene.swipedRight) )
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
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
    
    func swipedRight() {
        transitionHome()
    }
    
    private func transitionHome() {
        let transition:SKTransition = SKTransition.doorsCloseHorizontal(withDuration: 1)
        let scene:SKScene = MenuScene(size: self.size)
        view?.presentScene(scene, transition: transition)
    }
}

