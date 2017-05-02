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
    
    public func getHighScore() -> Int {
        return defaults.integer(forKey: "HighScore")
    }
    
    public func setHighScore(key: String, value: Int) {
        defaults.set(value, forKey: key)
    }
    
    public func registerMusicAndSound() {
        defaults.register(defaults: ["MusicOnOff" : true])
        defaults.register(defaults: ["SoundOnOff" : true])
    }
    
    public func registerHighScore() {
        defaults.register(defaults: ["HighScore" : 0])
    }
}
