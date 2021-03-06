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
     // Initializes Nodes and Labels
    
    var starfield:SKEmitterNode!
    
    let backButton = SKSpriteNode(imageNamed: "back")
    let text = SKSpriteNode(imageNamed: "aboutPage")
    let logo = SKSpriteNode(imageNamed: "finalStellaNovaLogo")
    
    var audioManager = AudioManager()
    
    
    override func didMove(to view: SKView) {
        // Positions labels and nodes on screen
        addChild(audioManager)
        
        backgroundColor = SKColor.black
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = RelativePositions.Starfield.getAbsolutePosition(size: size)
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -10
        self.addChild(starfield)
        
        let backButtonSize = RelativeScales.BackButton.getAbsoluteSize(screenSize: size, nodeSize: backButton.size)
        backButton.xScale = backButtonSize.width
        backButton.yScale = backButtonSize.height
        backButton.position = RelativePositions.BackButton.getAbsolutePosition(size: size)
        backButton.zPosition = 2
        addChild(backButton)
        
        let logoSize = RelativeScales.AboutLogo.getAbsoluteSize(screenSize: size, nodeSize: logo.size)
        logo.xScale = logoSize.width
        logo.yScale = logoSize.height
        logo.position = RelativePositions.AboutLogo.getAbsolutePosition(size: size)
        addChild(logo)
        
        let textSize = RelativeScales.AboutText.getAbsoluteSize(screenSize: size, nodeSize: text.size)
        text.xScale = textSize.width
        text.yScale = textSize.height
        text.position = RelativePositions.AboutText.getAbsolutePosition(size: size)
        addChild(text)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            // Transitions back to menu screen if back button is touched
            if node == backButton {
                if view != nil {
                    audioManager.play(sound: .button2Sound)
                    transitionHome()
                }
            }
        }
    }
    
    private func transitionHome() {
        let transition:SKTransition = SKTransition.flipVertical(withDuration: 1)
        let scene:SKScene = MenuScene(size: self.size)
        self.view?.presentScene(scene, transition: transition)
    }
}
