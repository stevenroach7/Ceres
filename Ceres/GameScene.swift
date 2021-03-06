//
//  GameScene.swift
//  Ceres
//
//  Created by Steven Roach on 2/15/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var tutorialMode = false // Boolean to store whether game is in tutorialMode
    var isGameOver = false // Need a flag to know if we have began the game over transition so that we don't start it again. Necessary because we cannot set isPaused on the game scene without pausing the screen.
    
    // Global nodes
    let pauseButton = SKSpriteNode(imageNamed: "pause")
    let gemCollector = GemCollector(imageNamed: "collectorActive")
    let stagePlanet = StagePlanet(imageNamed: "planet")
    let leftGemSource  = GemSource(imageNamed: "hammerInactive")
    let rightGemSource = GemSource(imageNamed: "hammerInactive")
    let redAstronaut = Astronaut(imageNamed: "redAstronaut")
    let blueAstronaut = Astronaut(imageNamed: "blueAstronaut")
    var starfield: SKEmitterNode!
    
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
    
    var timeToBeginNextSequence: Double = 0.0 // Initialize to 0.0 so sequence will start when gameplay begins
    
    var spawnSequenceManager = SpawnSequenceManager()
    var audioManager = AudioManager()
    var animationManager = AnimationManager()
    
    let pauseTexture = SKTexture(imageNamed: "pause")
    let playTexture = SKTexture(imageNamed: "play")
    
    // This is the single source of truth for if the game is paused. Changes to this variable pauses game elements and brings up pause layer or vice versa.
    var gamePaused = false {
        didSet {
            pauseLayer.isHidden = !gamePaused
            isPaused = gamePaused
            gamePaused == true ? (physicsWorld.speed = 0) : (physicsWorld.speed = 1.0)
            gamePaused == true ? (audioManager.pauseBackgroundMusic()) : (audioManager.resumeBackgroundMusic())
            gamePaused == true ? (pauseButton.isHidden = true) : (pauseButton.isHidden = false)
        }
    }
    
    // This variable is automatically set to false when the scene is loaded which is not desired. We override it so that it always has the same value as gamePaused.
    override var isPaused: Bool {
        didSet {
            if isPaused != gamePaused {
                isPaused = gamePaused
            }
        }
    }

    // Data structures to deal with user touches
    var touchesToGems:[UITouch: SKSpriteNode] = [:] // Dictionary to map currently selected user touches to the gems they are dragging
    var selectedGems: Set<SKSpriteNode> = Set()
    var nodeDisplacements:[SKSpriteNode: CGVector] = [:] // Dictionary to map currently selected nodes to their displacements from the user's finger
    
    let gameLayer = SKNode()
    let pauseLayer = SKNode()
    
    override func didMove(to view: SKView) {
        // Called immediately after scene is presented.
        
        self.name = "game" // Identify scene as game so that GameViewController knows when the viewed scene is the GameScene
        
        physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.black
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = RelativePositions.Starfield.getAbsolutePosition(size: size)
        starfield.zPosition = -10
        starfield.advanceSimulationTime(1)
        gameLayer.addChild(starfield)
        
        let pauseButtonSize = RelativeScales.PauseButton.getAbsoluteSize(screenSize: size, nodeSize: pauseButton.size)
        pauseButton.xScale = pauseButtonSize.width
        pauseButton.yScale = pauseButtonSize.height
        pauseButton.name = "pauseButton"
        pauseButton.position = RelativePositions.PauseButton.getAbsolutePosition(size: size)
        gameLayer.addChild(pauseButton)
        
        setScoreLabel()
        
        addStagePlanet()
        addGemCollector()
        addGemSources()
        addAstronauts()
        
        makeWall(location: CGPoint(x: size.width/2, y: size.height + PositionConstants.wallOffScreenDistance), size: CGSize(width: size.width*1.5, height: 1))
        makeWall(location: CGPoint(x: -PositionConstants.wallOffScreenDistance, y: size.height/2), size: CGSize(width: 1, height: size.height+100))
        makeWall(location: CGPoint(x: size.width + PositionConstants.wallOffScreenDistance, y: size.height/2), size: CGSize(width: 1, height: size.height+100))

        animationManager.addAtlases()
        
        gameLayer.addChild(audioManager) // Pausing audio manager doesn't pause audio so this doesn't have to be a child of gameLayer
        audioManager.playBackgroundMusic()
        
        addPauseLayer()
        addChild(gameLayer)
        
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
        gameLayer.addChild(shape)
    }
    
    private func setScoreLabel() {
        // Tracks current game time
        
        scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "Score: \(timerSeconds)"
        scoreLabel.fontSize = 20
        scoreLabel.position = RelativePositions.ScoreLabel.getAbsolutePosition(size: size)
        gameLayer.addChild(scoreLabel)
    }

    private func addStagePlanet() {
        stagePlanet.setStagePlanetProperties()  // Calls stage properties from StagePlanet class
        stagePlanet.position = RelativePositions.StagePlanet.getAbsolutePosition(size: size)
        gameLayer.addChild(stagePlanet)
    }
    
    private func addGemCollector() {
        gemCollector.setGemCollectorProperties()  // Calls gem collector properties from GemCollector class
        gemCollector.position = RelativePositions.Collector.getAbsolutePosition(size: size)
        gameLayer.addChild(gemCollector)
    }
    
    private func addGemSources() {
        // Adds 2 gem sources, one for each astronaut
        
        leftGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        leftGemSource.position = RelativePositions.LeftGemSource.getAbsolutePosition(size: size, constantY: -PositionConstants.gemSourceDistBelowAstronaut)
        leftGemSource.name = "leftGemSource"
        gameLayer.addChild(leftGemSource)
        
        rightGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        rightGemSource.position = RelativePositions.RightGemSource.getAbsolutePosition(size: size, constantY: -PositionConstants.gemSourceDistBelowAstronaut)
        rightGemSource.name = "rightGemSource"
        gameLayer.addChild(rightGemSource)
    }
    
    private func addAstronauts() {
        // Creates 2 astronauts on either side of the planet
        
        redAstronaut.position = RelativePositions.LeftAstronaut.getAbsolutePosition(size: size)
        redAstronaut.setAstronautProperties()
        redAstronaut.name = "redAstronaut"
        gameLayer.addChild(redAstronaut)
        
        blueAstronaut.position = RelativePositions.RightAstronaut.getAbsolutePosition(size: size)
        blueAstronaut.setAstronautProperties()
        blueAstronaut.name = "blueAstronaut"
        gameLayer.addChild(blueAstronaut)
    }
    
    private func addPauseLayer() {
        
        let pauseMenu = SKSpriteNode(imageNamed: "pauseMenu")
        let pauseMenuSize = RelativeScales.PauseMenu.getAbsoluteSize(screenSize: size, nodeSize: pauseMenu.size)
        pauseMenu.xScale = pauseMenuSize.width
        pauseMenu.xScale = pauseMenuSize.height
        pauseMenu.position = RelativePositions.PauseMenu.getAbsolutePosition(size: size)
        pauseMenu.zPosition = 8
        pauseLayer.addChild(pauseMenu)
        
        let resume = SKSpriteNode(imageNamed: "play")
        resume.name = "resume"
        resume.setScale(0.3 * (size.width / resume.size.width))
        resume.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        resume.zPosition = 9
        pauseLayer.addChild(resume)
        
        let back = SKSpriteNode(imageNamed: "back")
        back.name = "back"
        back.setScale(0.2 * (size.width / back.size.width))
        back.position = CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        back.zPosition = 9
        pauseLayer.addChild(back)
        
        let restart = SKSpriteNode(imageNamed: "replay")
        restart.name = "restart"
        restart.setScale(0.2 * (size.width / restart.size.width))
        restart.zPosition = 9
        restart.position = CGPoint(x: size.width * 0.8, y: size.height * 0.5)
        pauseLayer.addChild(restart)
        
        pauseLayer.zPosition = 100
        pauseLayer.isHidden = true
        addChild(pauseLayer)
    }
    
    func onPauseButtonTouch() {
        gamePaused = true
        audioManager.play(sound: .button2Sound)
    }
}
