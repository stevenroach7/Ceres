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
    
    public func setHighScores(score: Int) -> Int {
        var highScores: [Int] = defaultsManager.getHighScores()
        var index: Int = -1 // Index to be used to tell showScores if and/or which new highscore to highlight
        if (score >= highScores[highScores.count - 1] && score < 1000){ // NOTE: highScores is already sorted in descending order
            for i in (0...(highScores.count - 1)) {
                if (score >= highScores[i]) {
                    index = i
                    break
                }
            }
            highScores[highScores.count - 1] = score
            highScores.sort() { $0 > $1 } // Sorts array in descending order
        }
        
        defaultsManager.setHighScores(value: highScores)
        return index
    }
    
    public func showScores(scene: SKScene, yDist: CGFloat, fontSize: CGFloat, index: Int){
        // Presents the top scores, the index parameter will highlight a new addition to the leaderboard
        
        let highScores = defaultsManager.presentHighScores()
        
        if (highScores.count >= 1) {
            for i in 0...(highScores.count - 1) {
                let highScore = SKLabelNode(fontNamed: "Menlo-Bold")
                highScore.text = "\((i + 1)). \(highScores[i])"
                if (i == index){
                    highScore.fontColor = SKColor.green
                } else {
                    highScore.fontColor = SKColor.white
                }
                
                highScore.fontSize = fontSize
                highScore.position = RelativePositions.HighScoresLabel.getAbsolutePosition(size: scene.size, constantY: (-yDist * scene.size.height * CGFloat(i)))
                scene.addChild(highScore)
            }
        }
    }
}
