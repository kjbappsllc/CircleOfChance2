//
//  GameOver.swift
//  Circle of Chance
//
//  Created by Mac on 6/6/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit
import GameKit

class GameOver: SKScene, ChartboostDelegate {
    //layers
    let gameOverLayer = SKNode()
    var shadowBG = SKSpriteNode()
    
    //buttons
    var homeButton = SKSpriteNode()
    var replay = SKSpriteNode()
    var movieButton = SKSpriteNode()
    
    //Design
    var gameOverSign = SKSpriteNode()
    var coinsBox = SKSpriteNode()
    var coinsMade = Int()
    var currency = CurrencyManager()
    
    var score = SKLabelNode()
    var scoring = Int()
    
    var highscoreRect = SKSpriteNode()
    var highscoreTitle = SKLabelNode()
    var highscore = SKLabelNode()
    
    var coinsMadeNotifier = SKLabelNode()
    
    //GameCenter
    var gameCenterAchievements = [String:GKAchievement]()
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(gameOverLayer)
        Chartboost.setDelegate(self)
        
        loadView()
        
        if Chartboost.hasRewardedVideo(CBLocationGameOver) == false {
            print("caching")
            Chartboost.cacheRewardedVideo(CBLocationGameOver)
            let scale = SKAction.scale(to: 1.05, duration: 1.0)
            let scaleback = SKAction.scale(to: 1.0, duration: 1.0)
            let pulsing = SKAction.sequence([scale,scaleback])
            movieButton.run(SKAction.repeatForever(pulsing))
        }
        else {
            let scale = SKAction.scale(to: 1.05, duration: 1.0)
            let scaleback = SKAction.scale(to: 1.0, duration: 1.0)
            let pulsing = SKAction.sequence([scale,scaleback])
            movieButton.run(SKAction.repeatForever(pulsing))
        }

    }
    
    
    func loadView() {
        addBackground()
        addGameOver()
        
        currency.coins += coinsMade
        currency.totalCoins += coinsMade
        
        if currency.totalCoins >= 1000 {
            incrementCurrentPercentageOfAchievement("achievement_1000coins", amount: 100.0)
        }
        
        if currency.totalCoins >= 3000 {
            incrementCurrentPercentageOfAchievement("achievement_3000coins", amount: 100.0)
        }
        
        if currency.totalCoins >= 7000 {
            incrementCurrentPercentageOfAchievement("achievement_7000coins", amount: 100.0)
        }
        
        if currency.totalCoins >= 12000 {
            incrementCurrentPercentageOfAchievement("achievement_12000coins", amount: 100.0)
        }
        
    }
    
    //MARK: This function adds the background to the game
    func addBackground() {
        //Adds the colorful background
        
        let background = SKSpriteNode(imageNamed: "backGround")
        background.zPosition = layerPositions.background.rawValue
        self.addChild(background)
    }
    
    //MARK: This function adds the gameOver panel
    func addGameOver() {
        shadowBG = SKSpriteNode(imageNamed: "GameOverLayerBG")
        shadowBG.zPosition = layerPositions.background.rawValue + 1
        self.addChild(shadowBG)
        
        gameOverSign = SKSpriteNode(imageNamed: "GameOverBox")
        gameOverSign.position = CGPoint(x: 0, y: 35)
        gameOverSign.zPosition = layerPositions.topLayer.rawValue
        gameOverLayer.addChild(gameOverSign)
        
        //This is the box that contains the highscore an its text//
        ////////////////////////////////////////////////////////
        let highscoreBox = SKSpriteNode(imageNamed: "HighScoreBox")
        highscoreBox.position = CGPoint(x: 0, y: 220)
        highscoreBox.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(highscoreBox)
        
        let highestScore = UserDefaults.standard.integer(forKey: "highscore")
        highscore.text = "\(highestScore)"
        highscore.fontSize = 45.0
        highscore.fontName = "Grand Hotel"
        highscore.position = CGPoint(x: 8, y: -38)
        highscore.zPosition = layerPositions.topLayer.rawValue
        highscoreBox.addChild(highscore)
        
        ////////////////////////////////////////////////////////
        
        //This is the box that contains the score and its text//
        ///////////////////////////////////////////////////////
        let scoreBox = SKSpriteNode(imageNamed: "ScoreBox")
        scoreBox.position = CGPoint(x: 0, y: 28)
        scoreBox.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(scoreBox)
        
        scoring = self.userData?.object(forKey: "score") as! Int
        score.text = "\(scoring)"
        score.fontSize = 45.0
        score.fontName = "Grand Hotel"
        score.position = CGPoint(x: 8, y: -38)
        score.zPosition = layerPositions.topLayer.rawValue
        scoreBox.addChild(score)
        ///////////////////////////////////////////////////////
        
        //This is the containers that let the user know how much coins they earned//
        ///////////////////////////////////////////////////////////////////////////
        let coinsBox = SKSpriteNode(imageNamed: "coinsMade")
        coinsBox.position = CGPoint(x: 0, y: -164)
        coinsBox.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(coinsBox)
        
        if UserDefaults.standard.bool(forKey: "com.KJBApps.CircleOfChance.doublecoins") == false {
            coinsMade = scoring + (scoring/2)
            coinsMadeNotifier.fontName = "Grand Hotel"
            coinsMadeNotifier.fontSize = 45.0
            coinsMadeNotifier.position = CGPoint(x: 8, y: -26)
            coinsMadeNotifier.text = "\(coinsMade)"
            coinsMadeNotifier.zPosition = layerPositions.topLayer.rawValue
            coinsBox.addChild(coinsMadeNotifier)
            
            let pusleOut = SKAction.scale(to: 1.05, duration: 0.5)
            pusleOut.timingMode = .easeOut
            let pulseIn = SKAction.scale(to: 1.0, duration: 0.5)
            pulseIn.timingMode = .easeOut
            let loop = SKAction.sequence([pusleOut,pulseIn])
            loop.timingMode = .easeOut
            
            coinsMadeNotifier.run(SKAction.repeatForever(loop))
        }
            
        else if UserDefaults.standard.bool(forKey: "com.KJBApps.CircleOfChance.doublecoins") == true {
            coinsMade = (scoring + (scoring/2)) * 2
            coinsMadeNotifier.fontName = "Grand Hotel"
            coinsMadeNotifier.fontSize = 45.0
            coinsMadeNotifier.position = CGPoint(x: 8, y: -26)
            coinsMadeNotifier.text = "\(coinsMade)"
            coinsBox.addChild(coinsMadeNotifier)
            
            let doubleC = SKLabelNode()
            doubleC.fontName = "DayPosterBlack"
            doubleC.fontSize = 14.0
            doubleC.position = CGPoint(x: 8, y: -38)
            doubleC.fontColor = SKColor(red: 223/255, green: 147/255, blue: 0, alpha: 1.0)
            doubleC.text = "x2"
            self.addChild(doubleC)
        }
        ///////////////////////////////////////////////////////////////////////////
        
        //This is to bottom buttons//
        ////////////////////////////
        replay = SKSpriteNode(imageNamed: "restartButton")
        replay.position = CGPoint(x: -100, y: -330)
        replay.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(replay)
        
        movieButton = SKSpriteNode(imageNamed: "movieButton")
        movieButton.position = CGPoint(x: 100, y: -330)
        movieButton.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(movieButton)
        
        homeButton = SKSpriteNode(imageNamed: "homebutton")
        homeButton.position = CGPoint(x: -190, y: 350)
        homeButton.size = CGSize(width: 100, height: 100)
        homeButton.zPosition = layerPositions.textLayer.rawValue
        gameOverSign.addChild(homeButton)
        ////////////////////////////
    }
    
    //This function removes the gameover
    func removeGameOver(_ type: String, completion: @escaping () -> ()) {
        shadowBG.removeFromParent()
        if type == "replay" {
            let moveAction = SKAction.move(by: CGVector(dx: -size.width, dy:0) , duration: 0.3)
            let wait = SKAction.wait(forDuration: 0.35)
            moveAction.timingMode = .easeOut
            gameOverLayer.run(SKAction.sequence([moveAction,wait]), completion: completion)
        }
        else{
            let moveAction = SKAction.move(by: CGVector(dx: size.width, dy:0) , duration: 0.3)
            let wait = SKAction.wait(forDuration: 0.35)
            moveAction.timingMode = .easeOut
            gameOverLayer.run(SKAction.sequence([moveAction,wait]), completion: completion)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
            if replay.contains(touchLocation) {
               replay.alpha = 0.99

            }
            else if homeButton.contains(touchLocation) {
                homeButton.alpha = 0.99
            }
            
            else if movieButton.contains(touchLocation) {
                movieButton.alpha = 0.99
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
            if replay.contains(touchLocation) && replay.alpha != 1 {
                if let scene = GameScene(fileNamed:"GameScene") {
                    // Configure the view.
                    let skView = self.view as SKView!
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView?.ignoresSiblingOrder = true
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .aspectFill
                    removeGameOver("replay") {
                        skView?.presentScene(scene)
                    }
                }
                
            }
            else {
                replay.alpha = 1
            }
            
            if homeButton.contains(touchLocation) && homeButton.alpha != 1 {
                if let scene = MainMenu(fileNamed:"GameScene") {
                    
                    // Configure the view.
                    let skView = self.view as SKView!
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView?.ignoresSiblingOrder = true
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .aspectFill
                    removeGameOver("Home") {
                        skView?.presentScene(scene)
                    }
                }
            }
            else {
                homeButton.alpha = 1
            }
            
            if movieButton.contains(touchLocation) && movieButton.alpha != 1 {
                print("hmm.....")
                if Chartboost.hasRewardedVideo(CBLocationGameOver) {
                    print("works")
                    Chartboost.showRewardedVideo(CBLocationGameOver)
                }
                movieButton.alpha = 1
            }
            
            else {
                movieButton.alpha = 1
            }
            
        }
    }

    func didCompleteRewardedVideo(_ location: String!, withReward reward: Int32) {
        if location == CBLocationGameOver {
            currency.coins += Int(reward)
            coinsMade += Int(reward)
            Chartboost.cacheRewardedVideo(CBLocationGameOver)
        }
    }
    
    func didCloseRewardedVideo(_ location: String!) {
        if location == CBLocationGameOver {
            let scaleUp = SKAction.scale(to: 1.3, duration: 0.1)
            let scaleback = SKAction.scale(to: 1.0, duration: 0.1)

            
            coinsMadeNotifier.run(SKAction.sequence([scaleUp,changeFontAction(coinsMadeNotifier, color: UIColor.purple), scaleback, changeFontAction(coinsMadeNotifier, color: UIColor.white)]))
            
            coinsMadeNotifier.text = "\(coinsMade)"
            
            movieButton.run(SKAction.sequence([SKAction.scale(to: 0.0, duration: 0.3),SKAction.removeFromParent()]))
            let moveAction = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 0.3)
            moveAction.timingMode = .easeOut
            replay.run(moveAction)
        }
    }
    
    func loadAchievementPercentages() {
        
        GKAchievement.loadAchievements { (allAchievements, error) -> Void in
            
            if error != nil {
                print("GC could not load ach, error:\(error)")
            }
            else
            {
                //nil if no progress on any achiement
                if(allAchievements != nil) {
                    for theAchiement in allAchievements! {
                            
                        self.gameCenterAchievements[theAchiement.identifier!] = theAchiement
                    }
                }
                
                for(id,achievement) in self.gameCenterAchievements {
                    print("\(id) - \(achievement.percentComplete)")
                }
                
            }
        }
    }
    func incrementCurrentPercentageOfAchievement (_ identifier:String, amount:Double) {
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            
            var currentPercentFound:Bool = false
            
            if ( gameCenterAchievements.count != 0) {
                
                for (id,achievement) in gameCenterAchievements {
                    print(id)
                    if (id == identifier) {
                        //progress on the achievement found
                        currentPercentFound = true
                        
                        var currentPercent:Double = achievement.percentComplete
                        
                        currentPercent = currentPercent + amount
                        
                        reportAchievement(identifier,percentComplete:currentPercent)
                        
                        break
                    }
                }
            }
            
            if (currentPercentFound == false) {
                //no progress on the achievement
                print("no progress")
                reportAchievement(identifier,percentComplete:amount)
                
            }
        }
    }
    
    func reportAchievement (_ identifier:String, percentComplete:Double) {
        
        let achievement = GKAchievement(identifier: identifier)
        
        achievement.percentComplete = percentComplete
        achievement.showsCompletionBanner = true
        
        let achievementArray: [GKAchievement] = [achievement]
        
        GKAchievement.report(achievementArray, withCompletionHandler: {
            
            error -> Void in
            
            if ( error != nil) {
                print(error!)
            }
                
            else {
                
                print ("reported achievement with % complete of \(percentComplete)")
                
                self.loadAchievementPercentages()
            }
            
        })
    }
    
    func changeFontAction(_ label: SKLabelNode, color: UIColor) -> SKAction {
        return SKAction.run({ 
            label.fontColor = color
        })
    }
}
