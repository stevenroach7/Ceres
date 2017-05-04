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
    let titleNode = SKLabelNode(fontNamed: "Menlo-Bold")
    
    var backButton = SKSpriteNode()
    let backButtonTex = SKTexture(imageNamed: "back")
    
    let musicLabel = SKLabelNode(fontNamed: "Menlo-Bold")
    var musicSwitch = UISwitch()
    
    let soundLabel = SKLabelNode(fontNamed: "Menlo-Bold")
    var soundSwitch = UISwitch()
    
    let defaultsManager = DefaultsManager()
    
    var starfield:SKEmitterNode!
    
    var collector = SKSpriteNode(imageNamed: "collectorActive")
    let collectorGlow = SKEmitterNode(fileNamed: "collectorGlow")!
    
    let stagePlanet = StagePlanet(imageNamed: "planet")
    
    let swipeRightRec = UISwipeGestureRecognizer()
    
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
        
        collector.setScale(1/4)
        collector.position = RelativePositions.Collector.getAbsolutePosition(size: size)
        collector.zPosition = 5
        addChild(collector)
        
        collectorGlow.position = RelativePositions.CollectorGlow.getAbsolutePosition(size: size)
        collectorGlow.particleColorSequence = nil
        collectorGlow.particleColorBlendFactor = 0.8
        collectorGlow.particleColor = UIColor.red
        addChild(collectorGlow)
        
        stagePlanet.setStagePlanetProperties()
        stagePlanet.position = RelativePositions.StagePlanet.getAbsolutePosition(size: size)
        addChild(stagePlanet)
        
        createMusicSwitch()
        showMusicSwitchLabel()
        
        createSoundSwitch()
        showSoundSwitchLabel()
        
        swipeRightRec.addTarget(self, action: #selector(SettingsScene.swipedRight) )
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
    }
    
    public func createMusicSwitch() {
        musicSwitch = UISwitch(frame: CGRect(x: frame.midX + size.width/10, y: size.height/4, width: 2, height: 2))
        musicSwitch.setOn(defaultsManager.getValue(key: "MusicOnOff"), animated: false)
        musicSwitch.addTarget(self, action: #selector(musicSwitchOnOff(sender:)), for: .valueChanged)
        self.view!.addSubview(musicSwitch)
    }
    
    func musicSwitchOnOff(sender:UISwitch!) {
        // Called when state of music switch changes
        if sender.isOn == false {
            defaultsManager.setValue(key:"MusicOnOff", value: false)
        } else {
            defaultsManager.setValue(key:"MusicOnOff", value: true)
        }
    }
    
    private func showMusicSwitchLabel() {
        // Places label next to music switch
        musicLabel.text = "Music"
        musicLabel.fontSize = 22
        musicLabel.fontColor = SKColor.white
        musicLabel.position = RelativePositions.MusicLabel.getAbsolutePosition(size: size)
        addChild(musicLabel)
    }
    
    public func createSoundSwitch() {
        soundSwitch = UISwitch(frame: CGRect(x: frame.midX + size.width/10, y: size.height * 3/8, width: 2, height: 2))
        soundSwitch.setOn(defaultsManager.getValue(key: "SoundOnOff"), animated: false)
        soundSwitch.addTarget(self, action: #selector(soundSwitchOnOff(sender:)), for: .valueChanged)
        self.view!.addSubview(soundSwitch)
    }
    
    func soundSwitchOnOff(sender:UISwitch!) {
        // Called when state of sound switch changes
        if sender.isOn == false {
            defaultsManager.setValue(key:"SoundOnOff", value: false)
        } else {
            defaultsManager.setValue(key:"SoundOnOff", value: true)
        }
    }
    
    private func showSoundSwitchLabel() {
        // Places label next to sound switch
        soundLabel.text = "Sound Effects"
        soundLabel.fontSize = 22
        soundLabel.fontColor = SKColor.white
        soundLabel.position = RelativePositions.SoundLabel.getAbsolutePosition(size: size)
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
                    transitionHome()
                }
            }
        }
    }
    
    func swipedRight() {
        transitionHome()
    }
    
    private func transitionHome() {
        musicSwitch.removeFromSuperview()
        soundSwitch.removeFromSuperview()
        let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
        let scene:SKScene = MenuScene(size: self.size)
        self.view?.presentScene(scene, transition: transition)
    }
}
