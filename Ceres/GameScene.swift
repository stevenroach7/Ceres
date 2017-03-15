//
//  GameScene.swift
//  Ceres
//
//  Created by Steven Roach on 2/15/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, Alerts {
    
    var backButton = SKSpriteNode()
    let backButtonTex = SKTexture(imageNamed: "backLogo")
    
    var pauseButton = SKSpriteNode()
    let pauseButtonTex = SKTexture(imageNamed: "pause")
    
    var scoreLabel: SKLabelNode!
    var gemsCollected = 0 {
        didSet {
            scoreLabel.text = "Gems: \(gemsCollected)"
        }
    }
    
    var timerLabel: SKLabelNode!
    var timerSeconds = 120 {
        didSet {
            timerLabel.text = "Time: \(timerSeconds)"
        }
    }
    
    let gemCollector = SKSpriteNode(imageNamed: "collectorActive")
    let stagePlanet = SKSpriteNode(imageNamed: "planet")
    let gemSource = SKSpriteNode(imageNamed: "astronaut")
    var starfield:SKEmitterNode!
    
    var currSprite: SKNode! = nil
    
    override func didMove(to view: SKView) {
        // Called immediately after scene is presented.
       
        backgroundColor = SKColor.black // Set background color of scene.
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = CGPoint(x: 0, y: size.height)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -10
        
        backButton = SKSpriteNode(texture: backButtonTex)
        backButton.setScale(3/4)
        backButton.position = CGPoint(x: size.width/6, y: size.height - size.height/24) // TODO: Change how to calculate hieght, use constants
        addChild(backButton)
        
        pauseButton = SKSpriteNode(texture: pauseButtonTex)
        pauseButton.setScale(0.175)
        pauseButton.position = CGPoint(x: 9*size.width/10, y: size.height - size.height/24) // TODO: Change how to calculate hieght
        addChild(pauseButton)
        
        scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "Gems: 0"
        scoreLabel.fontSize = 13
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: size.width * (4/5), y: size.height - size.height/19)
        addChild(scoreLabel)
        
        timerLabel = SKLabelNode(fontNamed: "American Typewriter")
        timerLabel.text = "Time: \(timerSeconds)"
        timerLabel.fontSize = 15
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: size.width * (11/20), y: size.height - size.height/19)
        addChild(timerLabel)
        
        run(SKAction.repeatForever( // Serves as timer
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run(decrementTimer)
                ])
        ))
        
        stagePlanet.position = CGPoint(x: size.width * 0.5, y: size.height * 0.05)
        stagePlanet.setScale(0.55)
        stagePlanet.name = "stagePlanet"
        stagePlanet.zPosition  = -1
        let planetPath = createPlanetPath()
        stagePlanet.physicsBody = SKPhysicsBody(polygonFrom: planetPath)
        stagePlanet.physicsBody?.usesPreciseCollisionDetection = true
        stagePlanet.physicsBody?.isDynamic = false
        addChild(stagePlanet)
        
        gemCollector.position = CGPoint(x: size.width * 0.75, y: size.height * 0.075)
        gemCollector.setScale(0.2)
        gemCollector.name = "gemCollector"
        gemCollector.zPosition = 2
        gemCollector.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: gemCollector.size.width, height: gemCollector.size.height))
        gemCollector.physicsBody?.usesPreciseCollisionDetection = true
        gemCollector.physicsBody?.isDynamic = false
        //gemCollector.isUserInteractionEnabled = false
        addChild(gemCollector)
        
        gemSource.position = CGPoint(x: size.width * 0.25, y: size.height * 0.1)
        gemSource.setScale(0.175)
        gemSource.name = "gemSource"
        gemSource.zPosition = 3
//        let gemSourcePath = createGemSourcePath()
//        gemSource.physicsBody = SKPhysicsBody(polygonFrom: gemSourcePath)
//        gemSource.physicsBody?.usesPreciseCollisionDetection = true
//        gemSource.physicsBody?.isDynamic = false
        gemSource.isUserInteractionEnabled = false // Must be set to false in order to register touch events.
        
        addChild(gemSource)
        
        let backgroundMusic = SKAudioNode(fileNamed: "cosmos.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        // Create edge boundary around scene.
        createSceneContents()
        
        // Adjust gravity of scene
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.27) // Gravity on Ceres is 0.27 m/s²
        
