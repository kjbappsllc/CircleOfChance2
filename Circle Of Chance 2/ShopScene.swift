//
//  ShopScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/8/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit
import StoreKit

class ShopScene: SKScene, ChartboostDelegate {
    
    //Currency and shopping
    var currency = CurrencyManager()
    let productID: NSSet = NSSet(objects:"com.KJBApps.CircleOfChance2.doublecoins")
    var store: IAPHelper?
    var list = [SKProduct]()
    var doubleCoinsBool = Bool()
    var doubleCoins = SKSpriteNode()
    
    //TopBar
    var backButton = SKSpriteNode()
    var topBar = SKNode()
    var coins = SKLabelNode()
    
    //Selection
    var selectionLayer = SKNode()
    var skinsSection = SKSpriteNode()
    var themesSection = SKSpriteNode()
    var skins_selected = Bool()
    var shopItems = items()
    var moveableArea = SKNode()
    var itemSelectionBG = SKSpriteNode()
    var current = SKLabelNode()
    var end = SKLabelNode()
    var counterNode = SKNode()
    var selectionIndicator = SKSpriteNode()
    
    //items
    var shopSkins = [item]()
    var shopThemes = [item]()
    var unlockedItems = [item]()
    var startX: CGFloat = 0.0
    var lastX: CGFloat = 0.0
    var beginLimit = 1
    var furthestLimit = Int()
    var currentItem = 1
    var currentItemSkin = 0
    var currentItemTheme = 0
    var moved = false
    
    override func didMove(to view: SKView) {
        isUserInteractionEnabled = false
        shopSkins = shopItems.loadInitialSkins()
        unlockedItems = shopItems.unlocked
        
        loadView()
        animateEnter { 
            self.isUserInteractionEnabled = true
        }
    }
    
    deinit {
        SKPaymentQueue.default().remove(store!)
    }
    
    //Mark: Loads the View
    func loadView() {
        // Top Bar
        topBar = self.childNode(withName: "topBar")!
        backButton = topBar.childNode(withName: "backButton") as! SKSpriteNode
        coins = topBar.childNode(withName: "coins") as! SKLabelNode
        
        //Shop
        doubleCoinsBool = UserDefaults.standard.bool(forKey: "com.KJBApps.CircleOfChance.doublecoins")
        
        //Selection
        selectionLayer = self.childNode(withName: "selection")!
        skinsSection = selectionLayer.childNode(withName: "skinSelection") as! SKSpriteNode
        themesSection = selectionLayer.childNode(withName: "themeSelection") as! SKSpriteNode
        skins_selected = true
        itemSelectionBG = self.childNode(withName: "itemSelectionBg") as! SKSpriteNode
        doubleCoins = self.childNode(withName: "doubleCoins") as! SKSpriteNode
        counterNode = self.childNode(withName: "counterNode")!
        current = counterNode.childNode(withName: "current") as! SKLabelNode
        end = counterNode.childNode(withName: "end") as! SKLabelNode
        
        store = IAPHelper(productIds: productID as! Set<ProductIdentifier>)
        
        if IAPHelper.canMakePayments() {
            store?.requestProducts({ (success, products) in
                if success {
                    self.list = products!
                }
            })
        }
        else {
            print("can't make payments")
        }
        
        coins.text = "\(currency.coins)"
        itemSelectionBG.addChild(moveableArea)
        current.text = "1"
        end.text = "\(shopSkins.count)"

        addItems(shopSkins, isSkin: true)
    }
    
    func addItems(_ nodes: [item], isSkin: Bool) {
        for i in 0..<nodes.count {
            //Setup the slot that the item will go in
            let item = itemContainer(shopItem: nodes[i])
            item.position.x = self.size.width/2 * CGFloat(i)
            item.name = nodes[i].name
            item.zPosition = 2
            moveableArea.addChild(item)
            
            //position the sprite
            let skin = item.shopItem.sprite
            skin.size = CGSize(width: 80, height: 80)
            skin.name = "skin"
            skin.zPosition = 5
            skin.position.y = 55
            item.addChild(skin)
            
            //position the name
            let name = SKLabelNode()
            name.text = item.shopItem.name
            setUpLabel(name, size: 26, fontName: "Arial", fontColor: SKColor.init(colorLiteralRed: 176/255, green: 83/255, blue: 245/255, alpha: 1.0))
            name.position.y = -20
            name.zPosition = 10
            item.addChild(name)
            
            
            //position the price
            if !unlockedItems.contains(where: {$0.name == nodes[i].name}){
                let price = SKLabelNode()
                price.text = "\(nodes[i].price)"
                setUpLabel(price, size: 36.0, fontName: "Arial", fontColor: SKColor.black)
                price.position.y = -item.size.height/2 + 70
                price.zPosition = 10
                price.name = "price"
                item.addChild(price)
                
                item.alpha = 0.66
            }
            
            if shopItems.current.name == item.shopItem.name{
                selectionIndicator = SKSpriteNode(imageNamed: "selectedItemIndicator")
                selectionIndicator.position.x = item.position.x
                selectionIndicator.zPosition = 1
                moveableArea.addChild(selectionIndicator)
                currentItemSkin = i
                currentItem = i+1
                moveableArea.position.x = -self.frame.width/2 * CGFloat(currentItemSkin)
                current.text = "\(currentItem)"
            }
        }
    }
    
