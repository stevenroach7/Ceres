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
            scoreLabel.text = "Gems: \(gemsPlusMinus)"
        }
    }
    
    var timerLabel: SKLabelNode!
    var timerSeconds = 0 {
        didSet {
            timerLabel.text = "Score: \(timerSeconds)"
        }
    }
    var timeToBeginNextSequence:Double = 0.0 // Initialize to 0.0 so sequence will start when gameplay begins
    
    
    var spawnSequenceManager: SpawnSequenceManager = SpawnSequenceManager()
    var audioManager: AudioManager = AudioManager()
    
    
    // TODO: Possibly store animations frames and sounds in their own structure
    var collectorAtlas = SKTextureAtlas()
    var collectorFrames = [SKTexture]()
    var hammerAtlas = SKTextureAtlas()
    var hammerFrames = [SKTexture]()
    
    
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
    
    // Positions of several nodes
    public struct FixedPosition {
        static var Collector = CGPoint()
        static var Ratio = CGPoint()
    }
    
    override func didMove(to view: SKView) {
        // Called immediately after scene is presented.
        
        physicsWorld.contactDelegate = self
       
        FixedPosition.Collector = CGPoint(x: size.width / 2, y: size.height * 0.085)
        FixedPosition.Ratio = CGPoint(x: size.width * 0.8, y: size.height - size.height/20)
        
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
        
        addChild(audioManager)
        audioManager.playBackgroundMusic()
    
        startTutorialMode()
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
    
    private func setTimerLabel() {
        // Tracks current game time
        
        timerLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        timerLabel.text = "Score: \(timerSeconds)"
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
        gemCollector.position = FixedPosition.Collector
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
    
    public func collectGemAnimation(collector: SKSpriteNode, implosion: Bool) {
        collector.run(SKAction.repeat(SKAction.animate(with: collectorFrames, timePerFrame: 0.25), count: 1))
        
        audioManager.play(sound: .gemCollectedSound) // TODO: Move out of this function
        
        let tempCollectorGlow = SKEmitterNode(fileNamed: "collectorGlow")!
        tempCollectorGlow.position = CGPoint(x: size.width * 0.525, y: size.height * 0.122)
        tempCollectorGlow.numParticlesToEmit = 8
        if implosion {
            tempCollectorGlow.particleColorSequence = nil;
            tempCollectorGlow.particleColorBlendFactor = 0.8
            tempCollectorGlow.particleColor = UIColor.red
            tempCollectorGlow.numParticlesToEmit = tempCollectorGlow.numParticlesToEmit * 2
        }
        addChild(tempCollectorGlow)
//        tempCollectorGlow.removeFromParent()
 
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

    func onPauseButtonTouch() { 
        pauseAlert(title: "Game Paused", message: "")
    }
    
}
