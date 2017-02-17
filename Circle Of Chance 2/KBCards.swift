//
//  KBFateCards.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import Foundation
import SpriteKit

enum EffectType: Int {
    case motion = 0, fluctuate, ghost, haste, unstable, shake
    
    var getEffectName: String {
        let effectNames = [
            "motion",
            "fluctuate",
            "ghost",
            "haste",
            "unstable",
            "shake"
        ]
        
        return effectNames[rawValue-1]
    }
    
    static func getFruitType(_ num: Int) -> EffectType {
        return EffectType(rawValue: num)!
    }
}

class Effect{
    
    var isActive: Bool
    var effectType: EffectType
    
    init(active: Bool, effecttype: EffectType) {
        self.isActive = active
        self.effectType = effecttype
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
