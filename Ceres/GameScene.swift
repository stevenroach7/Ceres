//
//  GameScene.swift
//  Ceres
//
//  Created by Steven Roach on 2/15/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox.AudioServices

class GameScene: SKScene, SKPhysicsContactDelegate, Alerts {
    
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
    
    var pauseButton = SKSpriteNode(imageNamed: "pause")
    
    let flickHand = SKSpriteNode(imageNamed: "touch")

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
        pauseButton.position = CGPoint(x: size.width/12, y: size.height - size.height/24) // TODO: Change how to calculate height, use constants
        addChild(pauseButton)
        
        setScoreLabel(font: 30, position: CGPoint(x: size.width/2, y: size.height * 0.7))
        setTimerLabel()
        
        addStagePlanet()
        addGemCollector()
        addGemSources()
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
    
    private func collectGemAnimation(collector: SKSpriteNode) {
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
        collectGemAnimation(collector: collector)
        gem.removeFromParent()
        if isTutorialOver() {
            endTutorial()
            beginGameplay()
        }
        //gemEffect.removeFromParent()
    }
    
    // Variables necessary to reset shaken sprites back to original position
    // TODO: if we refactor sprites to globals instead of being declared and initialized in functions this redundancy can be removed
    var gemCollectorPosX: CGFloat! = nil
    var scoreLabelPosX: CGFloat! = nil
    
    private func shakeAction(positionX : CGFloat) -> SKAction {
        //returns a shaking animation
        
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
    
    
    private func detonatorGemDidCollideWithCollector(gem: SKSpriteNode, collector: SKSpriteNode) {
        // Removes gem from game scene and increments number of gems collected
        
        let shakeCollector = shakeAction(positionX: gemCollectorPosX)
        collectGemAnimation(collector: collector)
        
        collector.run(shakeCollector)
        self.run(collectorExplosionSound)
        
        let shakeScore = shakeAction(positionX: scoreLabel.position.x)
        scoreLabel.run(shakeScore)
        recolorScore()
        
        gemsPlusMinus -= 5
        
        penaltyAlert()
        
        gem.removeFromParent()
        //gemEffect.removeFromParent()
        checkGameOver()
    }
    
    private func gemOffScreen(gem: SKSpriteNode) {
        // Removes gems from game scene when they fly off screen
        if (gem.name == "gem") { //don't want to decrement score when detonating gems go offscreen
            gemsPlusMinus -= 1
            recolorScore()
        }
        gem.removeFromParent()
        checkGameOver()
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
        } else if gemsPlusMinus > 0 {
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
                switch gem.name! {
                case "gem":
                    gemDidCollideWithCollector(gem: gem, collector: collector)
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
        timerLabel.fontSize = 20
        //timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: size.width * 0.4, y: size.height - size.height/20)
        addChild(timerLabel)
    }
    
    private func incrementTimer() {
        timerSeconds += 1
        if (timerSeconds % 10 >= 7){
            timerLabel.fontSize += 1
            self.run(zoomTimerSound)
        } else if (timerSeconds % 10 == 0 && timerSeconds > 0){
            self.run(zipTimerSound)
            timerLabel.fontSize -= 3
            timerLabel.fontColor = SKColor.cyan
        } else {
            timerLabel.fontColor = SKColor.white
        }
    }
    
    private func isTutorialOver() -> Bool {
        return (gemsPlusMinus == 1 && timerSeconds == 0)
    }
    
    private func prepareTutorial() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0.01)
        addTutorialGem()
        makeTutorialHand()
    }
    
