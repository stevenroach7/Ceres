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
    
    // Game scaling
    static let PauseMenu = ScaleFactor.init(width: 0.9, height: 0.3)
    
    // Menu scaling
    static let GameTitle = ScaleFactor.init(width: 0.95, height: 0.18)
    static let PlayButton = ScaleFactor.init(width: 0.35, height: 0.2)
    static let InstructionsButton = ScaleFactor.init(width: 0.8, height: 0.075)
    static let AboutButton = ScaleFactor.init(width: 0.4, height: 0.07)
    static let SettingsButton = ScaleFactor.init(width: 0.15, height: 0.085)
    static let Ship = ScaleFactor.init(width: 0.3, height: 0.15)
    
    
    
    
    
}


public struct ScaleFactor {
    let width: CGFloat
    let height: CGFloat
    
    public func getAbsoluteSize(screenSize: CGSize, nodeSize: CGSize) -> CGSize {
        // Takes a size and constants to shift the position by and returns the absolute position of the coordinate.
        return CGSize(width: self.width * (screenSize.width / nodeSize.width), height: self.height * (screenSize.height / nodeSize.height) )
    }
}
