//
//  MainMenu.swift
//  Circle of Chance
//
//  Created by Mac on 6/6/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit
import GameKit

class MainMenu: SKScene, GKGameCenterControllerDelegate {
    //Layers
    let titleLayer = SKNode()
    let topButtonLayer = SKNode()
    let bottomButtonLayer = SKNode()
    let playButtonLayer = SKNode()
    
    //TopLayer
    var topBar = SKSpriteNode()
    var title = SKSpriteNode()
    
    //Buttons
    var playButton = SKSpriteNode()
    var shopButton = SKSpriteNode()
    var helpButton = SKSpriteNode()
    var settingsButton = SKSpriteNode()
    var achievementsButton = SKSpriteNode()
    var highscoreButton = SKSpriteNode()
    var rateButton = SKSpriteNode()
    var progressButton = SKSpriteNode()
    var bottomNode = SKNode()
    
    var helpView = UIView()
    var howToPlayButton = UIButton()
    var cardDescriptionsButton = UIButton()
    var helpViewActive = false
    
    var notNewPlayer = false
    var newPlayerTip = SKSpriteNode()
    var backGround = SKShapeNode()
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(titleLayer)
        addChild(topButtonLayer)
        addChild(bottomButtonLayer)
        addChild(playButtonLayer)
        
        //Pre set properties
        titleLayer.isHidden = true
        topButtonLayer.isHidden = true
        bottomButtonLayer.isHidden = true

