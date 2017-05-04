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
    let redAstronaut = Astronaut(imageNamed: "redAstronaut")
    let blueAstronaut = Astronaut(imageNamed: "blueAstronaut")
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
    
    
    var spawnSequenceManager = SpawnSequenceManager()
    var audioManager = AudioManager()
    var animationManager = AnimationManager()
    

    // Data structures to deal with user touches
    var touchesToGems:[UITouch: SKSpriteNode] = [:] // Dictionary to map currently selected user touches to the gems they are dragging
    var selectedGems: Set<SKSpriteNode> = Set()
    var nodeDisplacements:[SKSpriteNode: CGVector] = [:] // Dictionary to map currently selected nodes to their displacements from the user's finger
    
    
    override func didMove(to view: SKView) {
        // Called immediately after scene is presented.
        
        physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.black
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = RelativePositions.Starfield.getAbsolutePosition(size: size)
        starfield.zPosition = -10
        starfield.advanceSimulationTime(1)
        addChild(starfield)
        
        let pauseButtonSize = RelativeScales.PauseButton.getAbsoluteSize(screenSize: size, nodeSize: pauseButton.size)
        pauseButton.xScale = pauseButtonSize.width
        pauseButton.yScale = pauseButtonSize.height
        pauseButton.name = "pauseButton"
        pauseButton.position = RelativePositions.PauseButton.getAbsolutePosition(size: size)
        addChild(pauseButton)
        
        setScoreLabel()
        
        addStagePlanet()
        addGemCollector()
        addGemSources()
        addAstronauts()
        
        makeWall(location: CGPoint(x: size.width/2, y: size.height + PositionConstants.wallOffScreenDistance), size: CGSize(width: size.width*1.5, height: 1))
        makeWall(location: CGPoint(x: -PositionConstants.wallOffScreenDistance, y: size.height/2), size: CGSize(width: 1, height: size.height+100))
        makeWall(location: CGPoint(x: size.width + PositionConstants.wallOffScreenDistance, y: size.height/2), size: CGSize(width: 1, height: size.height+100))
        
        
        animationManager.addAtlases()
        
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
        shape.physicsBody?.categoryBitMask = PhysicsCategories.Wall;
        shape.physicsBody?.contactTestBitMask = PhysicsCategories.Gem;
        shape.physicsBody?.collisionBitMask = PhysicsCategories.None;
        self.addChild(shape)
    }
    
    private func setScoreLabel() {
        // Tracks current game time
        
        scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "Score: \(timerSeconds)"
        scoreLabel.fontSize = 20
        scoreLabel.position = RelativePositions.ScoreLabel.getAbsolutePosition(size: size)
        addChild(scoreLabel)
    }

    private func addStagePlanet() {
        stagePlanet.setStagePlanetProperties()  // Calls stage properties from StagePlanet class
        stagePlanet.position = RelativePositions.StagePlanet.getAbsolutePosition(size: size)
        addChild(stagePlanet)
    }
    
    private func addGemCollector() {
        gemCollector.setGemCollectorProperties()  // Calls gem collector properties from GemCollector class
        gemCollector.position = RelativePositions.Collector.getAbsolutePosition(size: size)
        addChild(gemCollector)
    }
    
    private func addGemSources() {
        // Adds 2 gem sources, one for each astronaut
        
        leftGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        leftGemSource.position = RelativePositions.LeftGemSource.getAbsolutePosition(size: size, constantY: -PositionConstants.gemSourceDistBelowAstronaut)
        leftGemSource.name = "leftGemSource"
        addChild(leftGemSource)
        
        rightGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        rightGemSource.position = RelativePositions.RightGemSource.getAbsolutePosition(size: size, constantY: -PositionConstants.gemSourceDistBelowAstronaut)
        rightGemSource.name = "rightGemSource"
        addChild(rightGemSource)
    }
    
    private func addAstronauts() {
        // Creates 2 astronauts on either side of the planet
        
        redAstronaut.position = RelativePositions.LeftAstronaut.getAbsolutePosition(size: size)
        redAstronaut.setAstronautProperties()
        redAstronaut.name = "redAstronaut"
        addChild(redAstronaut)
        
        blueAstronaut.position = RelativePositions.RightAstronaut.getAbsolutePosition(size: size)
        blueAstronaut.setAstronautProperties()
        blueAstronaut.name = "blueAstronaut"
        addChild(blueAstronaut)
    }
    
    public func collectGemAnimation(collector: SKSpriteNode, implosion: Bool) {
        collector.run(SKAction.repeat(SKAction.animate(with: animationManager.collectorFrames, timePerFrame: 0.25), count: 1))
        
        let tempCollectorGlow = SKEmitterNode(fileNamed: "collectorGlow")!
        tempCollectorGlow.position = RelativePositions.CollectorGlow.getAbsolutePosition(size: size)
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
        // Animates gems label
        
        let colorScore = SKAction.run({self.gemsLabel.fontColor = color})
        let expand = SKAction.scale(by: CGFloat(percentGrowth), duration: 0.25)
        let shrink = SKAction.scale(by: CGFloat(1 / percentGrowth), duration: 0.25)
        let recolorWhite = SKAction.run({self.gemsLabel.fontColor = SKColor.white})
        let flashAnimation = SKAction.sequence([colorScore, expand, shrink, recolorWhite])
        
        gemsLabel.run(flashAnimation)
    }
    
    func onPauseButtonTouch() {
        // Displays pause menu on screen
        pauseAlert(title: "Game Paused", message: "")
        
        let gameDimmer = SKSpriteNode(imageNamed: "dimGame")
        let gameDimmerSize = RelativeScales.GameDimmer.getAbsoluteSize(screenSize: size, nodeSize: gameDimmer.size)
        gameDimmer.xScale = gameDimmerSize.width
        gameDimmer.yScale = gameDimmerSize.height
        gameDimmer.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        gameDimmer.zPosition = 7
        //addChild(gameDimmer)
        
        let pauseMenu = SKSpriteNode(imageNamed: "pauseMenu")        
        let pauseMenuSize = RelativeScales.PauseMenu.getAbsoluteSize(screenSize: size, nodeSize: pauseMenu.size)
        pauseMenu.xScale = pauseMenuSize.width
        pauseMenu.xScale = pauseMenuSize.height
        
        pauseMenu.position = CGPoint(x: size.width * 0.5, y: size.height * 0.55)
        pauseMenu.zPosition = 8
        //addChild(pauseMenu)
        
        let resume = SKSpriteNode(imageNamed: "play")
        resume.setScale(0.3 * (size.width / resume.size.width))
        resume.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        resume.zPosition = 9
        //addChild(resume)
        
        let back = SKSpriteNode(imageNamed: "back")
        back.setScale(0.2 * (size.width / back.size.width))
        back.position = CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        back.zPosition = 9
        //addChild(back)
        
        let restart = SKSpriteNode(imageNamed: "replay")
        restart.setScale(0.2 * (size.width / restart.size.width))
        restart.zPosition = 9
        restart.position = CGPoint(x: size.width * 0.8, y: size.height * 0.5)
        //addChild(restart)
    }
}
