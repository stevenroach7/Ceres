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
    
    
    
    
    
}


public struct ScaleFactor {
    let width: CGFloat
    let height: CGFloat
    
    public func getAbsoluteSize(screenSize: CGSize, nodeSize: CGSize) -> CGSize {
        // Takes a size and constants to shift the position by and returns the absolute position of the coordinate.
        return CGSize(width: self.width * (screenSize.width / nodeSize.width), height: self.height * (screenSize.height / nodeSize.height) )
    }
}
