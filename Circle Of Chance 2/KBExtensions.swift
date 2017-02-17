//
//  KBExtension.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

enum layerPositions: CGFloat {
    case background = 1,gamePlayArea, maskLayer, dots, character, barriers, topLayer, textLayer, pauseLayer
}

public extension Collection {
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

public extension MutableCollection where Index == Int {
    mutating func shuffleInPlace() {
        let num = count.toIntMax()
        if Int(num) < 2 { return }
        
        for i in 0..<Int(num-1) {
            let j = Int(arc4random_uniform(UInt32(num - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