    private func makeTutorialHand() {
        let touch = SKAction.setTexture(SKTexture(imageNamed: "touch"))
        let drag  = SKAction.setTexture(SKTexture(imageNamed: "drag"))
        let flick = SKAction.setTexture(SKTexture(imageNamed: "flick"))
        
        flickHand.position = CGPoint(x: size.width * 0.65, y: size.height * 0.45)
        flickHand.setScale(0.3)
        flickHand.zPosition=9
        addChild(flickHand)
        
        let initiateTouch = SKAction.move(to: CGPoint(x: size.width * 0.525, y: size.height * 0.45), duration: 0.6)
        let moveDownSlow = SKAction.move(to: CGPoint(x: size.width * 0.525, y: size.height * 0.4), duration: 0.75)
        let moveDownFast = SKAction.move(to: CGPoint(x: size.width * 0.525, y: size.height * 0.15), duration: 0.5)
        let release = SKAction.move(to: CGPoint(x: size.width * 0.55, y: size.height * 0.175), duration: 0.15)
        let resetHand = SKAction.move(to: CGPoint(x: size.width * 0.65, y: size.height * 0.45), duration: 0.1)
        
        //let hide = SKAction.hide()
        //let show = SKAction.unhide()
        
        let shortWait = SKAction.wait(forDuration: 0.2)
        let longWait = SKAction.wait(forDuration: 1.25)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let fadeIn  = SKAction.fadeIn(withDuration: 0.5)
        
        let tutorialAnimation = SKAction.sequence([
            touch,
            fadeIn,
            initiateTouch,
            drag,
            moveDownSlow,
            moveDownFast,
            flick,
            release,
            shortWait,
            fadeOut,
            resetHand,
            longWait,
            //show,
            ])
        flickHand.run(SKAction.repeatForever(tutorialAnimation))
    }
    
    private func penaltyAlert(){
        let deduction = SKLabelNode(fontNamed: "Menlo-Bold")
        deduction.text = "-5"
        deduction.fontColor = SKColor.red
        deduction.fontSize = 32
        deduction.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(deduction)
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        deduction.run(SKAction.fadeOut(withDuration: 1.5))
        
    }
    
    private func endTutorial() {
        flickHand.removeFromParent() // TODO: Move this elsewhere later if we want hand to be removed when user touches gem

        let scaleDown = SKAction.scale(by: 2/3, duration: 0.75)
        let finalScoreLabelPosition = CGPoint(x: size.width * 0.75, y: size.height - size.height/20)
        let moveUp = SKAction.move(to: finalScoreLabelPosition, duration: 0.75)
        
        scoreLabelPosX = finalScoreLabelPosition.x
        scoreLabel.run(scaleDown)
        scoreLabel.run(moveUp)
        
        let expand = SKAction.scale(by: 3/2, duration: 1.0)
        let shrink = SKAction.scale(by: 2/3, duration: 1.0)
        let expandAndShrink = SKAction.sequence([expand,shrink])
        timerLabel.run(expandAndShrink)
    }
    
    private func beginGameplay() {
        // Adjust gravity of scene
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0.27) // Gravity on Ceres is 0.27 m/s²
        
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
    
    private func checkGameOver() {
        // Calculates score to figure out when to end the game
        if gemsPlusMinus <= losingGemPlusMinus {
            gameOverTransition()
        }
    }
    
    private func gameOverTransition() {
        self.isPaused = true
        if view != nil {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene = GameOverScene(size: self.size)
            scene.setScore(score: timerSeconds)
            self.view?.presentScene(scene, transition: transition)
        }
        removeAllActions()
    }
    
