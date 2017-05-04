//
//  AnimationManager.swift
//  Ceres
//
//  Created by Steven Roach on 5/3/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit

class AnimationManager {     // Eventually, all animation methods should be moved to this class.
    
    public var collectorAtlas = SKTextureAtlas()
    public var collectorFrames = [SKTexture]()
    public var hammerAtlas = SKTextureAtlas()
    public var hammerFrames = [SKTexture]()
    
    public func addAtlases() {
        collectorAtlas = SKTextureAtlas(named: "collectorImages")
        collectorFrames.append(SKTexture(imageNamed: "collectorActive.png"))
        collectorFrames.append(SKTexture(imageNamed: "collectorInactive.png"))
        hammerAtlas = SKTextureAtlas(named: "hammerImages")
        hammerFrames.append(SKTexture(imageNamed: "hammerActive.png"))
        hammerFrames.append(SKTexture(imageNamed: "hammerInactive.png"))
    }
}

