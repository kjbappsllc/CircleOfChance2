//
//  Character.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//

import Foundation
import SpriteKit

class Character {
    var ballSpeedClockWise = CGFloat()
    var ballSpeedCounterClockWise = CGFloat()
    var rotation: CGFloat
    var orient: Bool
    fileprivate var _size: CGSize
    var size: CGSize {
        get{
            return _size
        }
        set{
            _size = newValue
        }
    }
    
    init() {
        orient = false
        rotation = 0
        ballSpeedClockWise = 195.0
        ballSpeedCounterClockWise = 195.0
        _size = CGSize(width: 55, height: 55)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getballSpeedClockWise() -> CGFloat {
        return ballSpeedClockWise
    }
    
    func getballSpeedCounterClockWise() -> CGFloat {
        return ballSpeedCounterClockWise
    }
    
    func AddBallSpeedClockWise(_ add: CGFloat){
        ballSpeedClockWise += add
    }
    
    func AddBallSpeedCounterClockWise(_ add:CGFloat) {
        ballSpeedCounterClockWise += add
    }
    
    func SetBallSpeedCounterClockWise(_ new:CGFloat) {
        ballSpeedCounterClockWise = new
    }
    
    func SetBallSpeedClockWise(_ new:CGFloat) {
        ballSpeedClockWise = new
    }
    
    func loadPhysics() -> SKPhysicsBody{
        
        let physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/2 - 15)
        physicsBody.categoryBitMask = ballCategory
        physicsBody.contactTestBitMask = redBarrierCategory | dotCategory
        physicsBody.collisionBitMask = redBarrierCategory
        physicsBody.affectedByGravity = false
        return physicsBody
    }
    
    func setSkinOrientation(name: String) {
        switch name {
            
        case "CHOMP":
            orient = true
            
        default:
            break
        }
    }
    
}
