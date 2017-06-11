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
    
    enum SequenceDifficulty {
        case basic
        case easy
        case easyMedium
        case medium
        case mediumHard
        case hard
        case veryHard
        case impossible
    }
    
    var difficultyToSequenceArray: [SequenceDifficulty:[GameScene.SpawnAction]]
    
    
    public init() {
        
        difficultyToSequenceArray = [
            .basic: [basicSequence0, basicSequence1],
            .easy: [easySequence0, easySequence1, easySequence2, easySequence3],
            .easyMedium: [easyMediumSequence0, easyMediumSequence1, easyMediumSequence2, easyMediumSequence3],
            .medium: [mediumSequence0, mediumSequence1, mediumSequence2, mediumSequence3, mediumSequence4, mediumSequence5,  mediumSequence6, mediumSequence7],
            .mediumHard: [mediumHardSequence0, mediumHardSequence1, mediumHardSequence2, mediumHardSequence3, mediumHardSequence4],
            .hard: [hardSequence0, hardSequence1, hardSequence2, hardSequence3, hardSequence4, hardSequence5, hardSequence6, hardSequence7, hardSequence8, hardSequence9],
            .veryHard: [veryHardSequence0, veryHardSequence1, veryHardSequence2, veryHardSequence3, veryHardSequence4, veryHardSequence5],
            .impossible: [impossibleSequence0, impossibleSequence1, impossibleSequence2]
        ]
    }
    
    // These two variables are used to make sure we do not produce the sequence twice in a row.
    var prevSequenceDifficulty: SpawnSequenceManager.SequenceDifficulty?
    var removedSequence: GameScene.SpawnAction?
    
    private func getSpawnSequenceDifficulty(time: Int) -> SequenceDifficulty {
        
        if time <= 0 {
            return .basic
        } else if time <= 11 {
            return .easy
        } else if time <= 18 {
            return .easyMedium
        } else if time <= 40 {
            return .medium
        } else if time <= 53 {
            return .mediumHard
        } else if time <= 85 {
            return .hard
        } else if time <= 135 {
            return .veryHard
        }
        return .impossible
    }
    
    
    public func getSpawnSequence(time: Int) -> GameScene.SpawnAction {
        // Outputs an appropriate sequence of nodes given the time, will not output the same sequence twice in a row.
        
        let nextSequenceDifficulty = getSpawnSequenceDifficulty(time: time)
        // Dictionary will always return a sequence array so we can safely unwrap here
        var nextSequenceArray = difficultyToSequenceArray[nextSequenceDifficulty]!
        
        let index = Utility.random(min: 0, max: (nextSequenceArray.count) - 1)
        let nextSequence = nextSequenceArray[index]
        
        // Remove nextSequence from array so it isn't output the next time getSpawnSequence is called
        nextSequenceArray.remove(at: index)
        difficultyToSequenceArray[nextSequenceDifficulty] = nextSequenceArray
        
        // Now put prevSequence back into the appropriate sequence array if it isn't nil
        if prevSequenceDifficulty != nil {
            var prevSequenceArray = difficultyToSequenceArray[prevSequenceDifficulty!]
            prevSequenceArray!.append(removedSequence!)
            difficultyToSequenceArray[prevSequenceDifficulty!] = prevSequenceArray
        }
        
        // Reset prevSequenceDifficulty and removedSequence variables
        prevSequenceDifficulty = nextSequenceDifficulty
        removedSequence = nextSequence
        return nextSequence
    }
    
    
    
    // Sequences
    
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
                                .wait(time: 0.65),
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
    
    private let mediumHardSequence4: GameScene.SpawnAction =
        .repeated(times: 3, action:
            .sequence(actions: [.wait(time: 0.6),
                                .spawnFastGemLeft, .spawnGemRight,
                                .wait(time: 0.35),
                                .spawnDetonatorRight,
                                .wait(time: 0.35),
                                .spawnFastGemLeft,
                                .wait(time: 0.50),
                                .spawnGemLeft, .spawnFastGemRight,
                                .wait(time: 0.35),
                                .spawnDetonatorLeft
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
        .repeated(times: 5, action:
            .sequence(actions: [.wait(time: 0.4),
                                .spawnDetonatorLeft, .spawnFastGemRight,
                                .wait(time: 0.45),
                                .spawnFastGemLeft, .spawnDetonatorRight,
                                .wait(time: 0.15),
                                .spawnFastGemRight,
                                .wait(time: 0.20),
                                .spawnGemRight, .spawnDetonatorRight, .spawnGemLeft
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

    private let veryHardSequence5: GameScene.SpawnAction =
        .sequence(actions:[
            .wait(time: 1.5),
            .repeated(times: 10, action: .sequence(actions: [
                .wait(time: 0.3),
                .spawnFastGemLeft, .spawnFastGemRight,
                .wait(time: 0.2),
                .spawnDetonatorLeft, .spawnDetonatorRight,
                .wait(time: 0.3),
                .spawnFastGemLeft, .spawnFastGemRight, .spawnDetonatorLeft, .spawnDetonatorRight,
                ]))
            ])
    
    private let impossibleSequence0: GameScene.SpawnAction =
        .sequence(actions: [
            .wait(time: 2.0),
            .repeated(times: 5, action: .sequence(actions: [
                .wait(time: 0.3),
                .spawnDetonatorLeft, .spawnFastGemRight, .spawnDetonatorRight,
                .wait(time: 0.2),
                .spawnFastGemLeft, .spawnDetonatorRight, .spawnFastGemRight,
                .wait(time: 0.2),
                .spawnDetonatorLeft, .spawnFastGemRight,
                .wait(time: 0.3),
                .spawnDetonatorLeft, .spawnDetonatorRight, .spawnFastGemLeft, .spawnFastGemRight,
                .wait(time: 0.2),
                .spawnDetonatorLeft, .spawnFastGemRight,
                .wait(time: 0.2),
                .spawnFastGemLeft, .spawnDetonatorLeft, .spawnFastGemRight,
                .wait(time: 0.2),
                .spawnDetonatorRight, .spawnFastGemLeft
                ]))
            ])
    
    private let impossibleSequence1: GameScene.SpawnAction =
        .sequence(actions: [
            .wait(time: 2.0),
            .repeated(times: 10, action: .sequence(actions: [
                .spawnFastGemRight, .spawnFastGemRight, .spawnFastGemLeft, .spawnFastGemRight, .spawnDetonatorLeft,
                .wait(time: 0.20),
                .spawnFastGemLeft, .spawnFastGemLeft, .spawnFastGemRight, .spawnDetonatorRight, .spawnDetonatorLeft,
                .wait(time: 0.35)
                ]))
            ])
    
    private let impossibleSequence2: GameScene.SpawnAction =
        .sequence(actions: [
            .wait(time: 2.0),
            .spawnFastGemRight, .spawnFastGemRight, .spawnFastGemLeft, .spawnFastGemLeft,
            .wait(time: 0.2),
            .spawnDetonatorLeft, .spawnDetonatorLeft, .spawnDetonatorLeft, .spawnDetonatorLeft, .spawnDetonatorRight, .spawnDetonatorRight, .spawnDetonatorRight, .spawnDetonatorRight,
            .wait(time: 0.5),
            .spawnGemLeft, .spawnGemRight,
            .repeated(times: 7, action: .sequence(actions: [
                .wait(time: 0.3),
                .spawnFastGemLeft, .spawnFastGemRight, .spawnDetonatorLeft, .spawnDetonatorRight,
                .wait(time: 0.2),
                .spawnDetonatorRight, .spawnFastGemRight,
                .wait(time: 0.3),
                .repeated(times: 3, action: .sequence(actions: [.wait(time: 0.15),
                    .spawnDetonatorLeft, .spawnFastGemLeft,
                    .wait(time: 0.15),
                    .spawnDetonatorRight, .spawnFastGemRight])),
                .spawnFastGemRight, .spawnDetonatorLeft, .spawnFastGemLeft
                ]))
            ])
    
}


