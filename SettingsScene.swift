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
    
    var backButton = SKSpriteNode()
    let backButtonTex = SKTexture(imageNamed: "back")
    
    let titleNode = SKSpriteNode(imageNamed: "settingsTitle")
    
    let musicNode = SKSpriteNode(imageNamed: "music")
    var musicSwitch = UISwitch()
    
    let soundNode = SKSpriteNode(imageNamed: "soundEffects")
    var soundSwitch = UISwitch()
    
    let comingSoonNode = SKSpriteNode(imageNamed: "comingSoon")
    
    let defaultsManager = DefaultsManager()
    var audioManager = AudioManager()
    
    var starfield:SKEmitterNode!
    
    var collector = SKSpriteNode(imageNamed: "collectorActive")
    let collectorGlow = SKEmitterNode(fileNamed: "collectorGlow")!
    
    let stagePlanet = StagePlanet(imageNamed: "planet")
    
    override func didMove(to view: SKView) {
        // Positions nodes on screen
        addChild(audioManager)
        
        backgroundColor = SKColor.black
        
        backButton = SKSpriteNode(texture: backButtonTex)
        let backButtonSize = RelativeScales.BackButton.getAbsoluteSize(screenSize: size, nodeSize: backButton.size)
        backButton.xScale = backButtonSize.width
        backButton.yScale = backButtonSize.height
        backButton.position = RelativePositions.BackButton.getAbsolutePosition(size: size)
        addChild(backButton)
        
        let titleNodeSize = RelativeScales.SettingsTitle.getAbsoluteSize(screenSize: size, nodeSize: titleNode.size)
        titleNode.xScale = titleNodeSize.width
        titleNode.yScale = titleNodeSize.height
        titleNode.position = RelativePositions.SettingsTitle.getAbsolutePosition(size: size)
        addChild(titleNode)
        
        let comingSoonNodeSize = RelativeScales.ComingSoon.getAbsoluteSize(screenSize: size, nodeSize: comingSoonNode.size)
        comingSoonNode.xScale = comingSoonNodeSize.width
        comingSoonNode.yScale = comingSoonNodeSize.height
        comingSoonNode.position = RelativePositions.ComingSoon.getAbsolutePosition(size: size)
        addChild(comingSoonNode)
        
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
        collectorGlow.particleColorBlendFactor = 0.55
        collectorGlow.particleColor = UIColor.green
        addChild(collectorGlow)
        
        stagePlanet.setStagePlanetProperties()
        stagePlanet.position = RelativePositions.StagePlanet.getAbsolutePosition(size: size)
        stagePlanet.zPosition = 1
        addChild(stagePlanet)
        
        createMusicSwitch()
        showMusicSwitchNode()
        
        createSoundSwitch()
        showSoundSwitchNode()
    }
    
    public func createMusicSwitch() {
        musicSwitch = UISwitch(frame: CGRect(x: frame.midX + size.width * 0.25, y: size.height/4, width: 2, height: 2))
        musicSwitch.setOn(defaultsManager.getValue(key: "MusicOnOff"), animated: false)
        musicSwitch.addTarget(self, action: #selector(musicSwitchOnOff(sender:)), for: .valueChanged)
        self.view!.addSubview(musicSwitch)
    }
    
    @objc func musicSwitchOnOff(sender:UISwitch!) {
        // Called when state of music switch changes
        if sender.isOn == false {
            defaultsManager.setValue(key:"MusicOnOff", value: false)
        } else {
            defaultsManager.setValue(key:"MusicOnOff", value: true)
        }
    }
    
    private func showMusicSwitchNode() {
        // Places Node next to music switch
        let musicNodeSize = RelativeScales.Music.getAbsoluteSize(screenSize: size, nodeSize: musicNode.size)
        musicNode.xScale = musicNodeSize.width
        musicNode.yScale = musicNodeSize.height
        musicNode.position = RelativePositions.Music.getAbsolutePosition(size: size)
        addChild(musicNode)
    }
    
    public func createSoundSwitch() {
        soundSwitch = UISwitch(frame: CGRect(x: frame.midX + size.width * 0.25, y: size.height * 3/8, width: 2, height: 2))
        soundSwitch.setOn(defaultsManager.getValue(key: "SoundOnOff"), animated: false)
        soundSwitch.addTarget(self, action: #selector(soundSwitchOnOff(sender:)), for: .valueChanged)
        self.view!.addSubview(soundSwitch)
    }
    
    @objc func soundSwitchOnOff(sender:UISwitch!) {
        // Called when state of sound switch changes
        if sender.isOn == false {
            defaultsManager.setValue(key:"SoundOnOff", value: false)
        } else {
            defaultsManager.setValue(key:"SoundOnOff", value: true)
        }
    }
    
    private func showSoundSwitchNode() {
        // Places Node next to sound switch
        let soundNodeSize = RelativeScales.SoundEffects.getAbsoluteSize(screenSize: size, nodeSize: soundNode.size)
        soundNode.xScale = soundNodeSize.width
        soundNode.yScale = soundNodeSize.height
        soundNode.position = RelativePositions.SoundEffects.getAbsolutePosition(size: size)
        addChild(soundNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            //transitions back to menu screen if back button is touched
            if node == backButton {
                if view != nil {
                    audioManager.play(sound: .button2Sound)
                    transitionHome()
                }
            }
        }
    }
    
    private func transitionHome() {
        musicSwitch.removeFromSuperview()
        soundSwitch.removeFromSuperview()
        let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
        let scene:SKScene = MenuScene(size: self.size)
        self.view?.presentScene(scene, transition: transition)
    }
}
