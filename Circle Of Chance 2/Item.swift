//
//  Item.swift
//  CircleOfChance
//
//  Created by Mac on 1/25/17.
//  Copyright © 2017 KJB Apps LLC. All rights reserved.
//

import Foundation
import SpriteKit

enum itemType: Int {
    case skin, theme
}

class item: NSObject, NSCoding{
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let UnlockedArchiveURL = DocumentsDirectory.appendingPathComponent("unlockedItem")
    static let CurrentArchiveURL = DocumentsDirectory.appendingPathComponent("currentSkin")
    
    fileprivate var _itemtype: itemType
    
    var itemtype: itemType {
        get{
            return _itemtype
        }
        set{
            _itemtype = newValue
        }
    }
    
    fileprivate var _sprite: SKSpriteNode
    
    var sprite: SKSpriteNode{
        get{
            return _sprite
        }
        set{
            _sprite = newValue
        }
    }
    
    fileprivate var _name: String
    
    var name: String{
        get{
            return _name
        }
        set {
            _name = newValue
        }
    }
    fileprivate var _price: Int
    
    var price:Int {
        get{
            return _price
        }
        set {
            _price = newValue
        }
    }
    
    override var description: String{
        return "\(name)"
    }
    
    init(item: itemType, sprite: SKSpriteNode, name: String, price: Int) {
        self._itemtype = item
        self._sprite = sprite
        self._name = name
        self._price = price
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let price = aDecoder.decodeObject(forKey: "price") as! Int
        let sprite = aDecoder.decodeObject(forKey: "sprite") as! SKSpriteNode
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let itemtype = aDecoder.decodeInteger(forKey: "item")
        self.init(item: itemType.init(rawValue: itemtype)!, sprite: sprite, name: name, price: price)
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_name, forKey: "name")
        aCoder.encode(_price, forKey: "price")
        aCoder.encode(_sprite, forKey: "sprite")
        aCoder.encode(_itemtype.rawValue, forKey: "item")
    }
}
