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
    
    private let backgroundMusic = SKAudioNode(fileNamed: "cosmos.mp3")
    private let defaultsManager = DefaultsManager()
    
    public enum Sound {
        case gemCollectedSound
        case gemCreatedSound
        case gemExplosionSound
        case collectorExplosionSound
    }
    
    public func play(sound: Sound) {
        // Checks if sound switch is on or off, then plays sound if on
        
        if !(defaultsManager.getValue(key: "SoundOnOff")) {
            return
        }
        
        // Creating private variables for the SKAction sounds automatically disables all other audio output. For this reason, the SKActions  to run sounds are defined on the fly.
        switch (sound) {
        case .gemCollectedSound:
            run(SKAction.playSoundFileNamed("hydraulicSound.wav", waitForCompletion: false))
        case .gemCreatedSound:
            run(SKAction.playSoundFileNamed("anvil.mp3", waitForCompletion: false))
        case .gemExplosionSound:
            run(SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false))
        case .collectorExplosionSound:
            run(SKAction.playSoundFileNamed("bomb.mp3", waitForCompletion: false))
        }
    }
    
    public func playBackgroundMusic() {
        // Checks if music switch is on or off, plays music if on
        
        if !(defaultsManager.getValue(key: "MusicOnOff")) {
            return
        }
        
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
}
