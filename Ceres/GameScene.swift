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
    
    var collectorAtlas = SKTextureAtlas()
    var collectorFrames = [SKTexture]()
    
    var hammerAtlas = SKTextureAtlas()
    var hammerFrames = [SKTexture]()
    
    let gemCollectedSound = SKAction.playSoundFileNamed("hydraulicSound.wav", waitForCompletion: false)
    let gemCreatedSound   = SKAction.playSoundFileNamed("anvil.mp3", waitForCompletion: false)
    let zoomTimerSound     = SKAction.playSoundFileNamed("boop.wav", waitForCompletion: false)
    let zipTimerSound    = SKAction.playSoundFileNamed("zwip.wav", waitForCompletion: false)
    
    var backButton = SKSpriteNode(imageNamed: "back-1")
    var pauseButton = SKSpriteNode(imageNamed: "pause")
    let leftGemSource  = SKSpriteNode(imageNamed: "hammerInactive")
    let rightGemSource = SKSpriteNode(imageNamed: "hammerInactive")
    let redAstronaut = SKSpriteNode(imageNamed: "redAstronaut")
    let blueAstronaut = SKSpriteNode(imageNamed: "blueAstronaut")
    var starfield:SKEmitterNode!
    
    var scoreLabel: SKLabelNode!
    var gemsPlusMinus = 0 {
        didSet {
            scoreLabel.text = "+/-: \(gemsPlusMinus)"
        }
    }
    let losingGemPlusMinus = -5 // Make this lower during testing
    
    var timerLabel: SKLabelNode!
    var timerSeconds = 0 {
        didSet {
            timerLabel.text = "Time: \(timerSeconds)"
        }
    }
    
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
    
    var currSprite: SKNode! = nil

    // TODO: Decompose this method
    override func didMove(to view: SKView) {
        // Called immediately after scene is presented.
        physicsWorld.contactDelegate = self
       
        backgroundColor = SKColor.black
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.zPosition = -10
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        
        backButton.setScale(0.175)
        backButton.position = CGPoint(x: size.width/10, y: size.height - size.height/24) // TODO: Change how to calculate height, use constants
        addChild(backButton)
        
        pauseButton.setScale(0.175)
        pauseButton.position = CGPoint(x: 9*size.width/10, y: size.height - size.height/24) // TODO: Change how to calculate height
        addChild(pauseButton)
        
        setScoreLabel()
        setTimerLabel()
        
        run(SKAction.repeatForever( // Serves as timer, Could potentially refactor to use group actions later.
            SKAction.sequence([
                SKAction.run(spawnGems),
                SKAction.wait(forDuration: 1.0),
                SKAction.run(incrementTimer)
                ])
        ))
        
        addStagePlanet()
        addGemCollector()
        addGemSource()
        addAstronauts()
        
        makeWall(location: CGPoint(x: size.width/2, y: size.height+50), size: CGSize(width: size.width*1.5, height: 1))
        makeWall(location: CGPoint(x: -50, y: size.height/2), size: CGSize(width: 1, height: size.height+100))
        makeWall(location: CGPoint(x: size.width+50, y: size.height/2), size: CGSize(width: 1, height: size.height+100))
        
        collectorAtlas = SKTextureAtlas(named: "collectorImages")
        collectorFrames.append(SKTexture(imageNamed: "collectorActive.png"))
        collectorFrames.append(SKTexture(imageNamed: "collectorInactive.png"))
        
        hammerAtlas = SKTextureAtlas(named: "hammerImages")
        hammerFrames.append(SKTexture(imageNamed: "hammerActive.png"))
        hammerFrames.append(SKTexture(imageNamed: "hammerInactive.png"))
        
        let backgroundMusic = SKAudioNode(fileNamed: "cosmos.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        // Adjust gravity of scene
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0.27) // Gravity on Ceres is 0.27 m/s²
        //        let gravityFieldNode = SKFieldNode.radialGravityField()
        //        gravityFieldNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        //        addChild(gravityFieldNode)
    }
    
    private func animateCollector(collector: SKSpriteNode) {
        collector.run(SKAction.repeat(SKAction.animate(with: collectorFrames, timePerFrame: 0.25), count: 1))
        collector.run(gemCollectedSound)
    }
    
    private func animateHammer(source: SKSpriteNode) {
        source.run(SKAction.repeat(SKAction.animate(with: hammerFrames, timePerFrame: 0.15), count: 1))
        source.run(gemCreatedSound)
    }
    
    private func gemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        gemsPlusMinus += 1
        animateCollector(collector: collector)
        gem.removeFromParent()
    }
    
    private func gemOffScreen(gem: SKSpriteNode) {
        // Removes gems from game scene when they fly off screen
        gemsPlusMinus -= 1
        gem.removeFromParent()
        if isGameOver() {
            gameOverTransition()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //Called everytime two physics bodies collide
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //categoryBitMasks are UInt32 values
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //If the two colliding bodies are a gem and gemCollector, remove the gem
        if ((firstBody.categoryBitMask == PhysicsCategory.GemCollector) &&
            (secondBody.categoryBitMask == PhysicsCategory.Gem)) {
            if let gem = secondBody.node as? SKSpriteNode, let collector = firstBody.node as? SKSpriteNode {
                gemDidCollideWithCollector(gem: gem, collector: collector)
            }
        }

        //If the two colliding bodies are a gem and wall, remove the gem
        if ((firstBody.categoryBitMask == PhysicsCategory.Wall) &&
            (secondBody.categoryBitMask == PhysicsCategory.Gem)) {
            if let gem = secondBody.node as? SKSpriteNode {
                gemOffScreen(gem: gem)
            }
        }
    }
    
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
        // Tracks current game score
        scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "+/-: \(gemsPlusMinus)"
        scoreLabel.fontSize = 13
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: size.width * 0.75, y: size.height - size.height/19)
        addChild(scoreLabel)
    }
    
    private func setTimerLabel() {
        // Tracks current game time
        timerLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        timerLabel.text = "Time: \(timerSeconds)"
        timerLabel.fontSize = 13
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: size.width * 0.5, y: size.height - size.height/19)
        addChild(timerLabel)
    }
    
    private func incrementTimer() {
        timerSeconds += 1
        if (timerSeconds % 10 >= 7){
            timerLabel.fontSize += 1
            self.run(zoomTimerSound)
        } else if (timerSeconds % 10 == 0 && timerSeconds > 0){
            self.run(zipTimerSound)
            timerLabel.fontSize = 13
        }
    }
    
    private func isGameOver() -> Bool {
        // Calculates score to figure out when to end the game
        return (gemsPlusMinus <= losingGemPlusMinus)
    }
    
    private func gameOverTransition() {
        self.isPaused = true
        if view != nil {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = GameOverScene(size: self.size) // TODO: Need a way to pass score to the GameOverScene
            scene.setScore(score: timerSeconds)
            self.view?.presentScene(scene, transition: transition)
        }
        removeAllActions()
    }
    
    private func spawnGems() { // TODO: Possibly refactor so that gamSpawn Sequences are in a sequence instead of being called based on the timerSeconds value.
        // Called every second, calls gem spawning sequences based on game timer
        if timerSeconds % 10 == 0 {
            switch timerSeconds {
            case 0:
                gemSpawnSequence1()
            case 10:
                gemSpawnSequence2()
            default:
                gemSpawnSequence3()
            }
        }
    }
    
    private func gemSpawnSequence1() {
        // Gem spawning routine
        run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run(addGemLeft), SKAction.wait(forDuration: 1.0), SKAction.run(addGemRight)]), count: 5))
    }
    
    private func gemSpawnSequence2() {
        // Gem spawning routine
        run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                            SKAction.run(addGemLeft),
                                            SKAction.wait(forDuration: 0.25),
                                            SKAction.run(addGemRight)
                                            ]),
                            count: 8))
    }
    
    private func gemSpawnSequence3() {
        // Gem spawning routine
        run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.25),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.25),
                                               SKAction.run(addGemLeft),
                                               SKAction.run(addGemRight)
            
            ]),
                            count: 7))
    }
    
    // Helper methods to generate random numbers.
    private func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    private func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    private func addGem() {
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        let spawnLocation = CGPoint(x: size.width / 2, y: size.height / 10)
        gem.position = spawnLocation
        addChild(gem)
    }
    
    private func addGemLeft() {
        // Produces a Gem from the left astronaut
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        let angle = random(min: CGFloat.pi * (1/4), max: CGFloat.pi * (1/2))
        gem.setGemVelocity(velocity: 180, angle: angle)
        gem.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1 - 5)
        addChild(gem)
    }
    
    private func addGemRight() {
        // Produces a Gem from the right astronaut
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        let angle = random(min: CGFloat.pi * (1/2), max: CGFloat.pi * (3/4))
        gem.setGemVelocity(velocity: 180, angle: angle)
        gem.position = CGPoint(x: size.width * 0.9, y: size.height * 0.1 - 5)
        addChild(gem)
    }
    
    private func addStagePlanet() {
        let stagePlanet = StagePlanet(imageNamed: "planet")
        stagePlanet.setStagePlanetProperties()  // Calls stage properties from StagePlanet class
        stagePlanet.position = CGPoint(x: size.width * 0.5, y: size.height * 0.075)
        addChild(stagePlanet)
    }
    
    private func addGemCollector() {
        let gemCollector = GemCollector(imageNamed: "collectorInactive")
        gemCollector.setGemCollectorProperties()  // Calls gem collector properties from GemCollector class
        gemCollector.position = CGPoint(x: size.width / 2, y: size.height * 0.075)
        addChild(gemCollector)
    }
    
    private func addGemSource() {
        // Adds 2 gem sources, one for each astronaut
        let leftGemSource = GemSource(imageNamed: "hammerInactive")
        leftGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        leftGemSource.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1 - 20)
        leftGemSource.name = "leftGemSource"
        addChild(leftGemSource)
        
        let rightGemSource = GemSource(imageNamed: "hammerInactive")
        rightGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        rightGemSource.position = CGPoint(x: size.width * 0.9, y: size.height * 0.1 - 20)
        rightGemSource.name = "rightGemSource"
        addChild(rightGemSource)
    }
    
    private func addAstronauts() {
        // Creates 2 astronauts on either side of the planet
        redAstronaut.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        redAstronaut.setScale(0.175)
        redAstronaut.name = "redAstronaut"
        redAstronaut.zPosition = 2
        redAstronaut.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        blueAstronaut.position = CGPoint(x: size.width * 0.9, y: size.height * 0.1)
        blueAstronaut.setScale(0.175)
        blueAstronaut.name = "blueAstronaut"
        blueAstronaut.zPosition = 2
        blueAstronaut.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        addChild(redAstronaut)
        addChild(blueAstronaut)
    }
    
    private func onGemSourceTouch(source: SKSpriteNode) {
        if self.isPaused == false {
            addGem()
            animateHammer(source: source)
        }
    }

    var touchPoint: CGPoint = CGPoint();
    var currSpriteInitialDisplacement: CGVector = CGVector(); //The initial displacement from the touched Node and the touch location, used to avoid gittery motion in the update method
    var touching: Bool = false;
    
    func onGemTouch(touchedNode: SKNode, touchLocation: CGPoint) {
        currSprite = touchedNode //Set the current node touched
        touchPoint = touchLocation
        currSpriteInitialDisplacement = CGVector(dx: touchPoint.x - currSprite.position.x, dy: touchPoint.y - currSprite.position.y)
        touching = true
    }
    
    private func onBackButtonTouch() {
        var wasPaused: Bool
        if self.isPaused {
            wasPaused = true
        } else {
            wasPaused = false
            self.isPaused = true
        }
        // Calls an alert to make sure touch was intentional
        let resumeAction = UIAlertAction(title: "Resume Game", style: UIAlertActionStyle.default)  { (action:UIAlertAction!) in
            if !wasPaused {
                // Only play game if game wasn't paused when back button was touched
                self.pauseButton.texture = SKTexture(imageNamed:"pause")
                self.isPaused = false
            }
        }
        backAlert(title: "WARNING", message: "You will lose your current progress", resumeAction: resumeAction)
    }
    
    private func onPauseButtonTouch() {
        if self.isPaused {
            pauseButton.texture = SKTexture(imageNamed:"pause")
            self.isPaused = false
        } else {
            pauseButton.texture = SKTexture(imageNamed:"play")
            self.isPaused = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Method to handle touch events. Senses when user touches down (places finger on screen).
        
        // Choose first touch
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation) as? SKSpriteNode
        
        // Determines what was touched, if anything
        if let name = touchedNode?.name {
            
            switch name {
            case "rightGemSource":
                onGemSourceTouch(source: touchedNode!)
            case "leftGemSource":
                onGemSourceTouch(source: touchedNode!)
            case "gem":
                onGemTouch(touchedNode: touchedNode!, touchLocation: touchLocation)
            default: break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Method to handle touch events.  Senses when the user moves their touch (moves finger on screen).
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        touchPoint = touchLocation
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Method to handle touch events. Senses when user touches up (removes finger from screen).
        touching = false
        
        // Choose first touch
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        // Determines what was touched, if anything
        switch touchedNode {
        case backButton:
            onBackButtonTouch()
        case pauseButton:
            onPauseButtonTouch()
        default: break
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        // Calculates velocity using physics engine
        if touching {
            let dt:CGFloat = 1.0/60.0 //determines drag and flick speed
            let distance = CGVector(dx: touchPoint.x - currSprite.position.x - currSpriteInitialDisplacement.dx, dy: touchPoint.y - currSprite.position.y - currSpriteInitialDisplacement.dy)
            let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
            currSprite.physicsBody!.velocity = velocity
        }
    }
    
}
