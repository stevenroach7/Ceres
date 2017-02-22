//
//  Gem.swift
//  Ceres
//
//  Created by Daniel Ochoa on 2/21/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import GameplayKit

class Gem: SKSpriteNode {
    
    private func dragSprite(currNode: SKNode, translation: CGPoint){
        // Dragging functionality

        let position = currNode.position

        if currNode.name == "gem" {
            currNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let positionInScene = touch.location(in: self)
        let touchedNode = atPoint(positionInScene)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)


        dragSprite(currNode: touchedNode, translation: translation)
    }
    
}
