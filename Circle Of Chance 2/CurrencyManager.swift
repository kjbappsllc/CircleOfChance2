//
//  CurrencyManager.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import SpriteKit

class CurrencyManager: NSObject {
    var coins: Int {
        
        set(value) {
            UserDefaults.standard.set(value, forKey: "coins")
        }
        get {
            return UserDefaults.standard.integer(forKey: "coins")
        }
    }
    
    var totalCoins: Int {
        set(value) {
            UserDefaults.standard.set(value, forKey: "totalcoins")
        }
        
        get {
            return UserDefaults.standard.integer(forKey: "totalcoins")
        }
    }
    
    var games: Int {
        set(value) {
            UserDefaults.standard.set(value, forKey: "games")
        }
        
        get {
            return UserDefaults.standard.integer(forKey: "games")
        }
    }
}
