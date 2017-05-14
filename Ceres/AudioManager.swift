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
    }
    
    public func play(sound: Sound) {
        
        if !(defaultsManager.getValue(key: "SoundOnOff")) {
            return
        }
        
        // Creating private variables for the SKAction sounds automatically disables all other audio output. For this reason, the SKActions to run sounds are defined on the fly.
        switch (sound) {
        case .gemCollectedSound:
//            run(SKAction.playSoundFileNamed("hydraulicSound.wav", waitForCompletion: false), withKey: "soundEffect")
            let gemCollectedSoundNode = SKAudioNode(fileNamed: "hydraulicSound.wav")
            gemCollectedSoundNode.name = "soundEffect"
            gemCollectedSoundNode.autoplayLooped = false
            self.run(SKAction.sequence([SKAction.run({self.playSoundEffect(soundNode: gemCollectedSoundNode)}),
                                   SKAction.wait(forDuration: 2.0),
                                   SKAction.run({self.soundEffectCleanup(soundNode: gemCollectedSoundNode)})]))
        case .gemCreatedSound:
            run(SKAction.playSoundFileNamed("anvil.mp3", waitForCompletion: false), withKey: "soundEffect")
        case .gemExplosionSound:
            run(SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false), withKey: "soundEffect")
        case .collectorExplosionSound:
            run(SKAction.playSoundFileNamed("bomb.mp3", waitForCompletion: false), withKey: "soundEffect")
        }
    }
    
    private func playSoundEffect(soundNode: SKAudioNode) {
        addChild(soundNode)
        soundNode.run(SKAction.play())
    }
    
    private func soundEffectCleanup(soundNode: SKAudioNode) {
        print("Cleanup")
        if soundNode.parent != nil {
            soundNode.removeFromParent()
        }
    }
    
    public func pauseSoundEffects() {
        if !(defaultsManager.getValue(key: "SoundOnOff")) {
            return
        }
        
        enumerateChildNodes(withName: "soundEffect") {node,_ in
            node.run(SKAction.pause())
        }
    }
    
    
    public func resumeSoundEffects() {
        if !(defaultsManager.getValue(key: "SoundOnOff")) {
            return
        }
        
        enumerateChildNodes(withName: "soundEffect") {node,_ in // Not resuming correctly when multiple sound effects are playing
            node.run(SKAction.play())
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
