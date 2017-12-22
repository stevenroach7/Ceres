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
    
    @objc func pauseGameScene() {
        // If the pauseLayer is not currently displayed then display it.
        
        if skView?.scene?.name == "game" {
            (skView?.scene as! GameScene).onPauseButtonTouch()
            // If scene is in transition, pauseLayer will not be shown when the transition finishes since it is a child of gameScene
        }
    }
    
    override func viewWillLayoutSubviews() {
        // Restrict content to safe area so content fits screen of iPhone X.
        super.viewWillLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            if let window = view.window {
                view.frame = window.safeAreaLayoutGuide.layoutFrame
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
