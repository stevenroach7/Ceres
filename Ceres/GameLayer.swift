//
//  GameLayer.swift
//  Ceres
//
//  Created by Steven Roach on 5/3/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit




class GameLayer: SKNode {
    
//    public var gamePaused = false
//    {
//        didSet {
//            isPaused = gamePaused
//        }
//    }
    
    
//    override var isPaused: Bool {
//        get {
//            return gamePaused
//        } set {
//            isPaused = gamePaused
//        }
//    }
    
    // When the application becomes active again, GameScene.isPaused becomes automatically set to false. This has a cascading effect where it also sets the isPaused on all child nodes of GameScene to false which is not what we want. We want the gameLayer isPaused to stay true so that the game can be in a paused state.
    
    // To fix this, I am creating another boolean variable on gameLayer to keep track of the true state of whether the scene should be paused.
    // Changing this variable should also change gameLayer.isPaused in the same way.
    // gameLayer.isPaused should not be able to be changed any other way and should always have the same value as gameLayer.gamePaused.
    
    
    
    
    
    
}
