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
    
    let game = "Instructions"
    let title = SKLabelNode(fontNamed: "Optima-Bold")
    
    var backButton = SKSpriteNode()
    let backButtonTex = SKTexture(imageNamed: "back")
    
    var text = SKSpriteNode()
    let textTex = SKTexture(imageNamed: "instructionScreen")
    
    var starfield:SKEmitterNode!
    
    var collector = SKSpriteNode()
    let collectorTex = SKTexture(imageNamed: "collectorActive")
    let collectorGlow = SKEmitterNode(fileNamed: "collectorGlow")!

    override func didMove(to view: SKView) {
        /***
         positions labels and nodes on screen
         */

        title.text = game
        title.fontSize = 32
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: size.height - size.height/6)
        //addChild(title)
        
        backButton = SKSpriteNode(texture: backButtonTex)
        backButton.setScale(0.175)
        backButton.position = CGPoint(x: size.width/12, y: size.height - size.height/24)
        addChild(backButton)
        
        text = SKSpriteNode(texture: textTex)
        text.setScale(1)
        text.position = CGPoint(x: frame.midX, y: size.height/2)
        text.zPosition = 1
        addChild(text)
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -10
        self.addChild(starfield)
        
        collector = SKSpriteNode(texture: collectorTex)
        collector.setScale(1/4)
        collector.position = CGPoint(x: size.width / 2, y: size.height * 0.075)
        collector.zPosition = 5
        addChild(collector)
        collectorGlow.position = CGPoint(x: size.width * 0.525, y: size.height * 0.125)
        addChild(collectorGlow)
        
        let stagePlanet = StagePlanet(imageNamed: "planet")
        stagePlanet.setStagePlanetProperties()  // Calls stage properties from StagePlanet class
        stagePlanet.position = CGPoint(x: size.width * 0.5, y: size.height * 0.075)
        addChild(stagePlanet)
        
        let timerLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        timerLabel.text = "Score: 0"
        timerLabel.fontSize = 20
        //timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: size.width * 0.4, y: size.height - size.height/20)
        addChild(timerLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "+/-: 0"
        scoreLabel.fontSize = 20
        //scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: size.width * 0.75, y: size.height - size.height/20)
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            //transitions back to menu screen if back button is touched
            if node == backButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.doorsCloseHorizontal(withDuration: 1)
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}

