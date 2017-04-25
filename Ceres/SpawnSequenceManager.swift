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
    
    private let pauseSequence: GameScene.SpawnAction = .wait(time: 3.0)
    
    
    
    
    // Start making sequences after this line
    
    let basicSequences:[GameScene.SpawnAction]
    let easySequences:[GameScene.SpawnAction]
    let mediumSequences:[GameScene.SpawnAction]
    let hardSequences:[GameScene.SpawnAction]
//    let veryHardSequences:[GameScene.SpawnAction]
//    let impossibleSequences:[GameScene.SpawnAction]
    let tempSequences:[GameScene.SpawnAction]
    
    
    
    private let basicSequence0: GameScene.SpawnAction =
        .repeated(times: 4,
                  action: .sequence(actions: [.wait(time: 0.9), .spawnGemLeft, .wait(time: 0.9), .spawnGemRight]))
    
    private let basicSequence1: GameScene.SpawnAction =
        .repeated(times: 4,
                  action: .sequence(actions: [.wait(time: 0.9), .spawnGemRight, .wait(time: 0.9), .spawnGemLeft]))


    
    
    private let easySequence0: GameScene.SpawnAction =
        .repeated(times: 6,
                  action: .sequence(actions: [.wait(time: 0.8), .spawnGemLeft, .wait(time: 0.25), .spawnGemRight]))
    
    private let easySequence1: GameScene.SpawnAction =
        .repeated(times: 2,
                  action: .sequence(actions: [.wait(time: 1.0), .spawnGemRight,
                                              .wait(time: 0.5), .spawnGemLeft,
                                              .wait(time: 0.5), .spawnGemRight,
                                              .wait(time: 1.0), .spawnGemLeft,
                                              .wait(time: 0.5), .spawnGemRight,
                                              .wait(time: 0.5), .spawnGemLeft]))
    
    private let easySequence2: GameScene.SpawnAction =
        .repeated(times: 6,
                  action: .sequence(actions: [.wait(time: 0.9), .spawnGemRight, .spawnGemLeft]))
    
    private let easySequence3: GameScene.SpawnAction =
        .repeated(times: 2,
                  action: .sequence(actions: [.repeated(times: 3, action: .sequence(actions: [.wait(time: 0.7), .spawnGemRight])),
                                              .repeated(times: 3, action: .sequence(actions: [.wait(time: 0.7), .spawnGemLeft]))]))
    
    
    
    
    private let mediumSequence0: GameScene.SpawnAction =
        .repeated(times: 4, action:
            .sequence(actions: [.wait(time: 0.6),
                                .spawnGemLeft,
                                .wait(time: 0.35),
                                .spawnDetonatorRight,
                                .wait(time: 0.6),
                                .spawnGemLeft, .spawnGemRight
                ]))
    
    private let mediumSequence1: GameScene.SpawnAction =
        .repeated(times: 2, action:
            .sequence(actions: [.wait(time: 2),
                                .spawnGemRight, .spawnGemRight, .spawnGemLeft, .spawnDetonatorLeft,
                                
                                .wait(time: 2),
                                .spawnGemLeft, .spawnGemLeft, .spawnGemRight, .spawnDetonatorRight
                ]))
    
    private let mediumSequence2: GameScene.SpawnAction =
        .repeated(times: 2, action:
            .sequence(actions: [.wait(time: 1),
                            .spawnGemLeft, .spawnGemRight,
                            
                            .wait(time: 0.8),
                            .spawnGemRight, .spawnDetonatorLeft,
                            
                            .wait(time: 0.5),
                            .spawnGemLeft,
                            
                            .wait(time: 1),
                            .spawnGemLeft, .spawnGemRight, .spawnGemLeft
                ]))
    
    
    private let mediumSequence3: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 1.0),
                            .spawnGemLeft,
                            .wait(time: 0.60),
                            .spawnGemRight, .spawnDetonatorLeft,
                            .wait(time: 0.60),
                            .spawnGemLeft, .spawnDetonatorRight,
                            .wait(time: 0.50),
                            .spawnGemLeft, .spawnGemRight,
                            .wait(time: 0.35),
                            .spawnGemLeft, .spawnGemRight
                ]))
    
    private let mediumSequence4: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 0.75),
                            .spawnGemLeft, .spawnGemLeft,
                            .wait(time: 0.4),
                            .spawnDetonatorRight,
                            .wait(time: 0.75),
                            .spawnGemLeft, .spawnGemRight
            ]))
    
    private let mediumSequence5: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 0.6),
                            .spawnGemLeft, .spawnGemRight,
                            .wait(time: 0.35),
                            .spawnDetonatorRight,
                            .wait(time: 0.35),
                            .spawnGemLeft,
                            .wait(time: 0.50),
                            .spawnGemLeft, .spawnGemRight,
                            .wait(time: 0.35),
                            .spawnDetonatorLeft
            ]))
    
    private let mediumSequence6: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 0.55),
                                .spawnGemLeft, .spawnGemRight,
                                .wait(time: 0.55),
                                .spawnGemLeft,
                                .wait(time: 0.55),
                                .spawnGemRight,
                                .wait(time: 0.55),
                                .spawnGemLeft, .spawnGemRight, .spawnDetonatorLeft
            ]))
    
    private let mediumSequence7: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 0.8),
                                .spawnGemLeft, .spawnGemRight,
                                .wait(time: 0.65),
                                .spawnGemLeft,
                                .wait(time: 0.45),
                                .spawnDetonatorLeft, .spawnGemRight,
                                .wait(time: 0.20),
                                .spawnGemRight
            ]))

    
    
    private let hardSequence0: GameScene.SpawnAction =
        .repeated(times: 4, action:
            .sequence(actions: [.wait(time: 1.0),
                                .spawnGemRight, .spawnDetonatorLeft,
                                .wait(time: 0.4),
                                .spawnGemLeft, .spawnGemRight,
                                .wait(time: 0.3),
                                .spawnDetonatorLeft, .spawnGemRight, .spawnDetonatorRight,
                                .wait(time: 0.3),
                                .spawnGemLeft, .spawnDetonatorRight
                                ]))
    
    private let hardSequence1: GameScene.SpawnAction =
        .repeated(times: 6, action:
            .sequence(actions: [.wait(time: 0.4),
                                .spawnDetonatorLeft,
                                .wait(time: 0.2),
                                .spawnDetonatorRight, .spawnGemLeft, .spawnDetonatorLeft,
                                .wait(time: 0.5),
                                .spawnDetonatorLeft, .spawnDetonatorRight,
                                .wait(time: 0.3),
                                .spawnDetonatorLeft,
                                ]))
    
    private let hardSequence2: GameScene.SpawnAction =
        .repeated(times: 4, action:
            .sequence(actions: [.wait(time: 1.5), .spawnGemLeft, .spawnGemRight,
                       .wait(time: 0.2), .spawnGemRight, .spawnDetonatorLeft,
                       .wait(time: 0.2), .spawnGemLeft,.spawnDetonatorRight,
                      ]))
    
    private let hardSequence3: GameScene.SpawnAction =
        .repeated(times: 7, action:
            .sequence(actions: [.wait(time: 0.4), .spawnGemLeft, .wait(time: 0.2), .spawnDetonatorLeft,
                                .wait(time: 0.4), .spawnGemRight, .spawnDetonatorRight, .wait(time: 0.2), .spawnGemLeft, .spawnDetonatorRight,
                                .wait(time: 0.4), .spawnGemRight, .wait(time: 0.2), .spawnDetonatorRight,
                                ]))
    
    private let hardSequence4: GameScene.SpawnAction =
            .sequence(actions: [.repeated(times: 6, action:
                                    .sequence(actions: [.wait(time: 0.25), .spawnDetonatorRight, .wait(time: 0.25), .spawnDetonatorRight])),
                                .repeated(times: 4, action:
                                    .sequence(actions: [.wait(time: 0.25), .spawnGemRight, .wait(time: 0.45), .spawnGemRight, .spawnDetonatorLeft])),
                                .repeated(times: 4, action:
                                    .sequence(actions: [.wait(time: 0.25), .spawnDetonatorLeft, .wait(time: 0.25), .spawnDetonatorLeft])),
                                .repeated(times: 4, action:
                                    .sequence(actions: [.wait(time: 0.25), .spawnDetonatorLeft, .spawnGemRight,
                                                        .wait(time: 0.25), .spawnGemLeft, .spawnGemRight,
                                                        .wait(time: 0.15), .spawnGemLeft, .spawnDetonatorRight]))
                                ])
    
    private let hardSequence5: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 2.0),
                                .repeated(times: 5, action:
                                    .sequence(actions: [.wait(time: 0.4), .spawnDetonatorRight, .spawnGemLeft, .wait(time: 0.4), .spawnGemLeft, .spawnGemRight, .spawnDetonatorLeft]))
                                ]))
    
    private let hardSequence6: GameScene.SpawnAction =
        .repeated(times: 2, action:
            .sequence(actions: [.wait(time: 0.4),
                                .repeated(times: 2, action:
                                    .sequence(actions: [.wait(time: 0.3), .spawnGemLeft, .wait(time: 0.2), .spawnGemRight])),
                                .wait(time: 0.4),
                                .repeated(times: 3, action:
                                    .sequence(actions: [.wait(time: 0.3), .spawnGemLeft, .spawnDetonatorRight, .wait(time: 0.2), .spawnDetonatorLeft, .spawnGemRight])),
                                .wait(time: 0.4),
                                .repeated(times: 4, action:
                                    .sequence(actions: [.wait(time: 0.5), .spawnDetonatorLeft, .spawnDetonatorRight, .wait(time: 0.2), .spawnGemRight, .spawnDetonatorLeft]))
                                ]))
    
    private let hardSequence7: GameScene.SpawnAction =
        .repeated(times: 2, action:
            .sequence(actions: [.wait(time: 0.4),
                .repeated(times: 2, action:
                    .sequence(actions: [.wait(time: 0.2), .spawnGemRight,
                                        .wait(time: 0.2), .spawnDetonatorRight,
                                        .wait(time: 0.2), .spawnGemRight,
                                        .wait(time: 0.5), .spawnGemLeft,
                                        .wait(time: 0.2), .spawnDetonatorLeft,
                                        .wait(time: 0.2), .spawnGemLeft])),
                .repeated(times: 4, action:
                    .sequence(actions: [.wait(time: 0.25), .spawnDetonatorLeft,
                                        .wait(time: 0.25), .spawnGemRight,
                                        .wait(time: 0.15), .spawnGemLeft, .spawnDetonatorRight]))
            ]))
    

    
    var index = 0
    
    public init() {
        
        basicSequences = [basicSequence0, basicSequence1]
        easySequences = [easySequence0, easySequence1, easySequence2, easySequence3]
        mediumSequences = [mediumSequence0, mediumSequence1, mediumSequence2, mediumSequence3, mediumSequence4, mediumSequence5,  mediumSequence6, mediumSequence7]
        hardSequences = [hardSequence0, hardSequence1, hardSequence2, hardSequence3, hardSequence4, hardSequence5, hardSequence6, hardSequence7]
//        veryHardSequences = []
//        impossibleSequences = []
        tempSequences = [basicSequence0, easySequence0, easySequence1, mediumSequence0, mediumSequence1, mediumSequence5, hardSequence0, hardSequence1, hardSequence2, hardSequence3, hardSequence4, hardSequence5, hardSequence6]
        
    }
    
    public func getSpawnSequence(time: Int) -> GameScene.SpawnAction {
        // Gem spawning routine
//        let sequences = mediumSequences
//        let sequences = hardSequences
//        let sequences = tempSequences
        
//        if index < sequences.count {
//            let sequence = sequences[index]
//            index += 1
//            return sequence
//        } else {
//            return spawnSequenceHard
//        }
        
        if time <= 0 {
            return basicSequences[Utility.random(min: 0, max: basicSequences.count - 1)]
        } else if time <= 20 {
            return easySequences[Utility.random(min: 0, max: basicSequences.count - 1)]
        } else if time <= 40 {
            return mediumSequences[Utility.random(min: 0, max: basicSequences.count - 1)]
        } else if time <= 70 {
            return hardSequences[Utility.random(min: 0, max: basicSequences.count - 1)]
        } else if time <= 120 {
            return hardSequences[Utility.random(min: 0, max: basicSequences.count - 1)] // TODO: Change to veryHard when sequences are created.
        }
        return spawnSequenceHard
    }
        
}


