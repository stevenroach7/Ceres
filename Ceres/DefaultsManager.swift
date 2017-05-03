//
//  DefaultsManager.swift
//  Ceres
//
//  Created by Steven Roach on 4/28/17.
//  Copyright © 2017 Stellanova. All rights reserved.
//

import Foundation


class DefaultsManager {
    
    
    private let defaults: UserDefaults = UserDefaults.standard
    
    public func getValue(key: String) -> Bool {
        return defaults.bool(forKey: key)
    }
    
    public func setValue(key: String, value: Bool) {
        defaults.set(value, forKey: key)
    }
    
    public func getHighScores() -> [Int] {
        return defaults.array(forKey: "HighScores") as! [Int]
    }
    
    public func presentHighScores() -> [Int] {
        let highScores = getHighScores()
        var highScoresWithoutZeroes = [Int]()
        if (highScores[highScores.count - 1] == 0) {
            for i in (0...(highScores.count - 1)) {
                if (highScores[i] != 0){
                    highScoresWithoutZeroes.append(highScores[i])
                }
            }
            return highScoresWithoutZeroes
        }
        return highScores
    }
    
    public func setHighScores(value: [Int]) {
        defaults.set(value, forKey: "HighScores")
    }
    
    public func registerMusicAndSound() {
        defaults.register(defaults: ["MusicOnOff" : true])
        defaults.register(defaults: ["SoundOnOff" : true])
    }
    
    public func registerHighScores() {
        defaults.register(defaults: ["HighScores" : Array(repeating: 0, count: 5)])
    }
}
