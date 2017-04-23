//
//  GameScene+Touch.swift
//  Ceres
//
//  Created by Daniel Ochoa on 4/22/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit


extension GameScene { // Touching logic
    
    private func findNearestGem (touchLocation: CGPoint) -> (CGFloat, SKNode){
        // Method iterates over all gems and returns the gem with the closest distance to the touchLocation
        
        var minDist: CGFloat = 44 // recommended iOS touch radius
        var closestGem: SKSpriteNode = SKSpriteNode()
        self.enumerateChildNodes(withName: "*"){node,_ in
            if node.name == "gem" || node.name == "detonatorGem" {
                let xDist = node.position.x - touchLocation.x
                let yDist = node.position.y - touchLocation.y
                let dist = CGFloat(sqrt((xDist*xDist) + (yDist*yDist)))
                if dist < minDist {
                    minDist = dist
                    closestGem = (node as? SKSpriteNode)!
                }
            }
        }
        return (minDist, closestGem)
    }

    // Functions to deal with user touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Method to handle touch events. Senses when user touches down (places finger on screen).
        for touch in touches {
            let touchLocation = touch.location(in:self)
            let touchedNode = self.atPoint(touchLocation) as? SKSpriteNode
            // Handle touching nodes that are not gems
            if let name = touchedNode?.name {
                switch name {
                case "rightGemSource":
                    onRightGemSourceTouch()
                case "leftGemSource":
                    onLeftGemSourceTouch()
                case "pauseButton":
                    onPauseButtonTouch()
                default: break
                }
            }
            
            // Check if gem is touched
            let (minDist, closestGem) = findNearestGem(touchLocation: touchLocation)
            let touchedGem = (closestGem as? SKSpriteNode)!
            if (minDist < 44){ //If the touch is within 44 px of gem, change touched node to gem
                if !selectedGems.contains(touchedGem) {
                    selectedGems.insert(touchedGem)
                    touchesToGems[touch] = touchedGem
                    nodeDisplacements[touchedGem] = CGVector(dx: touchLocation.x - touchedGem.position.x, dy: touchLocation.y - touchedGem.position.y)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Method to handle touch events. Senses when user touches up (removes finger from screen).
        for touch in touches {
            // Update touch dictionaries and node
            if let node = touchesToGems[touch] {
                touchesToGems[touch] = nil
                nodeDisplacements[node] = nil
                selectedGems.remove(node)
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        // Updates position of gems on the screen
        let dt:CGFloat = 1.0/60.0 //determines drag and flick speed
        for (touch, node) in touchesToGems {
            if let displacement = nodeDisplacements[node] { // Get displacement of touched node.
                let touchLocation = touch.location(in:self)
                let distance = CGVector(dx: touchLocation.x - node.position.x - displacement.dx, dy: touchLocation.y - node.position.y - displacement.dy)
                let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
                node.physicsBody!.velocity = velocity
            }
        }
    }

}
