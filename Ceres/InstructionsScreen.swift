//
//  InstructionsScreen.swift
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
    let title = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    
    var backButton = SKSpriteNode()
    let backButtonTex = SKTexture(imageNamed: "backLogo")
    
    var text = SKSpriteNode()
    let textTex = SKTexture(imageNamed: "profitInstructions")
    
    var starfield:SKEmitterNode!
    
    var ship = SKSpriteNode()
    let shipTex = SKTexture(imageNamed: "Spaceship")

    override func didMove(to view: SKView) {
        /***
         positions labels and nodes on screen
         */

        title.text = game
        title.fontSize = 40
        title.fontColor = SKColor.white
        title.position = CGPoint(x: size.width/2, y: size.height - size.height/6)
        addChild(title)
        
        backButton = SKSpriteNode(texture: backButtonTex)
        backButton.setScale(3/4)
        backButton.position = CGPoint(x: size.width/6, y: size.height - size.height/24)
        addChild(backButton)
        
        text = SKSpriteNode(texture: textTex)
        text.setScale(1)
        text.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(text)
        
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

