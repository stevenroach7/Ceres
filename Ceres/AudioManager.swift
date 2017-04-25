//
//  AudioManager.swift
//  Ceres
//
//  Created by Daniel Ochoa on 4/24/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class AudioManager {
    
    private let gemCollectedSound = SKAction.playSoundFileNamed("hydraulicSound.wav", waitForCompletion: false)
    private let gemCreatedSound = SKAction.playSoundFileNamed("anvil.mp3", waitForCompletion: false)
    
    // These two sounds are currently not being used anywhere
    private let zoomTimerSound = SKAction.playSoundFileNamed("boop.wav", waitForCompletion: false)
    private let zipTimerSound = SKAction.playSoundFileNamed("zwip.wav", waitForCompletion: false)
    //
    
    private let gemExplosionSound = SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false)
    private let collectorExplosionSound = SKAction.playSoundFileNamed("bomb.mp3", waitForCompletion: false)
    private let backgroundMusic = SKAudioNode(fileNamed: "cosmos.mp3")
    
    public func getGemCollectedSound() -> SKAction {
        return gemCollectedSound
    }
    public func getGemCreatedSound() -> SKAction {
        return gemCreatedSound
    }
    public func getZoomTimerSound() -> SKAction {
        return zoomTimerSound
    }
    public func getZipTimerSound() -> SKAction {
        return zipTimerSound
    }
    public func getGemExplosionSound() -> SKAction {
        return gemExplosionSound
    }
    public func getCollectorExplosionSound() -> SKAction {
        return collectorExplosionSound
    }
    public func getBackgroundMusic() -> SKAudioNode {
        return backgroundMusic
    }
}
