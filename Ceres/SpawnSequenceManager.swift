//
//  SpawnSequenceManager.swift
//  Ceres
//
//  Created by Steven Roach on 4/22/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation
import SpriteKit


class SpawnSequenceManager { 
    
    private let spawnSequence1: GameScene.SpawnAction =
        .repeated(times: 5,
                  action: .sequence(actions: [.wait(time: 1), .spawnGemLeft, .wait(time: 1), .spawnGemRight]))
    
    private let spawnSequence2: GameScene.SpawnAction =
        .repeated(times: 8,
                  action: .sequence(actions: [.wait(time: 1), .spawnGemLeft, .wait(time: 0.25), .spawnGemRight]))
    
    private let spawnSequence3: GameScene.SpawnAction =
        .repeated(times: 7, action:
            .sequence(actions: [.wait(time: 1),
                                .spawnGemLeft,
                                .wait(time: 0.25),
                                .spawnGemLeft, .spawnDetonatorLeft,
                                .wait(time: 0.25),
                                .spawnGemLeft, .spawnGemRight]))
    
    private let spawnSequence4: GameScene.SpawnAction =
        .repeated(times: 2, action:
            .sequence(actions: [.wait(time: 2.47),
                                .spawnGemRight,
                                .wait(time: 0.01),
                                .spawnGemRight, .spawnDetonatorLeft,
                                .wait(time: 0.01),
                                .spawnGemRight,
                                .wait(time: 0.01),
                                .spawnGemRight, .spawnDetonatorLeft,
                                
                                .wait(time: 2.47),
                                .spawnGemLeft,
                                .wait(time: 0.01),
                                .spawnGemLeft,
                                .wait(time: 0.01),
                                .spawnGemRight, .spawnDetonatorLeft,
                                .wait(time: 0.01),
                                .spawnGemLeft,
                                ]))
    
    private let spawnSequenceBasicDetonators: GameScene.SpawnAction =
        .repeated(times: 2, action:
            .sequence(actions: [.wait(time: 2.47),
                                .spawnGemRight,
                                .wait(time: 0.01),
                                .spawnGemRight,
                                .wait(time: 0.01),
                                .spawnGemRight,
                                .wait(time: 0.01),
                                .spawnGemRight, .spawnDetonatorLeft,
                                
                                .wait(time: 2.47),
                                .spawnGemLeft,
                                .wait(time: 0.01),
                                .spawnGemLeft,
                                .wait(time: 0.01),
                                .spawnGemRight,
                                .wait(time: 0.01),
                                .spawnGemRight, .spawnDetonatorRight
                ]))
    
    private let spawnSequenceHard: GameScene.SpawnAction =
        .repeated(times: 10, action:
            .sequence(actions: [.wait(time: 0.75),
                                .spawnGemRight,
                                .wait(time: 0.01),
                                .spawnGemRight, .spawnGemLeft,
                                .wait(time: 0.01),
                                .spawnGemRight, .spawnDetonatorLeft,
                                
                                .wait(time: 0.21),
                                .spawnGemLeft,
                                .wait(time: 0.01),
                                .spawnGemLeft, .spawnGemRight, .spawnDetonatorLeft,
                                .wait(time: 0.01),
                                .spawnGemLeft,
                                ]))
    
    
    
    
    // Start making sequences after this line
    
    let basicSequences:[GameScene.SpawnAction]
    let easySequences:[GameScene.SpawnAction]
    let mediumSequences:[GameScene.SpawnAction]
    let hardSequences:[GameScene.SpawnAction]
//    let veryHardSequences:[GameScene.SpawnAction]
//    let impossibleSequences:[GameScene.SpawnAction]
    
    
    
    private let basicSequence0: GameScene.SpawnAction =
        .repeated(times: 4,
                  action: .sequence(actions: [.wait(time: 0.9), .spawnGemLeft, .wait(time: 0.9), .spawnGemRight]))
    
