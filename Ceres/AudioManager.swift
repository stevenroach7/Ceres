//
//  AudioManager.swift
//  Ceres
//
//  Created by Daniel Ochoa on 4/24/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class AudioManager: SKNode {
    
    private var backgroundMusic = AVAudioPlayer()
    private let defaultsManager = DefaultsManager()
    
    public enum Sound {
        case gemCollectedSound
        case gemCreatedSound
        case gemExplosionSound
        case collectorExplosionSound
        case screenTransitionSound
        case button1Sound
        case button2Sound
        case button3Sound
    }
    
    public func play(sound: Sound) {
        
        if !(defaultsManager.getValue(key: "SoundOnOff")) {
            return
        }
        
        // Creating private variables for the SKAction sounds automatically disables all other audio output. For this reason, the SKActions  to run sounds are defined on the fly.
        switch (sound) {
        case .gemCollectedSound:
            run(SKAction.playSoundFileNamed("hydraulicCollector.mp3", waitForCompletion: false))
        case .gemCreatedSound:
            run(SKAction.playSoundFileNamed("hammerHit.mp3", waitForCompletion: false))
        case .gemExplosionSound:
            run(SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false))
        case .collectorExplosionSound:
            run(SKAction.playSoundFileNamed("bomb.mp3", waitForCompletion: false))
        case .screenTransitionSound:
            run(SKAction.playSoundFileNamed("airLockTransition.mp3", waitForCompletion: false))
        case .button1Sound:
            run(SKAction.playSoundFileNamed("beep1.mp3", waitForCompletion: false))
        case .button2Sound:
            run(SKAction.playSoundFileNamed("beep2.mp3", waitForCompletion: false))
        case .button3Sound:
            run(SKAction.playSoundFileNamed("beep3.mp3", waitForCompletion: false))
        }
    }
    
    public func playBackgroundMusic() {
        
        if !(defaultsManager.getValue(key: "MusicOnOff")) {
            return
        }
        
        let path = Bundle.main.path(forResource: "music.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic.numberOfLoops = -1
            backgroundMusic.prepareToPlay()
            backgroundMusic.play()
        } catch {
            // couldn't load file.
        }
    }
    
    public func stopBackgroundMusic() {
        // Ends background music when game is exited
        
        if !(defaultsManager.getValue(key: "MusicOnOff")) {
            return
        }
        
        if backgroundMusic.isPlaying {
            backgroundMusic.stop()
        }
    }
    
    public func pauseBackgroundMusic() {
        // Pauses background music when game is paused
        
        if !(defaultsManager.getValue(key: "MusicOnOff")) {
            return
        }
        
        if backgroundMusic.isPlaying {
            backgroundMusic.pause()
        }
    }
    
    public func resumeBackgroundMusic() {
        // Resumes background music if music is on

        if !(defaultsManager.getValue(key: "MusicOnOff")) {
            return
        }
        
        if !backgroundMusic.isPlaying {
            backgroundMusic.play()
        }
    }
}
