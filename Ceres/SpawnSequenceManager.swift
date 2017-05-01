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
    
    private let pauseSequenceShort: GameScene.SpawnAction = .wait(time: 3.0)
    private let pauseSequenceLong: GameScene.SpawnAction = .wait(time: 10.0)
    
    
    
    // Start making sequences after this line
    
    let basicSequences: [GameScene.SpawnAction]
    let easySequences: [GameScene.SpawnAction]
    let easyMediumSequences: [GameScene.SpawnAction]
    let mediumSequences: [GameScene.SpawnAction]
    let mediumHardSequences: [GameScene.SpawnAction]
    let hardSequences: [GameScene.SpawnAction]
    let veryHardSequences: [GameScene.SpawnAction]
//    let impossibleSequences:[GameScene.SpawnAction]
    let tempSequences: [GameScene.SpawnAction]
    
    
    
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
                  action: .sequence(actions: [.repeated(times: 3, action: .sequence(actions: [.wait(time: 0.5), .spawnGemRight])),
                                              .repeated(times: 3, action: .sequence(actions: [.wait(time: 0.5), .spawnGemLeft]))]))
    
    
    private let easyMediumSequence0: GameScene.SpawnAction =
        .repeated(times: 8,
                  action: .sequence(actions: [.wait(time: 0.4), .spawnGemLeft, .wait(time: 0.25), .spawnGemRight]))
    
    private let easyMediumSequence1: GameScene.SpawnAction =
        .repeated(times: 2,
                  action: .sequence(actions: [.wait(time: 0.9), .spawnGemRight, .spawnGemLeft,
                                              .wait(time: 0.5), .spawnGemLeft,
                                              .wait(time: 0.5), .spawnGemRight,
                                              .wait(time: 0.9), .spawnGemLeft, .spawnGemRight,
                                              .wait(time: 0.5), .spawnGemRight,
                                              .wait(time: 0.5), .spawnGemLeft]))
    
    private let easyMediumSequence2: GameScene.SpawnAction =
        .repeated(times: 7,
                  action: .sequence(actions: [.wait(time: 0.8), .spawnGemRight, .spawnGemLeft]))
    

    private let easyMediumSequence3: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 1.25),
                                .spawnGemLeft, .spawnGemRight,
                                .wait(time: 0.15),
                                .spawnGemRight,
                                .wait(time: 0.75),
                                .spawnGemLeft,
                                .wait(time: 0.10),
                                .spawnGemLeft, .spawnGemRight,
                                .wait(time: 0.15),
                                .spawnGemLeft
                ]))
    
    
    
    
    private let mediumSequence0: GameScene.SpawnAction =
        .repeated(times: 2, action:
            .sequence(actions: [.wait(time: 0.6),
                                .spawnGemLeft,
                                .wait(time: 0.35),
                                .spawnDetonatorRight,
                                .wait(time: 0.6),
                                .spawnGemLeft, .spawnGemRight,
                
                                .wait(time: 0.6),
                                .spawnGemRight,
                                .wait(time: 0.35),
                                .spawnDetonatorLeft,
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
                                .spawnFastGemLeft,
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

    
    
    private let mediumHardSequence0: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 0.4),
                                .spawnDetonatorLeft, .spawnGemRight,
                                .wait(time: 0.45),
                                .spawnGemLeft,
                                .wait(time: 0.45),
                                .spawnGemRight,
                                .wait(time: 0.20),
                                .spawnDetonatorRight
                ]))

    private let mediumHardSequence1: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 1.0),
                                .spawnGemLeft, .spawnDetonatorRight,
                                .wait(time: 0.5),
                                .spawnGemRight,
                                .wait(time: 0.3),
                                .spawnDetonatorLeft, .spawnGemLeft
            ]))
    
    private let mediumHardSequence2: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 0.50),
                                .spawnGemRight, .spawnGemLeft,
                                .wait(time: 0.20),
                                .spawnDetonatorRight,
                                .wait(time: 0.20),
                                .spawnGemLeft,
                                .wait(time: 0.20),
                                .spawnDetonatorLeft,
                                .wait(time: 0.20),
                                .spawnDetonatorRight,
                                .wait(time: 0.20),
                                .spawnGemRight
            ]))
    
    private let mediumHardSequence3: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 0.70),
                                .spawnGemLeft, .spawnDetonatorRight, .spawnGemRight,
                                .wait(time: 0.30),
                                .spawnGemLeft,
                                .wait(time: 0.30),
                                .spawnDetonatorLeft, .spawnGemRight,
                                .wait(time: 0.30),
                                .spawnGemLeft,
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
                                .spawnDetonatorLeft, .spawnGemRight, .spawnDetonatorRight,
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
            .sequence(actions: [.wait(time: 2.5), .repeated(times: 6, action:
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
            .sequence(actions: [.wait(time: 2.5),
                                .repeated(times: 2, action:
                                    .sequence(actions: [.wait(time: 0.3), .spawnGemLeft, .wait(time: 0.2), .spawnGemRight])),
                                .wait(time: 0.4),
                                .repeated(times: 3, action:
                                    .sequence(actions: [.wait(time: 0.3), .spawnGemLeft, .spawnDetonatorRight, .wait(time: 0.2), .spawnDetonatorLeft, .spawnGemRight])),
                                .wait(time: 0.2),
                                .spawnFastGemRight,
                                .wait(time: 0.2),
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
    
    private let hardSequence8: GameScene.SpawnAction =
        .sequence(actions:[
            .wait(time: 2.0),
            .repeated(times: 12, action:
                .sequence(actions: [
                    .sequence(actions: [.wait(time: 0.2), .spawnFastGemLeft, .wait(time: 0.2), .spawnFastGemRight, .spawnDetonatorLeft]),
                    .sequence(actions: [.wait(time: 0.2), .spawnFastGemLeft, .wait(time: 0.2), .spawnFastGemRight, .spawnDetonatorRight]),
                    ]))
        ])
    
    
    private let hardSequence9: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 0.4),
                                .spawnDetonatorLeft, .spawnFastGemRight,
                                .wait(time: 0.45),
                                .spawnFastGemLeft,
                                .wait(time: 0.45),
                                .spawnFastGemRight,
                                .wait(time: 0.20),
                                .spawnDetonatorRight
                ]))
    
    
    
    private let veryHardSequence0: GameScene.SpawnAction =
        .repeated(times: 2, action:
            .sequence(actions: [.wait(time: 1.6),
                                .repeated(times: 2, action:
                                    .sequence(actions: [.wait(time: 0.5),
                                                        .spawnGemRight, .spawnGemLeft, .spawnGemRight, .spawnDetonatorLeft,
                                                        .spawnGemLeft, .spawnDetonatorRight])),
                                .repeated(times: 3, action:
                                    .sequence(actions: [.wait(time: 0.5),
                                                        .spawnDetonatorLeft, .spawnGemRight, .spawnDetonatorRight,
                                                        .spawnGemLeft, .spawnDetonatorRight, .spawnGemLeft]))
                ]))
    
    private let veryHardSequence1: GameScene.SpawnAction =
        .repeated(times: 15, action:
            .sequence(actions: [.wait(time: 0.2), .spawnDetonatorLeft, .spawnGemLeft,
                               .wait(time: 0.2), .spawnDetonatorRight, .spawnGemRight]))
    
    private let veryHardSequence2: GameScene.SpawnAction =
    .repeated(times: 2, action:
        .sequence(actions: [
            .repeated(times: 4, action:
                .sequence(actions: [
                    .repeated(times: 5, action:
                        .sequence(actions: [.wait(time: 0.1),  .spawnGemLeft,
                                           .wait(time: 0.1), .spawnGemRight])),
                    .spawnDetonatorLeft
                ])
            ),
            .repeated(times: 5, action:
                .sequence(actions: [
                    .repeated(times: 3, action:
                        .sequence(actions: [.wait(time: 0.1),  .spawnDetonatorLeft,
                                            .wait(time: 0.1), .spawnDetonatorRight])),
                    .spawnGemLeft
                    ])
            )
        ]))
    
    private let veryHardSequence3: GameScene.SpawnAction =
        .repeated(times: 4, action:
            .sequence(actions: [.wait(time: 0.4),
                                .spawnGemLeft, .spawnGemRight, .spawnDetonatorLeft, .spawnDetonatorRight,
                                .wait(time: 0.3),
                                .spawnDetonatorRight,
                                .wait(time: 0.5),
                                .repeated(times: 3, action:
                                    .sequence(actions: [.wait(time: 0.2),
                                                        .spawnDetonatorLeft, .spawnGemLeft,
                                                        .wait(time: 0.2),
                                                        .spawnDetonatorRight, .spawnGemRight])),
                                .spawnGemRight, .spawnDetonatorLeft
            ]))
   
    
    private let veryHardSequence4: GameScene.SpawnAction =
        .sequence(actions:[
            .wait(time: 2.0),
            .repeated(times: 18, action:
                .sequence(actions: [
                    .sequence(actions: [.wait(time: 0.18), .spawnFastGemLeft, .wait(time: 0.18), .spawnFastGemRight, .spawnDetonatorLeft]),
                    .sequence(actions: [.wait(time: 0.18), .spawnFastGemLeft, .wait(time: 0.18), .spawnDetonatorRight]),
                    ]))
            ])

    
    
    var index = 0
    
    public init() {
        
        basicSequences = [basicSequence0, basicSequence1]
        easySequences = [easySequence0, easySequence1, easySequence2, easySequence3]
        easyMediumSequences = [easyMediumSequence0, easyMediumSequence1, easyMediumSequence2, easyMediumSequence3]
        mediumSequences = [mediumSequence0, mediumSequence1, mediumSequence2, mediumSequence3, mediumSequence4, mediumSequence5,  mediumSequence6, mediumSequence7]
        mediumHardSequences = [mediumHardSequence0, mediumHardSequence1, mediumHardSequence2, mediumHardSequence3]
        hardSequences = [hardSequence0, hardSequence1, hardSequence2, hardSequence3, hardSequence4, hardSequence5, hardSequence6, hardSequence7, hardSequence8, hardSequence9]
        veryHardSequences = [veryHardSequence0, veryHardSequence1, veryHardSequence2, veryHardSequence3, veryHardSequence4]
//        impossibleSequences = []
//        tempSequences = [basicSequence0, pauseSequenceShort, basicSequence1 ,  pauseSequenceLong
//              , easySequence0, pauseSequenceShort, easySequence1, pauseSequenceShort, easySequence2, pauseSequenceShort, easySequence3 ,  pauseSequenceLong
//            ,  easyMediumSequence0, pauseSequenceShort, easyMediumSequence1, pauseSequenceShort, easyMediumSequence2, pauseSequenceShort, easyMediumSequence3 ,  pauseSequenceLong
//        ,  mediumSequence0, pauseSequenceShort, mediumSequence1, pauseSequenceShort, mediumSequence2, pauseSequenceShort, mediumSequence3, pauseSequenceShort, mediumSequence4, pauseSequenceShort, mediumSequence5,  pauseSequenceShort, mediumSequence6, pauseSequenceShort, mediumSequence7  ,  pauseSequenceLong
//        ,  mediumHardSequence0, pauseSequenceShort, mediumHardSequence1, pauseSequenceShort, mediumHardSequence2, pauseSequenceShort, mediumHardSequence3  ,  pauseSequenceLong
//        ,  hardSequence0, pauseSequenceShort, hardSequence1, pauseSequenceShort, hardSequence2, pauseSequenceShort, hardSequence3, pauseSequenceShort, hardSequence4, pauseSequenceShort, hardSequence5, pauseSequenceShort, hardSequence6, pauseSequenceShort, hardSequence7, pauseSequenceShort, hardSequence8  ,  pauseSequenceLong
//        ,  veryHardSequence0, pauseSequenceShort, veryHardSequence1, pauseSequenceShort, veryHardSequence2, pauseSequenceShort, veryHardSequence3, pauseSequenceShort, veryHardSequence4  ,  pauseSequenceLong]
        
        tempSequences = [easySequence3, pauseSequenceShort, easyMediumSequence1, pauseSequenceShort, mediumSequence0, pauseSequenceShort, mediumSequence4, pauseSequenceShort, mediumSequence6, pauseSequenceShort, hardSequence1, pauseSequenceShort, hardSequence6]

    }
    
    public func getSpawnSequence(time: Int) -> GameScene.SpawnAction {
        // Gem spawning routine
//        let sequences = mediumSequences
//        let sequences = hardSequences
//        let sequences = mediumHardSequences
//        let sequences = tempSequences
//        let sequences = easyMediumSequences
        
//        if index < sequences.count {
//            let sequence = sequences[index]
//            index += 1
//            return sequence
//        } else {
//            return pauseSequenceLong
//        }
        
        if time <= 0 {
            return basicSequences[Utility.random(min: 0, max: basicSequences.count - 1)]
        } else if time <= 11 {
            return easySequences[Utility.random(min: 0, max: easySequences.count - 1)]
        } else if time <= 18 {
            return easyMediumSequences[Utility.random(min: 0, max: easyMediumSequences.count - 1)]
        } else if time <= 40 {
            return mediumSequences[Utility.random(min: 0, max: mediumSequences.count - 1)]
        } else if time <= 53 {
            return mediumHardSequences[Utility.random(min: 0, max: mediumHardSequences.count - 1)]
        } else if time <= 85 {
            return hardSequences[Utility.random(min: 0, max: hardSequences.count - 1)]
        } else if time <= 135 {
            return veryHardSequences[Utility.random(min: 0, max: veryHardSequences.count - 1)]
        }
        return spawnSequenceHard
    }
        
}


