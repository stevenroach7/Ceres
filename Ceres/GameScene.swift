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
    
    var gemsLabel: SKLabelNode!
    var gemsPlusMinus = 0 {
        didSet {
            gemsLabel.text = "Gems: \(gemsPlusMinus)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    var timerSeconds = 0 {
        didSet {
            scoreLabel.text = "Score: \(timerSeconds)"
        }
    }
    var timeToBeginNextSequence:Double = 0.0 // Initialize to 0.0 so sequence will start when gameplay begins
    
    
    var spawnSequenceManager: SpawnSequenceManager = SpawnSequenceManager()
    var audioManager: AudioManager = AudioManager()
    
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
    
    
    public struct RelativeCoordinate {
        let x: CGFloat
        let y: CGFloat
    }
    
    // Positions of several nodes
    public struct RelativeNodePosition {

        static var Collector = RelativeCoordinate.init(x: 0.5, y: 0.085)
        static var GemsLabel = RelativeCoordinate.init(x: 0.8, y: 0.95)
        static var InitialGemsLabel = RelativeCoordinate.init(x: 0.5, y: 0.7)
        static var PauseButton = RelativeCoordinate.init(x: 1/12, y: 23/24)
        static var ScoreLabel = RelativeCoordinate.init(x: 0.4, y: 19/20)
        static var StagePlanet = RelativeCoordinate.init(x: 0.5, y: 0.075)
        static var LeftGemSource = RelativeCoordinate.init(x: 0.15, y: 0.1)
        static var RightGemSource = RelativeCoordinate.init(x: 0.85, y: 0.1)
        static var GemSpawnLeft = RelativeCoordinate.init(x: 0.15, y: 0.15)
        static var GemSpawnRight = RelativeCoordinate.init(x: 0.85, y: 0.15)
        static var LeftAstronaut = RelativeCoordinate.init(x: 0.15, y: 0.1)
        static var RightAstronaut = RelativeCoordinate.init(x: 0.85, y: 0.1)
        static var CollectorGlow = RelativeCoordinate.init(x: 0.525, y: 0.125)
        static var Starfield = RelativeCoordinate.init(x: 0, y: 1)
        static var TutorialGem = RelativeCoordinate.init(x: 0.5, y: 0.5)
        static var FlickHand = RelativeCoordinate.init(x: 0.65, y: 0.45)
        static var FlickHandTouch = RelativeCoordinate.init(x: 0.55, y: 0.45)
        static var FlickHandDownSlow = RelativeCoordinate.init(x: 0.55, y: 0.4)
        static var FlickHandDownFast = RelativeCoordinate.init(x: 0.55, y: 0.225)
        static var FlickHandRelease = RelativeCoordinate.init(x: 0.575, y: 0.25)
        static var FlickHandReset = RelativeCoordinate.init(x: 0.675, y: 0.45)
        static let MinusAlert = RelativeCoordinate.init(x: 0.8, y: 0.9)
    }
    
    public func relativePosToAbsolute(relativePos: RelativeCoordinate, constantX: CGFloat = 0, constantY: CGFloat = 0) -> CGPoint {
        return CGPoint(x: (size.width * relativePos.x) + constantX, y: (size.height * relativePos.y) + constantY)
    }
    
    private struct Constant {
        static let wallOffScreenDistance: CGFloat = 50
        static let gemSourceDistBelowAstronaut: CGFloat = 20
    }
    
    override func didMove(to view: SKView) {
        // Called immediately after scene is presented.
        
        physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.black
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = relativePosToAbsolute(relativePos: RelativeNodePosition.Starfield)
        starfield.zPosition = -10
        starfield.advanceSimulationTime(1)
        addChild(starfield)
        
        pauseButton.setScale(0.175)
        pauseButton.name = "pauseButton"
        pauseButton.position = relativePosToAbsolute(relativePos: RelativeNodePosition.PauseButton)
        addChild(pauseButton)
        
        setScoreLabel()
        
        addStagePlanet()
        addGemCollector()
        addGemSources()
        addAstronauts()
        
        makeWall(location: CGPoint(x: size.width/2, y: size.height + Constant.wallOffScreenDistance), size: CGSize(width: size.width*1.5, height: 1))
        makeWall(location: CGPoint(x: -Constant.wallOffScreenDistance, y: size.height/2), size: CGSize(width: 1, height: size.height+100))
        makeWall(location: CGPoint(x: size.width + Constant.wallOffScreenDistance, y: size.height/2), size: CGSize(width: 1, height: size.height+100))
        
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
    
    private func setScoreLabel() {
        // Tracks current game time
        
        scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "Score: \(timerSeconds)"
        scoreLabel.fontSize = 20
        //scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = relativePosToAbsolute(relativePos: RelativeNodePosition.ScoreLabel)
        addChild(scoreLabel)
    }

    private func addStagePlanet() {
        stagePlanet.setStagePlanetProperties()  // Calls stage properties from StagePlanet class
        stagePlanet.position = relativePosToAbsolute(relativePos: RelativeNodePosition.StagePlanet)
        addChild(stagePlanet)
    }
    
    private func addGemCollector() {
        gemCollector.setGemCollectorProperties()  // Calls gem collector properties from GemCollector class
        gemCollector.position = relativePosToAbsolute(relativePos: RelativeNodePosition.Collector)
        addChild(gemCollector)
    }
    
    private func addGemSources() {
        // Adds 2 gem sources, one for each astronaut
        
        leftGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        leftGemSource.position = relativePosToAbsolute(relativePos: RelativeNodePosition.LeftGemSource, constantY: -Constant.gemSourceDistBelowAstronaut)
        leftGemSource.name = "leftGemSource"
        addChild(leftGemSource)
        
        rightGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        rightGemSource.position = relativePosToAbsolute(relativePos: RelativeNodePosition.RightGemSource, constantY: -Constant.gemSourceDistBelowAstronaut)
        rightGemSource.name = "rightGemSource"
        addChild(rightGemSource)
    }
    
    private func addAstronauts() {
        // Creates 2 astronauts on either side of the planet
        
        redAstronaut.position = relativePosToAbsolute(relativePos: RelativeNodePosition.LeftAstronaut)
        redAstronaut.setScale(0.175)
        redAstronaut.name = "redAstronaut"
        redAstronaut.zPosition = 2
        redAstronaut.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.1*(size.width), height: 0.13*(size.height)))
        redAstronaut.physicsBody?.usesPreciseCollisionDetection = true
        redAstronaut.physicsBody?.isDynamic = false
        redAstronaut.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        blueAstronaut.position = relativePosToAbsolute(relativePos: RelativeNodePosition.RightAstronaut)
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
        
        let tempCollectorGlow = SKEmitterNode(fileNamed: "collectorGlow")!
        tempCollectorGlow.position = relativePosToAbsolute(relativePos: RelativeNodePosition.CollectorGlow)
        tempCollectorGlow.numParticlesToEmit = 8
        if implosion {
            tempCollectorGlow.particleColorSequence = nil;
            tempCollectorGlow.particleColorBlendFactor = 0.8
            tempCollectorGlow.particleColor = UIColor.red
            tempCollectorGlow.numParticlesToEmit = tempCollectorGlow.numParticlesToEmit * 2
        }
        addChild(tempCollectorGlow)
        // Remove collector glow node after 3 seconds
        run(SKAction.sequence([SKAction.wait(forDuration: 3.0), SKAction.run({tempCollectorGlow.removeFromParent()})]))
 
    }
    
    public func flashGemsLabelAnimation(color: SKColor, percentGrowth: Double = 1.075) {
        
        let colorScore = SKAction.run({self.gemsLabel.fontColor = color})
        let expand = SKAction.scale(by: CGFloat(percentGrowth), duration: 0.25)
        let shrink = SKAction.scale(by: CGFloat(1 / percentGrowth), duration: 0.25)
        let recolorWhite = SKAction.run({self.gemsLabel.fontColor = SKColor.white})
        let flashAnimation = SKAction.sequence([colorScore, expand, shrink, recolorWhite])
        
        gemsLabel.run(flashAnimation)
    }
    
    func onPauseButtonTouch() { 
        pauseAlert(title: "Game Paused", message: "")
    }
    
}