    //This function just reduces a little of the code to set up a label
    func setUpLabel(_ label: SKLabelNode, size: CGFloat, fontName: String, fontColor: SKColor){
        label.fontSize = size
        label.fontName = fontName
        label.fontColor = fontColor
    }
    
    func animateEnter(_ completion: @escaping ()->()){
        topBar.position.y = size.height
        selectionLayer.position.x = -size.width
        moveableArea.alpha = 0
        itemSelectionBG.alpha = 0
        counterNode.alpha = 0
        doubleCoins.alpha = 0
        
        let topBarEnter = SKAction.move(by: CGVector(dx: 0,dy: -size.height), duration: 0.4)
        topBarEnter.timingMode = .easeIn
        topBar.run(topBarEnter)
        
        let selectionEnter = SKAction.move(by: CGVector(dx: size.width,dy: 0), duration: 0.3)
        selectionEnter.timingMode = .easeIn
        selectionLayer.run(selectionEnter,completion: completion)
        
        let moveableAreaEnter = SKAction.fadeIn(withDuration: 0.3)
        moveableAreaEnter.timingMode = .easeIn
        moveableArea.run(moveableAreaEnter)
        
        counterNode.run(SKAction.fadeIn(withDuration: 0.2))
        doubleCoins.run(SKAction.fadeIn(withDuration: 0.2))
        itemSelectionBG.run(SKAction.fadeIn(withDuration: 0.1), completion:completion)
    }
    
