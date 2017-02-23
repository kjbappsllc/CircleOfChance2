//
//  SpecialNodes.swift
//  SwiftXcodePractice
//
//  Created by Mac on 2/19/17.
//  Copyright © 2017 KJB Apps LLC. All rights reserved.
//

import UIKit
import SpriteKit

class SpecialNodes: SKSpriteNode {
    private var textAtlas: SKTextureAtlas
    private var imageUniformName: String
    init(Begintexture: SKTexture!, textAtlas: SKTextureAtlas, uniformName: String) {
        self.textAtlas = textAtlas
        let texture = Begintexture
        self.imageUniformName = uniformName
        super.init(texture: texture, color: UIColor.clear, size: (texture?.size())!)
        print(Begintexture)
        
        animateTextures(atlas: textAtlas)

    }
    
    struct propertyKeys {
        static let atlas = "atlasKey"
        static let uniform = "uniformKey"
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.textAtlas = aDecoder.decodeObject(forKey: propertyKeys.atlas) as! SKTextureAtlas
        self.imageUniformName = aDecoder.decodeObject(forKey: propertyKeys.uniform) as! String
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(textAtlas, forKey: propertyKeys.atlas)
        aCoder.encode(imageUniformName, forKey: propertyKeys.uniform)
        super.encode(with: aCoder)
    }
    
    func animateTextures(atlas: SKTextureAtlas) {
        let pacAtlas = atlas
        var frames = [SKTexture]()
        
        let numImages = pacAtlas.textureNames.count
        
        for i in 1...numImages/2 {
            let textName = "\(imageUniformName)\(i)"
            frames.append(pacAtlas.textureNamed(textName))
        }
        
        let animation = SKAction.animate(with: frames, timePerFrame: 0.1)
        
        self.run(SKAction.repeatForever(SKAction.sequence([animation,animation.reversed()])))
        
    }

}
