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
    
    let gemCollectedSound = SKAction.playSoundFileNamed("hydraulicSound.wav", waitForCompletion: false)
    let gemCreatedSound = SKAction.playSoundFileNamed("anvil.mp3", waitForCompletion: false)
    
    // These two sounds are currently not being used anywhere
    let zoomTimerSound = SKAction.playSoundFileNamed("boop.wav", waitForCompletion: false)
    let zipTimerSound = SKAction.playSoundFileNamed("zwip.wav", waitForCompletion: false)
    //
    
    let gemExplosionSound = SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false)
    let collectorExplosionSound = SKAction.playSoundFileNamed("bomb.mp3", waitForCompletion: false)
}
