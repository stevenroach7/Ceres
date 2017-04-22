//
//  GameScene+GemSpawn.swift
//  Ceres
//
//  Created by Steven Roach on 4/22/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit


extension GameScene { // GemSpawn
    
    enum GemSpawnLocation {
        // Enum holds the locations where gems may spawn
        case left
        case right
    }
    
    enum SpawnAction {
        // Enum holds the actions used to build gem sequences
        indirect case sequence(actions: [SpawnAction]) // Recursively defined so mark as indirect
        indirect case repeated(times: Int, action: SpawnAction)
        case wait(time: TimeInterval)
        case spawnGemLeft
        case spawnGemRight
        case spawnDetonatorLeft
        case spawnDetonatorRight
    }
    
    private func createSKAction(spawnAction: SpawnAction) -> SKAction {
        // returns an SKAction to produce that sequence.
        switch(spawnAction) {
        case .sequence(let actions):
            return SKAction.sequence(actions.map(createSKAction))
        case .repeated(let times, let action):
            return SKAction.repeat(createSKAction(spawnAction: action), count: times)
        case .wait(let time):
            return SKAction.wait(forDuration: time)
        case .spawnGemLeft:
            return SKAction.run({self.addRegularGem(location: GemSpawnLocation.left)})
        case .spawnGemRight:
            return SKAction.run({self.addRegularGem(location: GemSpawnLocation.right)})
        case .spawnDetonatorLeft:
            return SKAction.run({self.addDetonatorGem(location: GemSpawnLocation.left)})
        case .spawnDetonatorRight:
            return SKAction.run({self.addDetonatorGem(location: GemSpawnLocation.right)})
        }
    }
    
    public func spawnGems() {
        // Called every second, calls gem spawning sequences based on game timer
        if timerSeconds % 10 == 0 {
            switch timerSeconds {
            case 0:
                run(getGemSpawnSequence1())
            case 10:
                run(getGemSpawnSequence2())
            case 20:
                run(getGemSpawnSequenceBasicDetonators())
            case 30:
                run(getGemSpawnSequence3())
            case 40:
                run(getGemSpawnSequence4())
            case 50:
                run(getGemSpawnSequence4())
            case 60:
                run(getGemSpawnSequence3())
            default:
                run(getGemSpawnSequenceHard())
            }
        }
    }
    
    private func getGemSpawnSequence1() -> SKAction {
        // Gem spawning routine
        let spawnSequence1: SpawnAction =
            .repeated(times: 5,
                      action: .sequence(actions: [.wait(time: 1), .spawnGemLeft, .wait(time: 1), .spawnGemRight]))

        return createSKAction(spawnAction: spawnSequence1)
    }

    private func getGemSpawnSequence2() -> SKAction {
        // Gem spawning routine
        let spawnSequence2: SpawnAction =
            .repeated(times: 8,
                      action: .sequence(actions: [.wait(time: 1), .spawnGemLeft, .wait(time: 0.25), .spawnGemRight]))
        return createSKAction(spawnAction: spawnSequence2)
    }

    private func getGemSpawnSequence3() -> SKAction {
        // Gem spawning routine
        let spawnSequence3: SpawnAction =
            .repeated(times: 7, action:
                .sequence(actions: [.wait(time: 1),
                                    .spawnGemLeft,
                                    .wait(time: 0.25),
                                    .spawnGemLeft, .spawnDetonatorLeft,
                                    .wait(time: 0.25),
                                    .spawnGemLeft, .spawnGemRight]))
        return createSKAction(spawnAction: spawnSequence3)
    }

    private func getGemSpawnSequence4() -> SKAction {
        let spawnSequence4: SpawnAction =
            .repeated(times: 2, action:
                .sequence(actions: [.wait(time: 2.47),
                                    .spawnGemRight,
                                    .wait(time: 0.01),
                                    .spawnGemRight, .spawnDetonatorLeft,
                                    .wait(time: 0.01),
                                    .spawnGemRight,
                                    .wait(time: 0.01),
                                    .spawnGemRight, .spawnDetonatorLeft,

                                    .wait(time: 2.47),
                                    .spawnGemLeft,
                                    .wait(time: 0.01),
                                    .spawnGemLeft,
                                    .wait(time: 0.01),
                                    .spawnGemRight, .spawnDetonatorLeft,
                                    .wait(time: 0.01),
                                    .spawnGemLeft,
                                    ]))

        return createSKAction(spawnAction: spawnSequence4)
    }

    private func getGemSpawnSequenceBasicDetonators() -> SKAction {

        let spawnSequenceBasicDetonators: SpawnAction =
            .repeated(times: 2, action:
                .sequence(actions: [.wait(time: 2.47),
                                    .spawnGemRight,
                                    .wait(time: 0.01),
                                    .spawnGemRight,
                                    .wait(time: 0.01),
                                    .spawnGemRight,
                                    .wait(time: 0.01),
                                    .spawnGemRight, .spawnDetonatorLeft,

                                    .wait(time: 2.47),
                                    .spawnGemLeft,
                                    .wait(time: 0.01),
                                    .spawnGemLeft,
                                    .wait(time: 0.01),
                                    .spawnGemRight,
                                    .wait(time: 0.01),
                                    .spawnGemRight, .spawnDetonatorRight
                                    ]))

        return createSKAction(spawnAction: spawnSequenceBasicDetonators)
    }
    