    private let basicSequence1: GameScene.SpawnAction =
        .repeated(times: 4,
                  action: .sequence(actions: [.wait(time: 0.9), .spawnGemRight, .wait(time: 0.9), .spawnGemLeft]))


    
    
    private let easySequence0: GameScene.SpawnAction =
        .repeated(times: 6,
                  action: .sequence(actions: [.wait(time: 1.1), .spawnGemLeft, .wait(time: 0.25), .spawnGemRight]))
    
    private let easySequence1: GameScene.SpawnAction =
        .repeated(times: 2,
                  action: .sequence(actions: [.wait(time: 1.2), .spawnGemRight,
                                              .wait(time: 0.5), .spawnGemLeft,
                                              .wait(time: 0.5), .spawnGemRight,
                                              .wait(time: 1.2), .spawnGemLeft,
                                              .wait(time: 0.5), .spawnGemRight,
                                              .wait(time: 0.5), .spawnGemLeft]))
    
    private let easySequence2: GameScene.SpawnAction =
        .repeated(times: 6,
                  action: .sequence(actions: [.wait(time: 1.2), .spawnGemRight, .spawnGemLeft]))
    
    private let easySequence3: GameScene.SpawnAction =
        .repeated(times: 2,
                  action: .sequence(actions: [.repeated(times: 3, action: .sequence(actions: [.wait(time: 0.7), .spawnGemRight])),
                                              .repeated(times: 3, action: .sequence(actions: [.wait(time: 0.7), .spawnGemLeft]))]))
    
    
    
    
    private let mediumSequence0: GameScene.SpawnAction =
        .repeated(times: 5, action:
            .sequence(actions: [.wait(time: 1),
                                .spawnGemLeft,
                                .wait(time: 0.5),
                                .spawnGemLeft, .spawnDetonatorLeft,
                                .wait(time: 0.5),
                                .spawnGemLeft, .spawnGemRight]))
    