    // Helper methods to generate random numbers.
    private func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    private func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
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
                gemSpawnSequenceBasicDetonators()
            case 30:
                gemSpawnSequence3()
            case 40:
                gemSpawnSequence4()
            case 50:
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
                                               SKAction.run(addGemRight),
                                               ]),
                            count: 8))
    }
    
    private func gemSpawnSequence3() {
        // Gem spawning routine
        run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.25),
                                               SKAction.run(addGemRight),
                                               SKAction.run(detonateGemSequence),
                                               SKAction.wait(forDuration: 0.25),
                                               SKAction.run(addGemLeft),
                                               SKAction.run(addGemRight),
                                               
                                               ]),
                            count: 7))
    }
    
    private func gemSpawnSequence4() {
        run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 2.47),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run(detonateGemSequence),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run(detonateGemSequence),
                                               
                                               SKAction.wait(forDuration: 2.47),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run(detonateGemSequence),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               ]),
                            count: 2))
    }
    
    private func gemSpawnSequenceBasicDetonators() {
        run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 2.47),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run(detonateGemSequence),
                                               
                                               
                                               SKAction.wait(forDuration: 2.47),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemRight),
                                               SKAction.run(detonateGemSequence),
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
                                               SKAction.run(detonateGemSequence),
                                               
                                               SKAction.wait(forDuration: 0.2),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               SKAction.run(addGemRight),
                                               SKAction.run(detonateGemSequence),
                                               SKAction.wait(forDuration: 0.01),
                                               SKAction.run(addGemLeft),
                                               ]),
                            count: 10))
    }

    private func addTutorialGem() {
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        gem.position = CGPoint(x: size.width * 0.45, y: size.height / 2)
        addChild(gem)
    }
    
    // TODO: Refactor to make addGem one method that takes a parameter to change the spawning location
    private func addGemLeft() {
        // Produces a Gem from the left astronaut
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        let angle = random(min: CGFloat.pi * (1/4), max: CGFloat.pi * (1/2))
        let velocity = random(min: 170, max: 190)
        gem.setGemVelocity(velocity: velocity, angle: angle)
        gem.position = CGPoint(x: size.width * 0.1, y: size.height * 0.15)
        addChild(gem)
    }
    
    private func addGemRight() {
        // Produces a Gem from the right astronaut
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()  // Calls gem properties from Gem class
        let angle = random(min: CGFloat.pi * (1/2), max: CGFloat.pi * (3/4))
        let velocity = random(min: 170, max: 190)
        gem.setGemVelocity(velocity: velocity, angle: angle)
        gem.position = CGPoint(x: size.width * 0.9, y: size.height * 0.15)
        addChild(gem)
    }
    
    private func addDetonatorGem(detonatorGem: Gem) { // TODO: Refactor this to take a parameter for left and right.
        // Takes a gem and adds it to the scene in a manner specific to detonator gems
        detonatorGem.setGemProperties()  // Sets gem properties from Gem class
        detonatorGem.name = "detonatorGem"
        let angle = random(min: CGFloat.pi * (1/4), max: CGFloat.pi * (3/8))
        let velocity = random(min: 100, max: 120)
        detonatorGem.setGemVelocity(velocity: velocity, angle: angle)
        let spawnLocation = CGPoint(x: size.width * 0.1, y: size.height * 0.15)
        detonatorGem.position = spawnLocation
        addChild(detonatorGem)
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
            
            self.run(gemExplosionSound)
            
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
    
    private func detonateGemSequence() {
        // Adds a detonating gem to the scene and makes it explode
        let detonatorGem = Gem(imageNamed: "rottenGem")
        let gravityFieldNode = SKFieldNode.radialGravityField()
        
        run(SKAction.sequence([
            SKAction.run({self.addDetonatorGem(detonatorGem: detonatorGem)}),
            SKAction.run({self.animateDetonatorGem(detonatorGem: detonatorGem)}),
            SKAction.wait(forDuration: 2.0),
            SKAction.run({self.detonateGem(detonatorGem: detonatorGem, gravityFieldNode: gravityFieldNode)}),
            SKAction.wait(forDuration: 0.25),
            SKAction.run({self.detonationCleanup(gravityFieldNode: gravityFieldNode)})
            ]))
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
        gemCollectorPosX = gemCollector.position.x
        addChild(gemCollector)
    }
    
    private func addGemSources() {
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
        blueAstronaut.physicsBody?.isDynamic = false // Change this to true to be amused
        blueAstronaut.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        addChild(redAstronaut)
        addChild(blueAstronaut)
    }
    
    private func onLeftGemSourceTouch() {
        if self.isPaused == false && timerSeconds != 0 { // Change second conditional to result of isTutorialRunning variable
            addGemLeft()
            run(gemCreatedSound)
        }
    }
    
    private func onRightGemSourceTouch() {
        if self.isPaused == false && timerSeconds != 0 { // Change second conditional to result of isTutorialRunning variable
            addGemRight()
            run(gemCreatedSound)
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
    
    var touchesToGems:[UITouch: SKSpriteNode] = [:] // Dictionary to map currently selected user touches to the gems they are dragging
    var selectedGems: Set<SKSpriteNode> = Set()
    var nodeDisplacements:[SKSpriteNode: CGVector] = [:] // Dictionary to map currently selected nodes to their displacements from the user's finger
    
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
