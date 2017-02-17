//
//  howToPlayScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/14/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit

class howToPlayScene: SKScene {
    var howToPlayImage = SKSpriteNode()
    var goBack = SKSpriteNode()
    var backGround = SKShapeNode()
    var tip = SKSpriteNode()
    var tipActive = true
    var counter = Int()
    var cycle = [SKTexture(imageNamed: "howToPlay1"), SKTexture(imageNamed: "howToPlay2"), SKTexture(imageNamed: "howToPlay3"), SKTexture(imageNamed: "howToPlay4"), SKTexture(imageNamed: "howToPlay5"), SKTexture(imageNamed: "howToPlay6"), SKTexture(imageNamed:"howToPlay7")]
    
    override func didMove(to view: SKView) {
        loadview()
        addTip()
    }
    
    func loadview() {
        
        self.backgroundColor = SKColor(red: 31/255, green: 30/255, blue: 30/255, alpha: 1.0)
        
        howToPlayImage = SKSpriteNode(imageNamed: "howToPlay1")
        counter = 0
        howToPlayImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(howToPlayImage)
        
        goBack = SKSpriteNode(imageNamed: "backButton")
        goBack.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        goBack.position = CGPoint(x: self.frame.width/2 - 175, y: self.frame.height - 65)
        goBack.size = CGSize(width:50, height: 50)
        goBack.zPosition = 15
        self.addChild(goBack)
        let scaleup = SKAction.scale(to: 1.1, duration: 0.25)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.25)
        goBack.run(SKAction.repeatForever(SKAction.sequence([scaleup,scaleDown])))
    }
    
    func addTip() {
        backGround = SKShapeNode(rect: CGRect(x: -self.frame.width/2, y: -self.frame.height/2, width: self.frame.width, height: self.frame.height))
        backGround.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        backGround.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backGround.zPosition = 10
        backGround.strokeColor = UIColor.clear
        self.addChild(backGround)
        
        tip = SKSpriteNode(imageNamed: "tipButton")
        backGround.addChild(tip)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
            
            if goBack.contains(touchLocation) && tipActive == false {
                goBack.alpha = 0.5
            }
            else {
                goBack.alpha = 1.0
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let tiplocation = touch.location(in: backGround)
            let touchLocation = touch.location(in: self)
            if goBack.contains(touchLocation){
                if let scene = MainMenu(fileNamed:"GameScene") {
                    
                    // Configure the view.
                    let skView = self.view as SKView!
                    skView?.showsFPS = true
                    skView?.showsNodeCount = true
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView?.ignoresSiblingOrder = true
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 0.8)
                    skView?.presentScene(scene, transition: transition)
                }
            }
            else {
                goBack.alpha = 1.0
            }
            
            if tipActive == false && goBack.contains(touchLocation) == false {
                changeImage(touches)
            }
            
            if tip.contains(tiplocation) {
                backGround.removeAllChildren()
                backGround.removeFromParent()
                tipActive = false
            }
        }
        


    }
    
    func changeImage(_ touches: Set<UITouch>) {
        let upperLimit = cycle.count-1
        let lowerLimit = 0
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            if (touchLocation.x > self.frame.size.width/2) {
                if counter == upperLimit {
                    counter = 0
                }
                else {
                    counter += 1
                }
                
                howToPlayImage.texture = cycle[counter]
            }
            else if (touchLocation.x < self.frame.size.width/2) {
                if counter == lowerLimit {
                    counter = upperLimit
                }
                else {
                    counter -= 1
                }
                
                howToPlayImage.texture = cycle[counter]
            }
        }
    }

    
}
