//
//  KBStarIcon.swift
//  Circle Of Chance
//
//  Created by Mac on 6/16/16.
//  Copyright © 2016 KJB Apps LLc. All rights reserved.
//
import Foundation
import SpriteKit

class StarIcon: SKSpriteNode {
    
    init(){

        let texture = SKTexture(imageNamed: "Star")
        
        super.init(texture: texture ,color: UIColor.clear, size: texture.size())
        
        zPosition = layerPositions.dots.rawValue
        physicsBody = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateStar() {
        let scaled = SKAction.scale(to: 1.2, duration: 0.4)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.4)
        scaled.timingMode = .easeOut
        
        self.run(SKAction.repeatForever(SKAction.sequence([scaled,scaleDown])))
    }
    
    func LoadPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: 2.5)
        physicsBody?.categoryBitMask = starCategory
        physicsBody?.contactTestBitMask = ballCategory
        physicsBody?.collisionBitMask = ballCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
    }
    
}
