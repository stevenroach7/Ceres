//
//  AboutScene.swift
//  Ceres
//
//  Created by Sean Cheng on 5/1/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class AboutScene: SKScene {
    /***
     Initializes Nodes and Labels
     */
    
    let backButton = SKSpriteNode(imageNamed: "back")
    let text = SKSpriteNode(imageNamed: "aboutScreen")
    
    override func didMove(to view: SKView) {
        /***
         positions labels and nodes on screen
         */
        
        backButton.setScale(0.175)
        backButton.position = CGPoint(x: size.width/12, y: size.height - size.height/24)
        addChild(backButton)
        
        text.position = CGPoint(x: frame.midX, y: size.height/2)
        addChild(text)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            //transitions back to menu screen if back button is touched
            if node == backButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.doorsCloseVertical(withDuration: 1)
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
