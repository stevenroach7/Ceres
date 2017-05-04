//
//  LeaderboardManager.swift
//  Ceres
//
//  Created by Daniel Ochoa on 5/3/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class LeaderboardManager {
    
    private let defaultsManager = DefaultsManager()
    
    public func setHighScores(score: Int){
        var highScores: [Int] = defaultsManager.getHighScores()
        if (score > highScores[highScores.count - 1] && score < 1000){ //If the score is at least greater than the smallest element in the array, also set score upperbound
            for i in (0...(highScores.count - 1)) {
                if (score > highScores[i]) {
                    highScores[highScores.count - 1] = score
                    highScores.sort() { $0 > $1 }
                    break
                }
            }
        }
        defaultsManager.setHighScores(value: highScores)
    }
    
    public func showScores(scene: SKScene, yDist: CGFloat, fontSize: CGFloat){
        //Presents the top scores
        
        let highScores = defaultsManager.presentHighScores()
        
        if (highScores.count >= 1) {
            for i in 0...(highScores.count - 1) {
                let highScore = SKLabelNode(fontNamed: "Menlo-Bold")
                highScore.text = "\((i + 1)). \(highScores[i])"
                highScore.fontSize = fontSize
                highScore.fontColor = SKColor.white
                highScore.position = RelativePositions.HighScoresLabel.getAbsolutePosition(size: scene.size, constantY: (-yDist * scene.size.height * CGFloat(i)))
                scene.addChild(highScore)
            }
        }
    }
}
