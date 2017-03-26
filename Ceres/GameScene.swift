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
    
    var backButton = SKSpriteNode(imageNamed: "back")
    var pauseButton = SKSpriteNode(imageNamed: "pause")
    let gemSource = SKSpriteNode(imageNamed: "hammerInactive")
    let astronaut = SKSpriteNode(imageNamed: "astronautActive")
    var starfield:SKEmitterNode!
    
    var scoreLabel: SKLabelNode!
    var gemsCollected = 0 {
        didSet {
            scoreLabel.text = "Gems: \(gemsCollected)"
        }
    }
    
    var timerLabel: SKLabelNode!
    var timerSeconds = 10 {
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
       
        backgroundColor = SKColor.black // Set background color of scene.
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.zPosition = -10
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        
        backButton.setScale(3/4)
        backButton.position = CGPoint(x: size.width/6, y: size.height - size.height/24) // TODO: Change how to calculate hieght, use constants
        addChild(backButton)
        
        pauseButton.setScale(0.175)
        pauseButton.position = CGPoint(x: 9*size.width/10, y: size.height - size.height/24) // TODO: Change how to calculate hieght
        addChild(pauseButton)
        
        setScoreLabel()
        setTimerLabel()
        
        run(SKAction.repeatForever( // Serves as timer
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run(decrementTimer)
                ])
        ))
        
        addStagePlanet()
        addGemCollector()
        addGemSource()
        addAstronaut()
        
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
        //removes gem from game scene and increments number of gems collected
        print("Collected")
        gemsCollected = gemsCollected + 1
        animateCollector(collector: collector)
        gem.removeFromParent()
    }
    
    private func gemOffScreen(gem: SKSpriteNode) {
        //removes gems from game scene when they fly off screen
        print("Lost Gem")
        gem.removeFromParent()
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
        scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "Gems: 0"
        scoreLabel.fontSize = 13
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: size.width * (4/5), y: size.height - size.height/19)
        addChild(scoreLabel)
    }
    
    private func setTimerLabel() {
        timerLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        timerLabel.text = "Time: \(timerSeconds)"
        timerLabel.fontSize = 13
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: size.width * (23/40), y: size.height - size.height/19)
        addChild(timerLabel)
    }
    
    private func decrementTimer() {
        timerSeconds -= 1
        if (timerSeconds <= 0) {
            self.isPaused = true
            if view != nil {
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene:SKScene = GameOverScreen(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }
            //gameOverAlert(title: "Game Over", message: "Score is \(gemsCollected)")
            removeAllActions()
        }
    }
    
    // TODO: The random methods are used in multiple classes. We should maybe put them in their own class or structure.
    // Helper methods to generate random numbers.
    private static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    private func addGem() {
        // Creates a gem sprite node and adds it to a random position on the upper half of the screen.
        let gem = Gem(imageNamed: "gemShape1")
        gem.setGemProperties()
        gem.position = CGPoint(x: size.width / 2, y: size.height / 10)
        addChild(gem)
    }
    
    private func addStagePlanet() {
        let stagePlanet = StagePlanet(imageNamed: "planet")
        stagePlanet.setStagePlanetProperties()
        stagePlanet.position = CGPoint(x: size.width * 0.5, y: size.height * 0.05)
        addChild(stagePlanet)
    }
    
    private func addGemCollector() {
        let gemCollector = GemCollector(imageNamed: "collectorInactive")
        gemCollector.setGemCollectorProperties()
        gemCollector.position = CGPoint(x: size.width * 0.75, y: size.height * 0.075)
        addChild(gemCollector)
    }
    
    private func addGemSource() {
        let gemSource = GemSource(imageNamed: "hammerInactive")
        gemSource.setGemSourceProperties()
        gemSource.position = CGPoint(x: size.width * 0.25, y: size.height * 0.1 - 20)
        addChild(gemSource)
    }
    
    private func addAstronaut() {
        astronaut.position = CGPoint(x: size.width * 0.25, y: size.height * 0.1)
        astronaut.setScale(0.175)
        astronaut.name = "astronaut"
        astronaut.zPosition = 2
        astronaut.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        addChild(astronaut)
    }
    
    private func onGemSourceTouch(source: SKSpriteNode) {
        addGem()
        animateHammer(source: source)
    }

    var touchPoint: CGPoint = CGPoint();
    var touching: Bool = false;
    
    func onGemTouch(touchedNode: SKNode, touchLocation: CGPoint) {
        currSprite = touchedNode //Set the current node touched
        touchPoint = touchLocation
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
        
        let resumeAction = UIAlertAction(title: "Resume Game", style: UIAlertActionStyle.default)  { (action:UIAlertAction!) in
            if !wasPaused { // Only play game if game wasn't paused when back button was touched
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
        // Method to handle touch events. Senses when user touches down.
        
        // Choose first touch
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation) as? SKSpriteNode
        
        if let name = touchedNode?.name {
            
            switch name {
            case "gemSource":
                onGemSourceTouch(source: touchedNode!)
            case "gem":
                onGemTouch(touchedNode: touchedNode!, touchLocation: touchLocation)
            default: break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
        switch touchedNode {
        case backButton:
            onBackButtonTouch()
        case pauseButton:
            onPauseButtonTouch()
        default: break
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if touching {
            let dt:CGFloat = 1.0/60.0 //determines drag and flick speed
            let distance = CGVector(dx: touchPoint.x - currSprite.position.x, dy: touchPoint.y - currSprite.position.y)
            let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
            currSprite.physicsBody!.velocity = velocity
        }
    }
}
