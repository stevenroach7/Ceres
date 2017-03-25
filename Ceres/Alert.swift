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
    
    func backAlert(title: String, message: String, resumeAction: UIAlertAction) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Quit Game", style: UIAlertActionStyle.destructive)  { (action:UIAlertAction!) in
            if self.view != nil {
                let transition:SKTransition = SKTransition.fade(withDuration: 0.3)
                let scene:SKScene = GameOverScreen(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }}
        
        alertController.addAction(okAction)
        alertController.addAction(resumeAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func gameOverAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let gameOverAction = UIAlertAction(title: "Back to Home", style: .default)  { (action:UIAlertAction!) in
            if self.view != nil {
                let transition:SKTransition = SKTransition.fade(withDuration: 0.3)
                let scene:SKScene = MenuScene(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }}
        
        alertController.addAction(gameOverAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
