//
//  StagePlanet.swift
//  Ceres
//
//  Created by Sean Cheng on 3/22/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import GameplayKit

class StagePlanet: SKSpriteNode {
    
    func setStagePlanetProperties() {
        // Sets initial properties of the stage
        setScale(0.55)
        name = "stagePlanet"
        zPosition  = -1
        let planetPath = createPlanetPath()
        physicsBody = SKPhysicsBody(polygonFrom: planetPath)
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = GameScene.PhysicsCategory.StagePlanet;
        physicsBody?.contactTestBitMask = GameScene.PhysicsCategory.Gem;
        physicsBody?.collisionBitMask = GameScene.PhysicsCategory.None;
        
    }
    
    private func createPlanetPath() -> CGPath {
        // Creates a path that is the shape of the stage planet.
        let offsetX = CGFloat(frame.size.width * anchorPoint.x)
        let offsetY = CGFloat(frame.size.height * anchorPoint.y)
        
        // TODO: Edit path to better approximate object
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 61 - offsetX, y: 6 - offsetY))
        path.addLine(to: CGPoint(x: 61 - offsetX, y: 43 - offsetY))
        path.addLine(to: CGPoint(x: 74 - offsetX, y: 45 - offsetY))
        path.addLine(to: CGPoint(x: 87 - offsetX, y: 48 - offsetY))
        path.addLine(to: CGPoint(x: 111 - offsetX, y: 59 - offsetY))
        path.addLine(to: CGPoint(x: 139 - offsetX, y: 64 - offsetY))
        path.addLine(to: CGPoint(x: 173 - offsetX, y: 78 - offsetY))
        path.addLine(to: CGPoint(x: 288 - offsetX, y: 74 - offsetY))
        path.addLine(to: CGPoint(x: 245 - offsetX, y: 76 - offsetY))
        path.addLine(to: CGPoint(x: 258 - offsetX, y: 78 - offsetY))
        path.addLine(to: CGPoint(x: 274 - offsetX, y: 75 - offsetY))
        path.addLine(to: CGPoint(x: 294 - offsetX, y: 75 - offsetY))
        path.addLine(to: CGPoint(x: 319 - offsetX, y: 74 - offsetY))
        path.addLine(to: CGPoint(x: 342 - offsetX, y: 72 - offsetY))
        path.addLine(to: CGPoint(x: 364 - offsetX, y: 69 - offsetY))
        path.addLine(to: CGPoint(x: 379 - offsetX, y: 67 - offsetY))
        path.addLine(to: CGPoint(x: 383 - offsetX, y: 66 - offsetY))
        path.addLine(to: CGPoint(x: 399 - offsetX, y: 67 - offsetY))
        path.addLine(to: CGPoint(x: 418 - offsetX, y: 62 - offsetY))
        path.addLine(to: CGPoint(x: 424 - offsetX, y: 57 - offsetY))
        path.addLine(to: CGPoint(x: 450 - offsetX, y: 48 - offsetY))
        path.addLine(to: CGPoint(x: 470 - offsetX, y: 43 - offsetY))
        path.addLine(to: CGPoint(x: 470 - offsetX, y: 7 - offsetY))
        path.closeSubpath();
        return path
    }
    
}
