//
//  Scales.swift
//  Ceres
//
//  Created by Sean Cheng on 5/2/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit


// This file defines structures used for scaling.


public struct RelativeScales {
    // Holds relative factors to be used for scaling
    // 16/9 : height/width proportions = 1.77
    
    // Game scaling
    static let GameDimmer = ScaleFactor.init(width: 1.0, height: 1.0)
    static let PauseMenu = ScaleFactor.init(width: 0.9, height: 0.275)
    
    // Menu scaling
    static let GameTitle = ScaleFactor.init(width: 0.8, height: 0.13)
    static let PlayButton = ScaleFactor.init(width: 0.3, height: 0.17)
    static let InstructionsButton = ScaleFactor.init(width: 0.7, height: 0.055)
    static let AboutButton = ScaleFactor.init(width: 0.3, height: 0.055)
    static let SettingsButton = ScaleFactor.init(width: 0.12, height: 0.0675)
    static let LeaderBoardButton = ScaleFactor.init(width: 0.12, height: 0.0675)
    static let Ship = ScaleFactor.init(width: 0.3, height: 0.15)
    
    // Instructions scaling
    static let BackButton = ScaleFactor.init(width: 0.12, height: 0.065)
    static let InstructionsText = ScaleFactor.init(width: 0.8, height: 0.65)
    
    // About scaling
    static let AboutText = ScaleFactor.init(width: 0.9, height: 0.75)
    static let AboutLogo = ScaleFactor.init(width: 0.95, height: 0.5)
    
    
    
    
    
}


public struct ScaleFactor {
    let width: CGFloat
    let height: CGFloat
    
    public func getAbsoluteSize(screenSize: CGSize, nodeSize: CGSize) -> CGSize {
        // Takes a size and constants to shift the position by and returns the absolute position of the coordinate.
        return CGSize(width: self.width * (screenSize.width / nodeSize.width), height: self.height * (screenSize.height / nodeSize.height) )
    }
}