    private func getGemSpawnSequenceHard() -> SKAction {
        let spawnSequenceHard: SpawnAction =
            .repeated(times: 10, action:
                .sequence(actions: [.wait(time: 0.75),
                                    .spawnGemRight,
                                    .wait(time: 0.01),
                                    .spawnGemRight, .spawnGemLeft,
                                    .wait(time: 0.01),
                                    .spawnGemRight, .spawnDetonatorLeft,
                                    
                                    .wait(time: 0.21),
                                    .spawnGemLeft,
                                    .wait(time: 0.01),
                                    .spawnGemLeft, .spawnGemRight, .spawnDetonatorLeft,
                                    .wait(time: 0.01),
                                    .spawnGemLeft,
                                    ]))
        
        return createSKAction(spawnAction: spawnSequenceHard)
    }
    
    
    private func addGem(gem: Gem, location: GemSpawnLocation, velocity: CGFloat) {
        // Produces a Gem from the left astronaut
        gem.setGemProperties()  // Calls gem properties from Gem class
        let position: CGPoint, angle: CGFloat
        switch location {
        case .left:
            position = CGPoint(x: size.width * 0.15, y: size.height * 0.15)
            angle = Utility.random(min: CGFloat.pi * (1/4), max: CGFloat.pi * (1/2))
        case .right:
            position = CGPoint(x: size.width * 0.85, y: size.height * 0.15)
            angle = Utility.random(min: CGFloat.pi * (1/2), max: CGFloat.pi * (3/4))
        }
        gem.position = position
        gem.setGemVelocity(velocity: velocity, angle: angle)
        addChild(gem)
    }
    
    public func addRegularGem(location: GemSpawnLocation, velocity: CGFloat = 180) {
        let gem = Gem(imageNamed: "gemShape1")
        gem.name = "gem"
        addGem(gem: gem, location: location, velocity: velocity)
    }
    
    public func addDetonatorGem(location: GemSpawnLocation, timeToExplosion: Double = 2.0, velocity: CGFloat = 110) {
        // Adds a detonating gem to the scene and makes it explode in timeToExplosion seconds.
        let detonatorGem = Gem(imageNamed: "rottenGem")
        detonatorGem.name = "detonatorGem"
        let gravityFieldNode = SKFieldNode.radialGravityField()
        
        run(SKAction.sequence([
            SKAction.run({self.addGem(gem: detonatorGem, location: location, velocity: velocity)}),
            SKAction.run({self.animateDetonatorGem(detonatorGem: detonatorGem)}),
            SKAction.wait(forDuration: timeToExplosion),
            SKAction.run({self.detonateGem(detonatorGem: detonatorGem, gravityFieldNode: gravityFieldNode)}),
            SKAction.wait(forDuration: 0.25),
            SKAction.run({self.detonationCleanup(gravityFieldNode: gravityFieldNode)})
            ]))
    }
    
    private func flashDetonatorGemAnimation(duration: Double) -> SKAction {
        // Takes an animation duration and returns an animation to flash a detonator gem once
        let flashAction = SKAction.setTexture(SKTexture(imageNamed: "mostlyWhiteRottenGem"))
        let unFlashAction = SKAction.setTexture(SKTexture(imageNamed: "rottenGem"))
        
        let flashAnimation = SKAction.sequence([
            flashAction,
            SKAction.wait(forDuration: duration / 2),
            unFlashAction,
            SKAction.wait(forDuration: duration / 2)
            ])
        return flashAnimation
    }
    
    private func animateDetonatorGem(detonatorGem: Gem) {
        // Takes a detonatorGem and runs a flashing animation on it
        let flashDuration = 0.25
        detonatorGem.run(SKAction.repeat(SKAction.sequence([
            {self.flashDetonatorGemAnimation(duration: flashDuration)}(),
            ]), count: 20))
    }
    
    private func detonateGem(detonatorGem: Gem, gravityFieldNode: SKFieldNode) {
        // Takes a detonator gem and a gravityFieldNode to add to the scene and simulates the gem exploding in the scene
        if detonatorGem.parent != nil { // Don't simulate explosion if gem has been removed
            let gemPosition = detonatorGem.position
            detonatorGem.removeFromParent()
            
            let gemExplosion = SKEmitterNode(fileNamed: "gemExplosion")!
            gemExplosion.position = gemPosition
            addChild(gemExplosion)
            run(gemExplosionSound)
            
            gravityFieldNode.name = "gravityFieldNode"
            gravityFieldNode.strength = -30
            gravityFieldNode.position = gemPosition
            addChild(gravityFieldNode)
        }
    }
    
    private func detonationCleanup(gravityFieldNode: SKFieldNode) {
        // Takes a gravityFieldNode and removes it from the scene to end the gem explosion simulation.
        if gravityFieldNode.parent != nil {
            gravityFieldNode.removeFromParent()
        }
    }
  
}
