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
    
    func createAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "CONTINUE", style: UIAlertActionStyle.cancel)
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.destructive)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