    private let mediumSequence1: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 1.5),
                                .spawnGemRight, .spawnGemRight, .spawnGemLeft, .spawnGemLeft, .spawnDetonatorLeft,
                                
                                .wait(time: 1.5),
                                .spawnGemLeft, .spawnGemLeft, .spawnGemRight, .spawnGemRight, .spawnDetonatorRight
                ]))
    
    private let mediumSequence2: GameScene.SpawnAction =
        .repeated(times: 2, action:
            .sequence(actions: [.wait(time: 1),
                            .spawnGemLeft, .spawnDetonatorRight,
                            
                            .wait(time: 0.75),
                            .spawnGemRight, .spawnDetonatorLeft,
                            
                            .wait(time: 0.75),
                            .spawnDetonatorRight, .spawnDetonatorLeft,
                            
                            .wait(time: 0.5),
                            .spawnGemLeft, .spawnGemRight, .spawnGemLeft, .spawnGemRight
                ]))
    
    
    private let mediumSequence3: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 1),
                            .spawnGemLeft,
                            .wait(time: 0.15),
                            .spawnGemRight,
                            .wait(time: 0.15),
                            .spawnGemLeft,
                            .wait(time: 0.15),
                            .spawnGemRight,
                            .wait(time: 0.35),
                            .spawnGemLeft, .spawnGemRight, .spawnDetonatorLeft, .spawnDetonatorRight,
                            .wait(time: 0.15),
                            .spawnGemLeft, .spawnGemRight
                ]))
    
    private let mediumSequence4: GameScene.SpawnAction =
        .repeated(times: 4, action:
            .sequence(actions: [.wait(time: 0.3),
                            .spawnDetonatorRight,
                            .wait(time: 0.40),
                            .spawnGemLeft, .spawnGemLeft,
                            .wait(time: 0.40),
                            .spawnGemLeft, .spawnGemRight,
                            .wait(time: 0.25),
                            .spawnDetonatorLeft
            ]))
    
    private let mediumSequence5: GameScene.SpawnAction =
        .repeated(times: 5, action:
            .sequence(actions: [.wait(time: 0.6),
                            .spawnGemLeft, .spawnGemRight,
                            .wait(time: 0.4),
                            .spawnGemRight,
                            .wait(time: 0.15),
                            .spawnGemLeft,
                            .wait(time: 0.15),
                            .spawnDetonatorRight,
                            .wait(time: 0.15),
                            .spawnGemLeft,
                            .wait(time: 0.4),
                            .spawnGemLeft, .spawnGemRight
            ]))
    
    private let mediumSequence6: GameScene.SpawnAction =
        .repeated(times: 5, action:
            .sequence(actions: [.wait(time: 0.5),
                                .spawnGemLeft, .spawnGemRight,
                                .wait(time: 0.5),
                                .spawnGemLeft,
                                .wait(time: 0.1),
                                .spawnGemRight,
                                .wait(time: 0.1),
                                .spawnGemLeft, .spawnGemRight, .spawnDetonatorLeft
            ]))
    
    private let mediumSequence7: GameScene.SpawnAction =
        .repeated(times: 4, action:
            .sequence(actions: [.wait(time: 1),
                                .spawnGemLeft, .spawnGemRight,
                                .wait(time: 0.6),
                                .spawnGemRight, .spawnGemLeft,
                                .wait(time: 0.35),
                                .spawnDetonatorLeft, .spawnGemRight,
                                .wait(time: 0.15),
                                .spawnGemRight, .spawnGemLeft
            ]))


    
    
    private let hardSequence0: GameScene.SpawnAction =
        .repeated(times: 4, action:
            .sequence(actions: [.wait(time: 1.5),
                                .spawnGemRight,
                                .wait(time: 0.08),
                                .spawnGemLeft, .spawnGemRight,
                                .wait(time: 0.1),
                                .spawnDetonatorLeft, .spawnGemRight,
                                .wait(time: 0.3),
                                .spawnGemLeft, .spawnDetonatorRight,
                                ]))
    
    private let hardSequence1: GameScene.SpawnAction =
        .repeated(times: 4, action:
            .sequence(actions: [.wait(time: 0.5),
                                .spawnDetonatorLeft,
                                .wait(time: 0.3),
                                .spawnDetonatorRight, .spawnGemLeft,
                                .wait(time: 0.5),
                                .spawnDetonatorLeft, .spawnDetonatorRight,
                                .wait(time: 0.3),
                                .spawnDetonatorLeft,
                                ]))
    
    private let hardSequence2: GameScene.SpawnAction =
        .repeated(times: 4, action:
            .sequence(actions: [.repeated(times: 2, action:
                                    .sequence(actions: [.wait(time: 0.2), .spawnGemLeft, .wait(time: 0.2), .spawnGemRight])),
                               .spawnDetonatorLeft,
                               .repeated(times: 2, action:
                                    .sequence(actions: [.wait(time: 0.2), .spawnGemLeft, .wait(time: 0.2), .spawnGemRight])),
                               .spawnDetonatorRight
                      ]))
    
    
    
    
    
    
    var index = 0
    
    public init() {
        
        basicSequences = [basicSequence0, basicSequence1]
        easySequences = [easySequence0, easySequence1, easySequence2, easySequence3]
        mediumSequences = [mediumSequence0, mediumSequence1, mediumSequence2, mediumSequence3, mediumSequence4, mediumSequence5, mediumSequence6,mediumSequence7]
        hardSequences = [hardSequence0, hardSequence1, hardSequence2]
//        veryHardSequences = []
//        impossibleSequences = []
    }
    
    public func getSpawnSequence(time: Int) -> GameScene.SpawnAction {
        // Gem spawning routine
        
        if index < hardSequences.count {
            let sequence = hardSequences[index]
            index += 1
            return sequence
        } else {
            return spawnSequence1
        }
    }
        
}


