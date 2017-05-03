//
//  Alert.swift
//  Ceres
//
//  Created by Sean Cheng on 2/23/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

protocol Alerts { }
extension Alerts where Self: SKScene {
    
    func pauseAlert(title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Handles pausing the view/scene
        var wasPaused: Bool
        if self.isPaused {
            wasPaused = true
        } else {
            wasPaused = false
            self.view?.isPaused = true
        }
        
        // Defining the different actions a user can take from the pause alert
        let resumeAction = UIAlertAction(title: "Resume Game", style: UIAlertActionStyle.default)  { (action:UIAlertAction!) in
            if !wasPaused {
                self.view?.isPaused = false
            }
        }
        
        let quitAction = UIAlertAction(title: "Quit Game", style: UIAlertActionStyle.destructive)  { (action:UIAlertAction!) in
            if self.view != nil {
                self.view?.isPaused = false;
                let transition:SKTransition = SKTransition.doorsCloseHorizontal(withDuration: 2)
                let scene:SKScene = MenuScene(size: self.size)
                self.scene?.name = "transition" // Change name of scene since we are no longer in game once the transition begins
                self.view?.presentScene(scene, transition: transition)
            }
        }
        
        let restartAction = UIAlertAction(title: "Restart Game", style: UIAlertActionStyle.default)  { (action:UIAlertAction!) in
            if self.view != nil {
                let scene:SKScene = GameScene(size: self.size)
                self.view?.presentScene(scene)
            }
        }
        
        alertController.addAction(resumeAction)
        alertController.addAction(restartAction)
        alertController.addAction(quitAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
