//
//  AnimationManager.swift
//  Ceres
//
//  Created by Steven Roach on 5/3/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class AnimationManager { // Eventually, all animation methods should be moved to this class.
    
    public var collectorAtlas = SKTextureAtlas()
    public var collectorFrames = [SKTexture]()
    public var hammerAtlas = SKTextureAtlas()
    public var hammerFrames = [SKTexture]()
    
    public func addAtlases() {
        collectorAtlas = SKTextureAtlas(named: "collectorImages")
        collectorFrames.append(SKTexture(imageNamed: "collectorActive.png"))
        collectorFrames.append(SKTexture(imageNamed: "collectorInactive.png"))
        hammerAtlas = SKTextureAtlas(named: "hammerImages")
        hammerFrames.append(SKTexture(imageNamed: "hammerActive.png"))
        hammerFrames.append(SKTexture(imageNamed: "hammerInactive.png"))
    }
    
    public func animateMinusAlert(node: SKLabelNode, size: CGSize) {
        let moveDown = SKAction.moveTo(y: size.height * 0.6, duration: 0.8)
        node.run(moveDown)
        node.run(SKAction.fadeOut(withDuration: 1.0))
    }
    
    public func shakeAction(positionX : CGFloat) -> SKAction {
        // Returns a shaking animation
        
        //defining a shake sequence
        var sequence = [SKAction]()
        
        //Filling the sequence
        for i in (1...4).reversed() {
            let moveRight = SKAction.moveBy(x: CGFloat(i*2), y: 0, duration: TimeInterval(0.05))
            sequence.append(moveRight)
            let moveLeft = SKAction.moveBy(x: CGFloat(-4*i), y: 0, duration: TimeInterval(0.1))
            sequence.append(moveLeft)
            let moveOriginal = SKAction.moveBy(x: CGFloat(i*2), y: 0, duration: (TimeInterval(0.05)))
            sequence.append(moveOriginal)
        }
        sequence.append(SKAction.moveTo(x: positionX, duration: 0.05)) //Return to original x position
        let shake = SKAction.sequence(sequence)
        return shake
    }
    
    public func flashGemsLabelAnimation(color: SKColor, percentGrowth: Double, label: SKLabelNode) {
        // Animates gems label
        
        let colorScore = SKAction.run({label.fontColor = color})
        let expand = SKAction.scale(by: CGFloat(percentGrowth), duration: 0.25)
        let shrink = SKAction.scale(by: CGFloat(1 / percentGrowth), duration: 0.25)
        let recolorWhite = SKAction.run({label.fontColor = SKColor.white})
        let flashAnimation = SKAction.sequence([colorScore, expand, shrink, recolorWhite])
        
        label.run(flashAnimation)
    }
}