        loadview()
    }
    
    func loadview() {
        isUserInteractionEnabled = false
        addBackground()
        addTopArea()
        addPlayButton()
        addButtons()
        
        let resize = SKAction.resize(byWidth: 7, height: 0, duration: 1.0)
        let ShiftAction = SKAction.sequence([resize, resize.reversed()])
        
        animateBeginGame {
            self.isUserInteractionEnabled = true
            
            for children in self.bottomButtonLayer.children {
                children.run(SKAction.repeatForever(ShiftAction))
            }
            
            for children in self.topButtonLayer.children {
                children.run(SKAction.repeatForever(ShiftAction))
            }
            
            self.title.run(SKAction.repeatForever(ShiftAction))
            self.playButton.run(SKAction.repeatForever(ShiftAction))
        }
        

    }
    
    //Mark: This function animates the begin of the game
    func animateBeginGame(_ completion: @escaping () -> ()) {
        titleLayer.isHidden = false
        titleLayer.position = CGPoint(x: 0, y: size.height)
        let titleAction = SKAction.move(by: CGVector(dx: 0, dy: -size.height), duration: 0.5)
        titleAction.timingMode = .easeOut
        
        titleLayer.run(titleAction)
        
        topButtonLayer.isHidden = false
        topButtonLayer.position = CGPoint(x: -size.width, y: 0)
        let topButtonAction = SKAction.move(by: CGVector(dx: size.width, dy:0), duration: 0.5)
        topButtonAction.timingMode = .easeOut
        topButtonLayer.run(topButtonAction)
        
        bottomButtonLayer.isHidden = false
        bottomButtonLayer.position = CGPoint(x: 0, y: -size.height)
        let bottomButtonAction = SKAction.move(by: CGVector(dx: 0, dy: size.height), duration: 0.5)
        bottomButtonAction.timingMode = .easeOut
        bottomButtonLayer.run(bottomButtonAction)
        
        playButton.setScale(0)
        let playAction = SKAction.scale(to: 1.0, duration: 0.2)
        playAction.timingMode = .easeIn
        playButton.run(playAction, completion: completion)
    }
    
    //Mark: This function animates the end
    func animateExit(_ completion: @escaping () -> ()) {
        
        let titeExit = SKAction.move(by: CGVector(dx: 0, dy: size.height), duration: 0.7)
        titeExit.timingMode = .easeOut
        
        titleLayer.run(titeExit)
        
        let topbuttonExit = SKAction.move(by: CGVector(dx: -size.width, dy: 0), duration: 0.5)
        topButtonLayer.run(topbuttonExit)
        topbuttonExit.timingMode = .easeIn
        
        let bottomExit = SKAction.move(by: CGVector(dx: -size.width, dy: 0), duration: 0.5)
        bottomButtonLayer.run(bottomExit)
        bottomExit.timingMode = .easeIn
        
        playButton.run(SKAction.scale(to: 0.0, duration: 0.2), completion: completion)
    }
    
    //Mark: This adds the colorful background
    func addBackground() {
        //Adds the colorful background
        
        let background = SKSpriteNode(imageNamed: "backGround")
        background.zPosition = layerPositions.background.rawValue
        self.addChild(background)
    }
    
    //Mark: This adds the top area with the title
    func addTopArea() {
        topBar = SKSpriteNode(imageNamed: "TopArea")
        topBar.position = CGPoint(x: 0, y: self.frame.height/2 - topBar.size.height/2)
        topBar.zPosition = layerPositions.topLayer.rawValue
        titleLayer.addChild(topBar)
        
        title = SKSpriteNode(imageNamed: "title")
        title.zPosition = layerPositions.textLayer.rawValue
        topBar.addChild(title)
    }
    
    //Mark: This adds the button to me played
    func addPlayButton() {
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.zPosition = layerPositions.topLayer.rawValue
        playButton.size = CGSize(width: 202, height: 202)
        playButton.position = CGPoint(x: 220, y: -300)
        playButtonLayer.addChild(playButton)
    }
    
    //Mark: This adds the rest of the buttons
    func addButtons() {
        helpButton = SKSpriteNode(imageNamed: "HelpButton")
        helpButton.zPosition = layerPositions.topLayer.rawValue
        helpButton.position = CGPoint(x: -210, y: -180)
        topButtonLayer.addChild(helpButton)
        
        shopButton = SKSpriteNode(imageNamed: "ShopButton")
        shopButton.zPosition = layerPositions.topLayer.rawValue
        shopButton.position = CGPoint(x: -10, y: -180)
        topButtonLayer.addChild(shopButton)
        
        settingsButton = SKSpriteNode(imageNamed: "SettingsButton")
        settingsButton.zPosition = layerPositions.topLayer.rawValue
        settingsButton.position = CGPoint(x: -210, y: -380)
        bottomButtonLayer.addChild(settingsButton)
        
        achievementsButton = SKSpriteNode(imageNamed: "AchievementButton")
        achievementsButton.zPosition = layerPositions.topLayer.rawValue
        achievementsButton.position = CGPoint(x: -10, y: -380)
        bottomButtonLayer.addChild(achievementsButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: playButtonLayer)
            if playButton.contains(touchLocation) {
                animateExit({
                    if let scene = GameScene(fileNamed:"GameScene") {
                        
                        // Configure the view.
                        let skView = self.view as SKView!
                        /* Sprite Kit applies additional optimizations to improve rendering performance */
                        skView?.ignoresSiblingOrder = true
                        /* Set the scale mode to scale to fit the window */
                        scene.scaleMode = .aspectFill
                        skView?.presentScene(scene)
                    }
                })
            }
            else if settingsButton.contains(touchLocation) {
                animateExit({
                    if let scene = SettingsScene(fileNamed:"GameScene") {
                        
                        // Configure the view.
                        let skView = self.view as SKView!
                        /* Sprite Kit applies additional optimizations to improve rendering performance */
                        skView?.ignoresSiblingOrder = true
                        /* Set the scale mode to scale to fit the window */
                        scene.scaleMode = .aspectFill
                        skView?.presentScene(scene)
                    }
                })
            }
            
            else if achievementsButton.contains(touchLocation) {
                showLeaderOrAchievements(GKGameCenterViewControllerState.achievements)
            }
            
            else if shopButton.contains(touchLocation) {
                animateExit({
                    if let scene = ShopScene(fileNamed:"ShopScene") {
                        
                        // Configure the view.
                        let skView = self.view as SKView!
                        /* Sprite Kit applies additional optimizations to improve rendering performance */
                        skView?.ignoresSiblingOrder = true
                        /* Set the scale mode to scale to fit the window */
                        scene.scaleMode = .aspectFill
                        skView?.presentScene(scene)
                    }
                })
            }
        }
    }
    
    
    func showLeaderOrAchievements(_ state:GKGameCenterViewControllerState) {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        gKGCViewController.gameCenterDelegate = self
        
        gKGCViewController.viewState = GKGameCenterViewControllerState.achievements
        viewControllerVar?.present(gKGCViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}