//        let gravityFieldNode = SKFieldNode.radialGravityField()
//        gravityFieldNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        addChild(gravityFieldNode)
//
    }
    
    private func decrementTimer() {
        
        timerSeconds -= 1
        if (timerSeconds <= 0) {
            self.isPaused = true
            gameOverAlert(title: "Game Over", message: "Score is \(gemsCollected)")
            removeAllActions()
        }
    }
    
    private func createPlanetPath() -> CGPath {
        // Creates a path that is the shape of the stage planet.
        
        let offsetX = CGFloat(stagePlanet.frame.size.width * stagePlanet.anchorPoint.x)
        let offsetY = CGFloat(stagePlanet.frame.size.height * stagePlanet.anchorPoint.y)
        
        // TODO: Edit path to better approximate object
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 61 - offsetX, y: 6 - offsetY))
        path.addLine(to: CGPoint(x: 61 - offsetX, y: 43 - offsetY))
        path.addLine(to: CGPoint(x: 74 - offsetX, y: 45 - offsetY))
        path.addLine(to: CGPoint(x: 87 - offsetX, y: 48 - offsetY))
        path.addLine(to: CGPoint(x: 111 - offsetX, y: 59 - offsetY))
        path.addLine(to: CGPoint(x: 139 - offsetX, y: 64 - offsetY))
        path.addLine(to: CGPoint(x: 173 - offsetX, y: 78 - offsetY))
        path.addLine(to: CGPoint(x: 288 - offsetX, y: 74 - offsetY))
        path.addLine(to: CGPoint(x: 245 - offsetX, y: 76 - offsetY))
        path.addLine(to: CGPoint(x: 258 - offsetX, y: 78 - offsetY))
        path.addLine(to: CGPoint(x: 274 - offsetX, y: 75 - offsetY))
        path.addLine(to: CGPoint(x: 294 - offsetX, y: 75 - offsetY))
        path.addLine(to: CGPoint(x: 319 - offsetX, y: 74 - offsetY))
        path.addLine(to: CGPoint(x: 342 - offsetX, y: 72 - offsetY))
        path.addLine(to: CGPoint(x: 364 - offsetX, y: 69 - offsetY))
        path.addLine(to: CGPoint(x: 379 - offsetX, y: 67 - offsetY))
        path.addLine(to: CGPoint(x: 383 - offsetX, y: 66 - offsetY))
        path.addLine(to: CGPoint(x: 399 - offsetX, y: 67 - offsetY))
        path.addLine(to: CGPoint(x: 418 - offsetX, y: 62 - offsetY))
        path.addLine(to: CGPoint(x: 424 - offsetX, y: 57 - offsetY))
        path.addLine(to: CGPoint(x: 450 - offsetX, y: 48 - offsetY))
        path.addLine(to: CGPoint(x: 470 - offsetX, y: 43 - offsetY))
        path.addLine(to: CGPoint(x: 470 - offsetX, y: 7 - offsetY))
        path.closeSubpath();
        return path
    }
    
    private func createGemSourcePath() -> CGPath {
        // Creates a path in the shape of the astronaut
        
        let offsetX = CGFloat(gemSource.frame.size.width * gemSource.anchorPoint.x)
        let offsetY = CGFloat(gemSource.frame.size.height * gemSource.anchorPoint.y)
        
        let path = CGMutablePath()
        
        //Currently not very precise
        path.move(to: CGPoint(x: 130 - offsetX, y: 4 - offsetY))
        path.addLine(to: CGPoint(x: 158 - offsetX, y: 141 - offsetY))
        path.addLine(to: CGPoint(x: 133 - offsetX, y: 198 - offsetY))
        path.addLine(to: CGPoint(x: 114 - offsetX, y: 207 - offsetY))
        path.addLine(to: CGPoint(x: 114 - offsetX, y: 217 - offsetY))
        path.addLine(to: CGPoint(x: 110 - offsetX, y: 230 - offsetY))
        path.addLine(to: CGPoint(x: 103 - offsetX, y: 240 - offsetY))
        path.addLine(to: CGPoint(x: 90 - offsetX, y: 248 - offsetY))
        path.addLine(to: CGPoint(x: 71 - offsetX, y: 249 - offsetY))
        path.addLine(to: CGPoint(x: 59 - offsetX, y: 242 - offsetY))
        path.addLine(to: CGPoint(x: 49 - offsetX, y: 229 - offsetY))
        path.addLine(to: CGPoint(x: 46 - offsetX, y: 208 - offsetY))
        path.addLine(to: CGPoint(x: 27 - offsetX, y: 199 - offsetY))
        path.addLine(to: CGPoint(x: 2 - offsetX, y: 142 - offsetY))
        path.addLine(to: CGPoint(x: 28 - offsetX, y: 93 - offsetY))
        path.addLine(to: CGPoint(x: 29 - offsetX, y: 60 - offsetY))
        path.addLine(to: CGPoint(x: 31 - offsetX, y: 4 - offsetY))
        path.closeSubpath();
        return path
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
    
    private func onGemSourceTouch() {
        addGem()
    }
    
    var touchPoint: CGPoint = CGPoint();
    var touching: Bool = false;
    
    private func onGemTouch(touchedNode: SKNode, touchLocation: CGPoint) {
        currSprite = touchedNode //Set the current node touching
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
        
        let resumeAction = UIAlertAction(title: "Resume", style: UIAlertActionStyle.default)  { (action:UIAlertAction!) in
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
            pauseButton.texture = SKTexture(imageNamed:"play-1")
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
        let touchedNode = atPoint(touchLocation)
        
        if let name = touchedNode.name {
            
            switch name {
            case "gemSource":
                onGemSourceTouch()
            case "gem":
                onGemTouch(touchedNode: touchedNode, touchLocation: touchLocation)
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
            let dt:CGFloat = 1.0/60.0
            let distance = CGVector(dx: touchPoint.x - currSprite.position.x, dy: touchPoint.y - currSprite.position.y)
            let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
            currSprite.physicsBody!.velocity = velocity
        }
    }
    
    func createSceneContents() {
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
}
