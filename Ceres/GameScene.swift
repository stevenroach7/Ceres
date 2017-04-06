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
    let gemCreatedSound = SKAction.playSoundFileNamed("anvil.mp3", waitForCompletion: false)
    let zoomTimerSound = SKAction.playSoundFileNamed("boop.wav", waitForCompletion: false)
    let zipTimerSound = SKAction.playSoundFileNamed("zwip.wav", waitForCompletion: false)
    
    var pauseButton = SKSpriteNode(imageNamed: "pause")
    
    let swipedown = SKSpriteNode(imageNamed: "swipedown")

    let leftGemSource  = GemSource(imageNamed: "hammerInactive")
    let rightGemSource = GemSource(imageNamed: "hammerInactive")

    let redAstronaut = SKSpriteNode(imageNamed: "redAstronaut")
    let blueAstronaut = SKSpriteNode(imageNamed: "blueAstronaut")
    var starfield:SKEmitterNode!
    //var gemEffect:SKEmitterNode!
    
    var scoreLabel: SKLabelNode!
    var gemsPlusMinus = 0 {
        didSet {
            scoreLabel.text = "+/-: \(gemsPlusMinus)"
        }
    }
    let losingGemPlusMinus = -1 // Make this lower during testing
    
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
        pauseButton.position = CGPoint(x: size.width/12, y: size.height - size.height/24) // TODO: Change how to calculate height, use constants
        addChild(pauseButton)
        
        setScoreLabel(font: 30, position: CGPoint(x: size.width/2, y: size.height * 0.7))
        setTimerLabel()
        
        addStagePlanet()
        addGemCollector()
        addGemSource()
        addAstronauts()
        
        prepareTutorial()
        
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
        
    }
    
    private func animateCollector(collector: SKSpriteNode) {
        collector.run(SKAction.repeat(SKAction.animate(with: collectorFrames, timePerFrame: 0.25), count: 1))
        collector.run(gemCollectedSound)
    }
    
    private func animateLeftHammer() { // Need a function without arguments to be called in the SKAction
        leftGemSource.run(SKAction.animate(with: hammerFrames, timePerFrame: 0.35)) // Animation consists of 2 frames.
    }
    
    private func animateRightHammer() { // Need a function without arguments to be called in the SKAction
        rightGemSource.run(SKAction.animate(with: hammerFrames, timePerFrame: 0.35)) // Animation consists of 2 frames.
    }
    
    private func gemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        gemsPlusMinus += 1
        recolorScore()
        animateCollector(collector: collector)
        gem.removeFromParent()
        if isTutorialOver() {
            endTutorial()
            beginGameplay()
        }
        //gemEffect.removeFromParent()
    }
    
    private func gemOffScreen(gem: SKSpriteNode) {
        // Removes gems from game scene when they fly off screen
        gemsPlusMinus -= 1
        recolorScore()
        gem.removeFromParent()
        if isGameOver() {
            gameOverTransition()
        }
    }
    
    private func tutorialGemOffScreen(gem:SKSpriteNode) {
        if timerSeconds == 0 {
            gemsPlusMinus += 1
            addTutorialGem()
        }
    }
    
    private func recolorScore(){
        if gemsPlusMinus < 0 {
            scoreLabel.fontColor = SKColor.red
        } else if gemsPlusMinus > 0{
            scoreLabel.fontColor = SKColor.green
        } else {
            scoreLabel.fontColor = SKColor.white
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
                tutorialGemOffScreen(gem: gem)
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
        timerLabel.fontSize = 14
        //timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: size.width * 0.5, y: size.height - size.height/20)
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
            timerLabel.fontColor = SKColor.cyan
        } else {
            timerLabel.fontColor = SKColor.white
        }
    }
    
    private func isTutorialOver() -> Bool {
        return (gemsPlusMinus == 1 && timerSeconds==0)
    }
    
    private func prepareTutorial() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0.01)
        addTutorialGem()
        
        swipedown.position = CGPoint(x: size.width * 0.525, y: size.height * 0.33)
        swipedown.setScale(0.3)
        addChild(swipedown)
    }
    
    private func endTutorial() {
        swipedown.removeFromParent()

        let scaleDown = SKAction.scale(by: 14/30, duration: 4.0)
        let moveUp = SKAction.move(to: CGPoint(x: size.width * 0.8, y: size.height - size.height/20), duration: 4.0)
        //let scaleAndMove = SKAction.sequence([scaleDown,moveUp])
        scoreLabel.run(scaleDown)
        scoreLabel.run(moveUp)
    }
    
    
    private func beginGameplay() {
        // Adjust gravity of scene
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0.27) // Gravity on Ceres is 0.27 m/s²
        //        let gravityFieldNode = SKFieldNode.radialGravityField()
        //        gravityFieldNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        //        addChild(gravityFieldNode)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(animateLeftHammer),
                SKAction.wait(forDuration: 0.35),
                SKAction.run(animateRightHammer),
                SKAction.wait(forDuration: 0.35),
                ])
        ))
        
        run(SKAction.repeatForever( // Serves as timer, Could potentially refactor to use group actions later.
            SKAction.sequence([
                SKAction.run(spawnGems),
                SKAction.wait(forDuration: 1.0),
                SKAction.run(incrementTimer),
                ])
        ))
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
            case 20:
                gemSpawnSequence3()
            case 30:
                gemSpawnSequence4()
            case 40:
                gemSpawnSequence4()
            default:
                gemSpawnSequenceHard()
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
    
    private func gemSpawnSequence4() {
        run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 2.47),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
            
            
                                               SKAction.wait(forDuration: 2.47),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               ]),
                            count: 2))
    }
    
    private func gemSpawnSequenceHard() {
        run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 0.74),
                                            SKAction.wait(forDuration: 0.01),
                                            SKAction.run(addGemRight),
                                            SKAction.wait(forDuration: 0.01),
                                            SKAction.run(addGemRight),
                                            SKAction.run(addGemLeft),
                                            SKAction.wait(forDuration: 0.01),
                                            SKAction.run(addGemRight),
                                            
                                            SKAction.wait(forDuration: 0.2),
                                            SKAction.wait(forDuration: 0.01),
                                            SKAction.run(addGemLeft),
                                            SKAction.wait(forDuration: 0.01),
                                            SKAction.run(addGemLeft),
                                            SKAction.run(addGemRight),
                                            SKAction.wait(forDuration: 0.01),
                                            SKAction.run(addGemLeft),
            ]),
                            count: 10))
        
        
    }
    
    // Helper methods to generate random numbers.
    private func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    private func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    private func addTutorialGem() {
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        let spawnLocation = CGPoint(x: size.width * 0.45, y: size.height / 2)
        gem.position = spawnLocation
        addChild(gem)
    }
    
    private func addGemLeft() {
        // Produces a Gem from the left astronaut
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        let angle = random(min: CGFloat.pi * (1/4), max: CGFloat.pi * (1/2))
        gem.setGemVelocity(velocity: 180, angle: angle)
        gem.position = CGPoint(x: size.width * 0.1, y: size.height * 0.15)
        addChild(gem)
    }
    
    private func addGemRight() {
        // Produces a Gem from the right astronaut
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        let angle = random(min: CGFloat.pi * (1/2), max: CGFloat.pi * (3/4))
        gem.setGemVelocity(velocity: 180, angle: angle)
        gem.position = CGPoint(x: size.width * 0.9, y: size.height * 0.15)
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
        gemCollector.position = CGPoint(x: size.width / 2, y: size.height * 0.085)
        addChild(gemCollector)
    }
    
    private func addGemSource() {
        // Adds 2 gem sources, one for each astronaut
        leftGemSource.setGemSourceProperties()  // Calls gem source properties from GemSource class
        leftGemSource.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1 - 20)
        leftGemSource.name = "leftGemSource"
        addChild(leftGemSource)
        
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
        redAstronaut.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.1*(size.width), height: 0.13*(size.height)))
        redAstronaut.physicsBody?.usesPreciseCollisionDetection = true
        redAstronaut.physicsBody?.isDynamic = false
        redAstronaut.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        blueAstronaut.position = CGPoint(x: size.width * 0.9, y: size.height * 0.1)
        blueAstronaut.setScale(0.175)
        blueAstronaut.name = "blueAstronaut"
        blueAstronaut.zPosition = 2
        blueAstronaut.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.1*(size.width), height: 0.13*(size.height)))
        blueAstronaut.physicsBody?.usesPreciseCollisionDetection = true
        blueAstronaut.physicsBody?.isDynamic = false //Change this to true to be amused
        blueAstronaut.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        addChild(redAstronaut)
        addChild(blueAstronaut)
    }
    
    private func onLeftGemSourceTouch() {
        if self.isPaused == false {
            addGemLeft()
            run(gemCreatedSound)
        }
    }
    
    private func onRightGemSourceTouch() {
        if self.isPaused == false {
            addGemRight()
            run(gemCreatedSound)
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
        
        
        //gemEffect = SKEmitterNode(fileNamed: "gemMoveEffect")
        //gemEffect.position = touchLocation;
        //gemEffect.zPosition = 10
        //addChild(gemEffect)
    }
    
    private func onpauseButtonTouch() {
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
                self.isPaused = false
            }
        }
        backAlert(title: "WARNING", message: "You will lose your current progress", resumeAction: resumeAction)
    }
    
    
    private func findNearestGem (touchLocal: CGPoint) -> (CGFloat, SKNode){
        //Method iterates over all gems and returns the closest one with the distance to said gem
        
        var minDist: CGFloat = 44
        var closestGem: SKSpriteNode = SKSpriteNode()
        self.enumerateChildNodes(withName: "gem"){node,_ in
            let xDist = node.position.x - touchLocal.x
            let yDist = node.position.y - touchLocal.y
            let dist = CGFloat(sqrt((xDist*xDist) + (yDist*yDist)))
            if dist < minDist {
                minDist = dist
                closestGem = (node as? SKSpriteNode)!
            }
        }
        return (minDist, closestGem)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Method to handle touch events. Senses when user touches down (places finger on screen).
        
        // Choose first touch
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        var touchedNode = atPoint(touchLocation) as? SKSpriteNode
        
        let (minDist, closestGem) = findNearestGem(touchLocal: touchLocation)
        
        if (minDist < 44){ //If the touch is within 44 px of gem, change touched node to gem
            touchedNode = closestGem as? SKSpriteNode
        }
        
        // Determines what was touched, if anything
        if let name = touchedNode?.name {
            
            switch name {
            case "rightGemSource":
                onRightGemSourceTouch()
            case "leftGemSource":
                onLeftGemSourceTouch()
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
        case pauseButton:
            onpauseButtonTouch()
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
