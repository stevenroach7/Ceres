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
    
    public let gemCollectedSound = SKAction.playSoundFileNamed("hydraulicSound.wav", waitForCompletion: false)
    public let gemCreatedSound = SKAction.playSoundFileNamed("anvil.mp3", waitForCompletion: false)
    
    // These two sounds are currently not being used anywhere
    public let zoomTimerSound = SKAction.playSoundFileNamed("boop.wav", waitForCompletion: false)
    public let zipTimerSound = SKAction.playSoundFileNamed("zwip.wav", waitForCompletion: false)
    //
    
    public let gemExplosionSound = SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false)
    public let collectorExplosionSound = SKAction.playSoundFileNamed("bomb.mp3", waitForCompletion: false)
    public let backgroundMusic = SKAudioNode(fileNamed: "cosmos.mp3")
    
}
