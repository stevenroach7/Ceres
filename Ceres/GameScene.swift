//
//  GameScene.swift
//  Ceres
//
//  Created by Steven Roach on 2/15/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, Alerts {
    
    var tutorialMode = false // Boolean to store whether game is in tutorialMode
    
    // Global nodes
    let pauseButton = SKSpriteNode(imageNamed: "pause")
    let gemCollector = GemCollector(imageNamed: "collectorActive")
    let stagePlanet = StagePlanet(imageNamed: "planet")
    let leftGemSource  = GemSource(imageNamed: "hammerInactive")
    let rightGemSource = GemSource(imageNamed: "hammerInactive")
    let redAstronaut = SKSpriteNode(imageNamed: "redAstronaut")
    let blueAstronaut = SKSpriteNode(imageNamed: "blueAstronaut")
    var starfield:SKEmitterNode!
    
    // Tutorial assets
    let flickHand = SKSpriteNode(imageNamed: "touch")
    let collectorGlow = SKEmitterNode(fileNamed: "collectorGlow")!
    
    let losingGemPlusMinus = -1 // Make this lower during testing
    
    var scoreLabel: SKLabelNode!
    var gemsPlusMinus = 0 {
        didSet {
            scoreLabel.text = "+/-: \(gemsPlusMinus)"
        }
    }
    
    var timerLabel: SKLabelNode!
    var timerSeconds = 0 {
        didSet {
            timerLabel.text = "Time: \(timerSeconds)"
        }
    }
    
    // Variables necessary to reset shaken sprites back to original position
    // TODO: if we refactor sprites to globals instead of being declared and initialized in functions this redundancy can be removed. TODO: Refactor to remove these globals
    var gemCollectorPosX: CGFloat! = nil
    var scoreLabelPosX: CGFloat! = nil
    
    // TODO: Possibly store animations frames and sounds in their own structure
    var collectorAtlas = SKTextureAtlas()
    var collectorFrames = [SKTexture]()
    var hammerAtlas = SKTextureAtlas()
    var hammerFrames = [SKTexture]()
    
    let gemCollectedSound = SKAction.playSoundFileNamed("hydraulicSound.wav", waitForCompletion: false)
    let gemCreatedSound = SKAction.playSoundFileNamed("anvil.mp3", waitForCompletion: false)
    let zoomTimerSound = SKAction.playSoundFileNamed("boop.wav", waitForCompletion: false)
    let zipTimerSound = SKAction.playSoundFileNamed("zwip.wav", waitForCompletion: false)
    let gemExplosionSound = SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false)
    let collectorExplosionSound = SKAction.playSoundFileNamed("bomb.mp3", waitForCompletion: false)
    
    // Data structures to deal with user touches
    var touchesToGems:[UITouch: SKSpriteNode] = [:] // Dictionary to map currently selected user touches to the gems they are dragging
    var selectedGems: Set<SKSpriteNode> = Set()
    var nodeDisplacements:[SKSpriteNode: CGVector] = [:] // Dictionary to map currently selected nodes to their displacements from the user's finger

    
    // Determines collisions between different objects
    public struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let GemCollector   : UInt32 = 0b1
        static let Wall: UInt32 = 0b10
        static let Gem: UInt32 = 0b11
        static let GemSource: UInt32 = 0b100
        static let StagePlanet: UInt32 = 0b101
    }
    
    
    override func didMove(to view: SKView) {
        // Called immediately after scene is presented.
        physicsWorld.contactDelegate = self
       
        backgroundColor = SKColor.black
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.zPosition = -10
        starfield.advanceSimulationTime(1)
        addChild(starfield)
        
        pauseButton.setScale(0.175)
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPoint(x: size.width/12, y: size.height - size.height/24)
        addChild(pauseButton)
        
        setScoreLabel(font: 30, position: CGPoint(x: size.width/2, y: size.height * 0.7))
        setTimerLabel()
        
        addStagePlanet()
        addGemCollector()
        addGemSources()
        addAstronauts()
        
        makeWall(location: CGPoint(x: size.width/2, y: size.height+50), size: CGSize(width: size.width*1.5, height: 1)) // TODO: Use constants here
        makeWall(location: CGPoint(x: -50, y: size.height/2), size: CGSize(width: 1, height: size.height+100))
        makeWall(location: CGPoint(x: size.width+50, y: size.height/2), size: CGSize(width: 1, height: size.height+100))
        
        // TODO: Refactor animation code into a function
        collectorAtlas = SKTextureAtlas(named: "collectorImages")
        collectorFrames.append(SKTexture(imageNamed: "collectorActive.png"))
        collectorFrames.append(SKTexture(imageNamed: "collectorInactive.png"))
        hammerAtlas = SKTextureAtlas(named: "hammerImages")
        hammerFrames.append(SKTexture(imageNamed: "hammerActive.png"))
        hammerFrames.append(SKTexture(imageNamed: "hammerInactive.png"))
        
        let backgroundMusic = SKAudioNode(fileNamed: "cosmos.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        startTutorialMode()
    }
    
    public func startGame() {
        beginGameplay()
    }
    
    
    // Functions that add nodes to scene
    private func makeWall(location: CGPoint, size: CGSize) {
        // Creates boundaries in the game that deletes gems when they come into contact
        let shape = SKShapeNode(rectOf: size)
        shape.position = location
        shape.physicsBody = SKPhysicsBody(rectangleOf: size)
        shape.physicsBody?.isDynamic = false
        shape.physicsBody?.usesPreciseCollisionDetection = true
        shape.physicsBody?.categoryBitMask = PhysicsCategory.Wall;
        shape.physicsBody?.contactTestBitMask = PhysicsCategory.Gem;
        shape.physicsBody?.collisionBitMask = PhysicsCategory.None;
        self.addChild(shape)
    }
    
    private func setScoreLabel(font: CGFloat, position: CGPoint) {
        // Tracks current game score
        scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "+/-: \(gemsPlusMinus)"
        scoreLabel.fontSize = font
        //scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = position
        addChild(scoreLabel)
    }
    
    private func setTimerLabel() {
        // Tracks current game time
        timerLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        timerLabel.text = "Time: \(timerSeconds)"
        timerLabel.fontSize = 20
        //timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: size.width * 0.4, y: size.height - size.height/20)
        addChild(timerLabel)
    }

    private func addStagePlanet() {
        stagePlanet.setStagePlanetProperties()  // Calls stage properties from StagePlanet class
        stagePlanet.position = CGPoint(x: size.width * 0.5, y: size.height * 0.075)
        addChild(stagePlanet)
    }
    
    private func addGemCollector() {
        gemCollector.setGemCollectorProperties()  // Calls gem collector properties from GemCollector class
        gemCollector.position = CGPoint(x: size.width / 2, y: size.height * 0.085)
        gemCollectorPosX = gemCollector.position.x
        addChild(gemCollector)
    }
    
    private func addGemSources() {
        // Adds 2 gem sources, one for each astronaut
        leftGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        leftGemSource.position = CGPoint(x: size.width * 0.15, y: size.height * 0.1 - 20)
        leftGemSource.name = "leftGemSource"
        addChild(leftGemSource)
        
        rightGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        rightGemSource.position = CGPoint(x: size.width * 0.85, y: size.height * 0.1 - 20)
        rightGemSource.name = "rightGemSource"
        addChild(rightGemSource)
    }
    
    private func addAstronauts() {
        // Creates 2 astronauts on either side of the planet
        redAstronaut.position = CGPoint(x: size.width * 0.15, y: size.height * 0.1)
        redAstronaut.setScale(0.175)
        redAstronaut.name = "redAstronaut"
        redAstronaut.zPosition = 2
        redAstronaut.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.1*(size.width), height: 0.13*(size.height)))
        redAstronaut.physicsBody?.usesPreciseCollisionDetection = true
        redAstronaut.physicsBody?.isDynamic = false
        redAstronaut.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        blueAstronaut.position = CGPoint(x: size.width * 0.85, y: size.height * 0.1)
        blueAstronaut.setScale(0.175)
        blueAstronaut.name = "blueAstronaut"
        blueAstronaut.zPosition = 2
        blueAstronaut.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.1*(size.width), height: 0.13*(size.height)))
        blueAstronaut.physicsBody?.usesPreciseCollisionDetection = true
        blueAstronaut.physicsBody?.isDynamic = false // Change this to true to be amused
        blueAstronaut.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        addChild(redAstronaut)
        addChild(blueAstronaut)
    }
    
    
    // Functions used in gameplay and tutorial
    public func collectGemAnimation(collector: SKSpriteNode) {
        collector.run(SKAction.repeat(SKAction.animate(with: collectorFrames, timePerFrame: 0.25), count: 1))
        collector.run(gemCollectedSound)
    }
    
    public func recolorScore(){
        if gemsPlusMinus < 0 {
            scoreLabel.fontColor = SKColor.red
        } else if gemsPlusMinus > 0 {
            scoreLabel.fontColor = SKColor.green
        } else {
            scoreLabel.fontColor = SKColor.white
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Called every time two physics bodies collide
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // categoryBitMasks are UInt32 values
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // If the two colliding bodies are a gem and gemCollector, remove the gem
        if ((firstBody.categoryBitMask == PhysicsCategory.GemCollector) && (secondBody.categoryBitMask == PhysicsCategory.Gem)) {
            if let gem = secondBody.node as? SKSpriteNode, let collector = firstBody.node as? SKSpriteNode {
                switch gem.name! {
                case "gem":
                    if !tutorialMode { // Check for tutorialMode being false first because that is more common
                        gemDidCollideWithCollector(gem: gem, collector: collector)
                    } else {
                        tutorialGemDidCollideWithCollector(gem: gem, collector: collector)
                    }
                case "detonatorGem":
                    detonatorGemDidCollideWithCollector(gem: gem, collector: collector)
                default:
                    break
                }
            }
        }

        //If the two colliding bodies are a gem and wall, remove the gem
        if ((firstBody.categoryBitMask == PhysicsCategory.Wall) &&
            (secondBody.categoryBitMask == PhysicsCategory.Gem)) {
            if let gem = secondBody.node as? SKSpriteNode {
                if !tutorialMode { // Check for tutorialMode being false first because that is more common
                    if gem.name == "gem" { // Don't penalize detonator gems going of screen
                        gemOffScreen(gem: gem)
                    } else {
                        gem.removeFromParent()
                    }
                } else {
                    gem.removeFromParent()
                    addTutorialGem()
                }
            }
        }
    }

    private func onPauseButtonTouch() {
        pauseAlert(title: "Game Paused", message: "")
    }
    
    private func findNearestGem (touchLocation: CGPoint) -> (CGFloat, SKNode){
        // Method iterates over all gems and returns the gem with the closest distance to the touchLocation
        
        var minDist: CGFloat = 44
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
