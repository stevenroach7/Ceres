//
//  GameViewController.swift
//  Ceres
//
//  Created by Steven Roach on 2/15/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var skView: SKView? = nil
    
    override func viewDidLoad() {
        // Called when view is loaded
        
        super.viewDidLoad()
        let scene = MenuScene(size: view.bounds.size)
        skView = view as? SKView
        skView?.showsFPS = false
        skView?.showsNodeCount = false
        skView?.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView?.presentScene(scene)
        
        //Add pauseGameScene observer
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.pauseGameScene), name: NSNotification.Name(rawValue: "PauseGameScene"), object: nil)
        
    }
    
    func pauseGameScene() {
        // If the pause alert is not currently displayed then display it.
        // To be called on app goes to background
        
        if (skView?.window?.rootViewController?.presentedViewController?.title != "Game Paused"){
            skView?.isPaused = false; //Because going to app background auto pauses & we want to display alert
            if skView?.scene?.name == "game" {
                (skView?.scene as! GameScene).onPauseButtonTouch()
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
