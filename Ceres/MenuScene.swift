//
//  MenuScene.swift
//  Ceres
//
//  Created by Sean Cheng on 2/20/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene, UIGestureRecognizerDelegate {

    let gameTitle = SKSpriteNode(imageNamed: "expeditionCeresTitle")
    var ship = SKSpriteNode(imageNamed: "stellaNovaShip")
    var starfield:SKEmitterNode!
    var leftExhaust:SKEmitterNode!
    var rightExhaust:SKEmitterNode!
    
    var playButton = SKSpriteNode(imageNamed: "play")
    var instructionsButton = SKSpriteNode(imageNamed: "instructions")
    var aboutButton = SKSpriteNode(imageNamed: "about")
    var settingsButton = SKSpriteNode(imageNamed: "settings")
    var leaderBoardButton = SKSpriteNode(imageNamed: "leaderBoard")
    var audioManager = AudioManager()
    
    
    override func didMove(to view: SKView) {
        // Positions labels and nodes on screen
        
        self.name = "menu"
        addChild(audioManager)
        
        backgroundColor = SKColor.black
        
        let gameTitleSize = RelativeScales.GameTitle.getAbsoluteSize(screenSize: size, nodeSize: gameTitle.size)
        gameTitle.xScale = gameTitleSize.width
        gameTitle.yScale = gameTitleSize.height
        gameTitle.position = RelativePositions.Title.getAbsolutePosition(size: size)
        addChild(gameTitle)
        
        let playButtonSize = RelativeScales.PlayButton.getAbsoluteSize(screenSize: size, nodeSize: playButton.size)
        playButton.xScale = playButtonSize.width
        playButton.yScale = playButtonSize.height
        playButton.position = RelativePositions.PlayButton.getAbsolutePosition(size: size)
        addChild(playButton)
        
        let instructionsButtonSize = RelativeScales.InstructionsButton.getAbsoluteSize(screenSize: size, nodeSize: instructionsButton.size)
        instructionsButton.xScale = instructionsButtonSize.width
        instructionsButton.yScale = instructionsButtonSize.height
        instructionsButton.position = RelativePositions.InstructionsButton.getAbsolutePosition(size: size)
        addChild(instructionsButton)
        
        let aboutButtonSize = RelativeScales.AboutButton.getAbsoluteSize(screenSize: size, nodeSize: aboutButton.size)
        aboutButton.xScale = aboutButtonSize.width
        aboutButton.yScale = aboutButtonSize.height
        aboutButton.position = RelativePositions.AboutButton.getAbsolutePosition(size: size)
        addChild(aboutButton)
        
        let settingsButtonSize = RelativeScales.SettingsButton.getAbsoluteSize(screenSize: size, nodeSize: settingsButton.size)
        settingsButton.xScale = settingsButtonSize.width
        settingsButton.yScale = settingsButtonSize.height
        settingsButton.position = RelativePositions.SettingsButton.getAbsolutePosition(size: size)
        addChild(settingsButton)
        
        let leaderBoardButtonSize = RelativeScales.LeaderBoardButton.getAbsoluteSize(screenSize: size, nodeSize: leaderBoardButton.size)
        leaderBoardButton.xScale = leaderBoardButtonSize.width
        leaderBoardButton.yScale = leaderBoardButtonSize.height
        leaderBoardButton.position = RelativePositions.LeaderBoardButton.getAbsolutePosition(size: size)
        addChild(leaderBoardButton)
        
        starfield = SKEmitterNode(fileNamed: "starShower")
        starfield.position = RelativePositions.Starfield.getAbsolutePosition(size: size)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -2
        
        leftExhaust = SKEmitterNode(fileNamed: "shipExhaust")
        leftExhaust.position = RelativePositions.LeftExhaust.getAbsolutePosition(size: size)
        self.addChild(leftExhaust)
        leftExhaust.zPosition = -1
        
        rightExhaust = SKEmitterNode(fileNamed: "shipExhaust")
        rightExhaust.position = RelativePositions.RightExhaust.getAbsolutePosition(size: size)
        self.addChild(rightExhaust)
        rightExhaust.zPosition = -1
        
        let shipSize = RelativeScales.Ship.getAbsoluteSize(screenSize: size, nodeSize: ship.size)
        ship.xScale = shipSize.width
        ship.yScale = shipSize.height
        ship.position = RelativePositions.Ship.getAbsolutePosition(size:size)
        addChild(ship)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.easterEggAccelerate(gestureRecognizer:)))
        lpgr.minimumPressDuration = 1.0
        lpgr.allowableMovement = 50 //Need to fine tune this value
        lpgr.delaysTouchesBegan = true
        lpgr.cancelsTouchesInView = false
        lpgr.delegate = self
        self.view?.addGestureRecognizer(lpgr)
        
    }
    
    
    override func willMove(from view: SKView) {
        // Removes gestures from the view before transistioning
        
        if view.gestureRecognizers != nil {
            for gesture in view.gestureRecognizers! {
                view.removeGestureRecognizer(gesture)
            }
        }
    }
    
    
    var touchingShip: Bool = false
    
    @objc private func easterEggAccelerate(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == .began) {
            var pos = gestureRecognizer.location(in: self.view)
            pos.y = size.height - pos.y // Converting between view and scene coordinate systems
            let touchedNode = self.atPoint(pos)
            if (touchedNode == ship){
                touchingShip = true
                leftExhaust.particleScale = leftExhaust.particleScale * 3
                rightExhaust.particleScale = rightExhaust.particleScale * 3
                starfield.resetSimulation() // Comment this out and see what you like better
                starfield.particleBirthRate *= 5
                starfield.particleSpeed *= 10
            }
        }
        else if (touchingShip && gestureRecognizer.state == .ended) {
            touchingShip = false
            leftExhaust.particleScale = leftExhaust.particleScale / 3
            rightExhaust.particleScale = rightExhaust.particleScale / 3
            starfield.particleBirthRate /= 5
            starfield.particleSpeed /= 10
        }
    }
    
    private func easterEggChangeColor() {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        let newColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
        rightExhaust.particleColorSequence = nil
        rightExhaust.particleColorBlendFactor = 1.0
        rightExhaust.particleColor = newColor
        
        leftExhaust.particleColorSequence = nil
        leftExhaust.particleColorBlendFactor = 1.0
        leftExhaust.particleColor = newColor
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Looks for a touch
        if let touch = touches.first{
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            // Transitions to game screen if play button is touched
            if node == playButton {
                if view != nil {
                    audioManager.play(sound: .button2Sound)
                    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                    
                }
            }
            
            // Transitions to settings screen if settings button is touched
            else if node == settingsButton {
                if view != nil {
                    audioManager.play(sound: .button1Sound)
                    let transition:SKTransition = SKTransition.fade(withDuration: 0.5)
                    let scene:SKScene = SettingsScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
                
            // Transitions to leader board screen if leader board button is touched
            else if node == leaderBoardButton {
                if view != nil {
                    audioManager.play(sound: .button1Sound)
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = LeaderBoardScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            
            // Transitions to instructions screen if instructions button is touched
            else if node == instructionsButton {
                if view != nil {
                    audioManager.play(sound: .screenTransitionSound)
                    let transition:SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    let scene:SKScene = InstructionsScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            
            // Transitions to about screen if about button is touched
            else if node == aboutButton {
                audioManager.play(sound: .screenTransitionSound)
                let transition:SKTransition = SKTransition.flipVertical(withDuration: 1)
                let scene:SKScene = AboutScene(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }
            
            else if node == ship {
                easterEggChangeColor()
            }
        }
    }
}