    func animateExit(_ completion: @escaping () ->()) {
        let topBarExit = SKAction.move(by: CGVector(dx: 0,dy: size.height), duration: 0.4)
        topBarExit.timingMode = .easeOut
        topBar.run(topBarExit)
        
        let selectionExit = SKAction.move(by: CGVector(dx:size.width,dy:0), duration: 0.2)
        selectionExit.timingMode = .easeOut
        selectionLayer.run(selectionExit)
        
        itemSelectionBG.run(SKAction.fadeOut(withDuration: 0.1))
        moveableArea.run(SKAction.fadeOut(withDuration: 0.3))
        
        counterNode.run(SKAction.fadeOut(withDuration: 0.3))
        doubleCoins.run(SKAction.fadeOut(withDuration: 0.3), completion: completion)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        // store the starting position of the touch
        
        for touch in touches {
            let location = touch.location(in: self)
            startX = location.x
            lastX = location.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if moved == false {
                let location = touch.location(in: self)
                let currentX = location.x
                // Set Top and Bottom scroll distances, measured in screenlengths
                if skins_selected == true {
                    furthestLimit = shopSkins.count
                }
                else{
                    furthestLimit = shopThemes.count
                }
                
                // Set scrolling speed - lower number is faster speed
                let scrollSpeed:Double = 0.3
                
                // calculate distance moved since last touch registered and add it to current position
                let offset =  -self.frame.width/2
                
                // perform checks to see if new position will be over the limits, otherwise set as new position
                if currentX < lastX && currentItem != furthestLimit {
                    let moveLAction = SKAction.move(by: CGVector(dx: offset,dy: 0), duration: scrollSpeed)
                    moveLAction.timingMode = .easeOut
                    moveableArea.run(moveLAction)
                    currentItem += 1
                    current.text = "\(currentItem)"
                    moved = true
                }
                else if currentX > lastX && currentItem != beginLimit{
                    let moveRAction = SKAction.move(by: CGVector(dx: -offset,dy: 0), duration: scrollSpeed)
                    moveRAction.timingMode = .easeOut
                    moveableArea.run(moveRAction)
                    currentItem -= 1
                    current.text = "\(currentItem)"
                    moved = true
                }
                
                // Set new last location for next time
                lastX = currentX
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            moved = false
            let touchLocation = touch.location(in: self)
            let backtoMenuTouch = touch.location(in: topBar)
            let selectionTouch = touch.location(in: selectionLayer)
            if backButton.contains(backtoMenuTouch){
                
                if let scene = MainMenu(fileNamed:"GameScene") {
                    
                    // Configure the view.
                    let skView = self.view as SKView!
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView?.ignoresSiblingOrder = true
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .aspectFill
                    animateExit({ 
                        skView?.presentScene(scene)
                    })
                }
            }
            
            if doubleCoins.contains(touchLocation){
                for product in list {
                    if product.productIdentifier == "com.KJBApps.CircleOfChance2.doublecoins" {
                        if let isTrue = store?.isProductPurchased("com.KJBApps.CircleOfChance2.doublecoins") {
                            if isTrue == false {
                                store?.buyProduct(product)
                            }
                        }
                    }
                }
                if doubleCoinsBool != true {
                    doubleCoins.alpha = 1.0
                }
                
                NotificationCenter.default.addObserver(self, selector: #selector(ShopScene.handlePurchaseNotification(_:)),
                                                                 name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                                                 object: nil)
            }
            
            if skinsSection.contains(selectionTouch) {
                if skins_selected == false {
                    skins_selected = true
                    themesSection.alpha = 0.5
                    skinsSection.alpha = 1.0
                    moveableArea.removeAllChildren()
                    moveableArea.position.x = CGFloat(currentItemSkin) * self.frame.width/2
                    addItems(shopSkins, isSkin: true)
                    currentItem = currentItemSkin + 1
                    current.text = "\(currentItem)"
                    end.text = "\(shopSkins.count)"
                }
            }
            
            if themesSection.contains(selectionTouch) {
                if skins_selected == true {
                    skins_selected = false
                    themesSection.alpha = 1.0
                    skinsSection.alpha = 0.5
                    moveableArea.removeAllChildren()
                    moveableArea.position.x = 0
                    addItems(shopThemes, isSkin: false)
                    currentItem = 1
                    current.text = "\(currentItem)"
                    end.text = "\(shopThemes.count)"
                }
            }
            
            if lastX == startX {
                handleItemTap(touch)
            }
        }
    }
    
    func handleItemTap(_ touch: UITouch){
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
            
        if let touchedItem = touchedNode as? itemContainer {
            if unlockedItems.contains(where: {$0.name == touchedItem.shopItem.name}) {
                print(touchedItem.shopItem.name)
                selectionIndicator.position.x = touchedItem.position.x
                shopItems.current = touchedItem.shopItem
            }
            else {
                if touchedItem.shopItem.price <= currency.coins {
                    unlockedItems.append(touchedItem.shopItem)
                    shopItems.unlocked = unlockedItems
                    shopItems.saveItems()
                    
                    currency.coins -= touchedItem.shopItem.price
                    coins.text = "\(currency.coins)"
                    touchedItem.alpha = 1
                    selectionIndicator.position.x = touchedItem.position.x
                    
                    touchedItem.childNode(withName: "price")?.removeFromParent()
                    
                    if touchedItem.shopItem.itemtype == .skin {
                        shopItems.current = touchedItem.shopItem
                    }
                }
                else {
                    let errortext = childNode(withName: "errortext")
                    let fade = SKAction.fadeIn(withDuration: 0.1)
                    let wait = SKAction.wait(forDuration: 0.6)
                    let fadout = SKAction.fadeOut(withDuration: 0.9)
                    
                    errortext?.run(SKAction.sequence([fade,wait,fadout]))
                    
                    let shakeAction = SKAction.move(by: CGVector(dx: 9, dy:0), duration: 0.1)
                    let shake = SKAction.sequence([shakeAction, shakeAction.reversed()])
                    let shaker = SKAction.repeat(shake, count: 3)
                    
                    let colorizer = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.0)
                    
                    let colorback = SKAction.colorize(with: UIColor.white, colorBlendFactor: 0.0, duration: 0.2)
                    coins.run(SKAction.sequence([SKAction.group([shaker,colorizer]), colorback]))
                }
            }
        }
    }
    
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        if productID == "com.KJBApps.CircleOfChance2.doublecoins" {
            doubleCoins.alpha = 0.5
            doubleCoinsBool = true
        }
        
    }
    
}
