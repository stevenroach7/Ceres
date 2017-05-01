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
    
    let musicLabel = SKLabelNode(fontNamed: "Optima-Bold")
    var musicSwitch = UISwitch()
    
    let soundLabel = SKLabelNode(fontNamed: "Optima-Bold")
    var soundSwitch = UISwitch()
    
    let defaultsManager = DefaultsManager()
    
    var starfield:SKEmitterNode!
    
    var collector = SKSpriteNode(imageNamed: "collectorActive")
    let collectorGlow = SKEmitterNode(fileNamed: "collectorGlow")!
    let stagePlanet = StagePlanet(imageNamed: "planet")
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
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
        
        collector.setScale(1/4)
        collector.position = CGPoint(x: size.width / 2, y: size.height * 0.075)
        collector.zPosition = 5
        addChild(collector)
        collectorGlow.position = CGPoint(x: size.width * 0.525, y: size.height * 0.125)
        addChild(collectorGlow)
        
        stagePlanet.setStagePlanetProperties()  // Calls stage properties from StagePlanet class
        stagePlanet.position = CGPoint(x: size.width * 0.5, y: size.height * 0.075)
        addChild(stagePlanet)
        
        createMusicSwitch()
        showMusicSwitchLabel()
        
        createSoundSwitch()
        showSoundSwitchLabel()
    }
    
    
    public func createMusicSwitch() {
        musicSwitch = UISwitch(frame: CGRect(x: frame.midX + size.width/10, y: size.height/4, width: 2, height: 2))
        musicSwitch.setOn(defaultsManager.getValue(key: "MusicOnOff"), animated: false)
        musicSwitch.addTarget(self, action: #selector(musicSwitchOnOff(sender:)), for: .valueChanged)
        self.view!.addSubview(musicSwitch)
    }
    
    func musicSwitchOnOff(sender:UISwitch!) {
        if sender.isOn == false {
            defaultsManager.setValue(key:"MusicOnOff", value: false)
        } else {
            defaultsManager.setValue(key:"MusicOnOff", value: true)
        }
    }
    
    private func showMusicSwitchLabel() {
        musicLabel.text = "Music"
        musicLabel.fontSize = 25
        musicLabel.fontColor = SKColor.white
        musicLabel.position = CGPoint(x: size.width/2 - size.width/13, y: size.height * 3/4 - size.height/25)
        addChild(musicLabel)
    }
    
    public func createSoundSwitch() {
        soundSwitch = UISwitch(frame: CGRect(x: frame.midX + size.width/10, y: size.height * 3/8, width: 2, height: 2))
        soundSwitch.setOn(defaultsManager.getValue(key: "SoundOnOff"), animated: false)
        soundSwitch.addTarget(self, action: #selector(soundSwitchOnOff(sender:)), for: .valueChanged)
        self.view!.addSubview(soundSwitch)
    }
    
    func soundSwitchOnOff(sender:UISwitch!) {
        if sender.isOn == false {
            defaultsManager.setValue(key:"SoundOnOff", value: false)
        } else {
            defaultsManager.setValue(key:"SoundOnOff", value: true)
        }
    }
    
    private func showSoundSwitchLabel() {
        soundLabel.text = "Sound Effects"
        soundLabel.fontSize = 25
        soundLabel.fontColor = SKColor.white
        soundLabel.position = CGPoint(x: size.width/2 - size.width/5, y: size.height * 5/8 - size.height/25)
        addChild(soundLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            //transitions back to menu screen if back button is touched
            if node == backButton {
                if view != nil {
                    musicSwitch.removeFromSuperview()
                    soundSwitch.removeFromSuperview()
                    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
    
}
