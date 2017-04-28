//
//  AudioManager.swift
//  Ceres
//
//  Created by Daniel Ochoa on 4/24/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class AudioManager: SKNode {
    
    private let gemCollectedSound = SKAction.playSoundFileNamed("hydraulicSound.wav", waitForCompletion: false)
    private let gemCreatedSound = SKAction.playSoundFileNamed("anvil.mp3", waitForCompletion: false)
    
    // These two sounds are currently not being used anywhere
//    public let zoomTimerSound = SKAction.playSoundFileNamed("boop.wav", waitForCompletion: false)
//    public let zipTimerSound = SKAction.playSoundFileNamed("zwip.wav", waitForCompletion: false)
    //
    
    private let gemExplosionSound = SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false)
    private let collectorExplosionSound = SKAction.playSoundFileNamed("bomb.mp3", waitForCompletion: false)
    private let backgroundMusic = SKAudioNode(fileNamed: "cosmos.mp3")
    
    private let defaultsManager = DefaultsManager()
    
    public enum Sound {
        case gemCollectedSound
        case gemCreatedSound
        case gemExplosionSound
        case collectorExplosionSound
    }
    
    public func play(sound: Sound) {
        
        if !(defaultsManager.getValue(key: "SoundOnOff")) {
            return
        }
        
        switch (sound) {
        case .gemCollectedSound:
            run(gemCollectedSound)
        case .gemCreatedSound:
            run(gemCreatedSound)
        case .gemExplosionSound:
            run(gemExplosionSound)
        case .collectorExplosionSound:
            run(collectorExplosionSound)
        }
    }
    
    public func playBackgroundMusic() {
        
        if !(defaultsManager.getValue(key: "MusicOnOff")) {
            return
        }
        
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    

}
