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
    
    func createAlert(title: String, message: String, success: UIAlertAction) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = success

        
//        let okAction =    UIAlertAction(title: "CONTINUE", style: UIAlertActionStyle.cancel)  { (action:UIAlertAction!) in
//            if self.view != nil {
//                let transition:SKTransition = SKTransition.fade(withDuration: 1)
//                let scene:SKScene = MenuScene(size: self.size)
//                self.view?.presentScene(scene, transition: transition)
//            }}
        
        let cancelAction = UIAlertAction(title: "CANCEL",   style: UIAlertActionStyle.destructive)        

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
