//
//  SettingsScene.swift
//  Ceres
//
//  Created by Sean Cheng on 4/25/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsScene: SKScene {
    
    let title = "Settings"
    let titleNode = SKLabelNode(fontNamed: "Optima-Bold")
    
    var backButton = SKSpriteNode()
    let backButtonTex = SKTexture(imageNamed: "back")
    
    let switchText = "On"
    let switchNode = SKLabelNode(fontNamed: "Optima-Bold")
    
    var starfield:SKEmitterNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        let soundSwitch = UISwitch(frame:CGRect(x: frame.midX - size.width/20, y: frame.midY, width: 2, height: 2))
        soundSwitch.setOn(true, animated: false)
        soundSwitch.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        self.view!.addSubview(soundSwitch)
        
//        if soundSwitch.isOn == true {
//            showSwitchText()
//        } else if soundSwitch.isOn == false {
//            switchNode.removeFromParent()
//        }
        
        titleNode.text = title
        titleNode.fontSize = 32
        titleNode.fontColor = SKColor.white
        titleNode.position = CGPoint(x: size.width/2, y: size.height - size.height/6)
        addChild(titleNode)
        
        backButton = SKSpriteNode(texture: backButtonTex)
        backButton.setScale(0.175)
        backButton.position = CGPoint(x: size.width/12, y: size.height - size.height/24)
        addChild(backButton)
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
    }
    
    func showSwitchText() {
        switchNode.text = switchText
        switchNode.fontSize = 25
        switchNode.fontColor = SKColor.white
        switchNode.position = CGPoint(x: size.width/2 + size.width/5, y: size.height/2 - size.height/22)
        addChild(switchNode)
    }
    
    func switchValueDidChange(sender:UISwitch!) {
        if sender.isOn == true {
            print("on")
        }
        else {
            print("off")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            //transitions back to menu screen if back button is touched
            if node == backButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
    
}
