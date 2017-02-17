//
//  GameScene.swift
//  Circle of Chance
//
//  Created by Mac on 6/6/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Layers
    fileprivate var gameLayer = SKNode()
    fileprivate var hudLayer = SKNode()
    fileprivate var pauseLayer = SKNode()
    fileprivate var cropLayer = SKCropNode()
    fileprivate var maskLayer = SKNode()
    
    //groupings
    fileprivate var dotsArray = [String]()
    fileprivate var effectsArray = [Effect]()
    fileprivate var barrierArray = [barrier]()
    
    //Gameplay
    fileprivate var gamePlayArea = SKSpriteNode()
    fileprivate var ballChar = Character()
    fileprivate var ball = SKSpriteNode()
    var shopSkin = items()
    fileprivate var star = StarIcon()
    fileprivate var pauseScreen = SKSpriteNode()
    fileprivate var multiplier = SKSpriteNode()
    fileprivate var multiplyText = SKLabelNode()
    fileprivate var mulitplyCounter = 1
    
    //barriers
    var barrier1 = barrier()
    var barrier2 = barrier()
    var barrier3 = barrier()
    var barrier4 = barrier()
    var barrier5 = barrier()
    var barrier6 = barrier()
    
    //effects
    fileprivate let motionEffect = Effect(active: false, effecttype: EffectType.motion)
    fileprivate let fluctuateEffect = Effect(active: false, effecttype: EffectType.fluctuate)
    fileprivate let ghostEffect = Effect(active: false, effecttype: EffectType.ghost)
    fileprivate let hasteEffect = Effect(active: false, effecttype: EffectType.haste)
    fileprivate let unstableEffect = Effect(active: false, effecttype: EffectType.unstable)
    fileprivate let shakeEffect = Effect(active: false, effecttype: EffectType.shake)
    fileprivate var effectSprite = SKSpriteNode()
    
    //HUD
    var topBar = SKSpriteNode()
    var pause = SKSpriteNode()
    let levelText = SKLabelNode()
    var levelInt = 1
    var scoreText = SKLabelNode()
    var score = SKLabelNode()
    
    //PauseLayer
    var homeButton = SKSpriteNode()
    var pausePlayButton = SKSpriteNode()
    var pauseSound = SKSpriteNode()
    var pauseMusic = SKSpriteNode()
    
    //HighScore
    var highscoreInt = Int()
    var highscore = SKLabelNode()
    var scoreInt = Int()
    var newHighScore = SKLabelNode()
    
    //GameLogic
    var Path = UIBezierPath()
    var movingClockWise = Bool()
    var gameStarted = Bool()
    var isGameOver = false
    var IsPaused = false
    var barriersReversed = Bool()
    var highScoreAchieved = Bool()
    var checkpoint = Bool()
    var currency = CurrencyManager()
    var starHit = SKSpriteNode()
    
    
    
    //GameCenter
    var gameCenterAchievements = [String:GKAchievement]()
    
    override func didMove(to view: SKView) {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(gameLayer)
        addChild(hudLayer)
        
        //Adds the cropLayer to the Scene and masks the middle area
        gameLayer.addChild(cropLayer)
        maskLayer.position = CGPoint(x: 0, y: -50)
        let maskinglayer = SKSpriteNode(imageNamed: "cropLayer")
        maskLayer.addChild(maskinglayer)
        cropLayer.maskNode = maskLayer
        cropLayer.zPosition = layerPositions.maskLayer.rawValue
        effectSprite.zPosition = layerPositions.maskLayer.rawValue
        effectSprite = SKSpriteNode(imageNamed: "fluctuate")
        cropLayer.addChild(effectSprite)
        
        effectSprite.position = CGPoint(x: 120, y: -50)
        
        //Pre set properties
        gameLayer.isHidden = true
        hudLayer.isHidden = true
        ball.isHidden = true
        effectSprite.isHidden = true
        barriersReversed = false
        checkpoint = false
        highScoreAchieved = false
        dotsArray.removeAll()
        
        //Initializes the barrierArray to add all the barriers
        barrierArray = [barrier1,barrier2,barrier5,barrier3,barrier6,barrier4]
        
        //Intializes the effects array to add all of the effects
        effectsArray = [motionEffect,fluctuateEffect, hasteEffect, ghostEffect, unstableEffect,shakeEffect]
        
        //Loads the Achievements from gameCenter
        loadAchievementPercentages()
        loadView()
        
        // add physics world
        physicsWorld.contactDelegate = self

    }
    
    //loads view
    func loadView() {
        //Sets Up the Scene
        
        isUserInteractionEnabled = false
        
        //Adds all the necessary stuff
        addBackground()
        addGamePlayArea()
        addHud()
        
        animateBeginGame {
            
            //Adds the barriers and the ball after the game begins
            self.addBarriers()
            self.MoveBarriers()
            self.addBall({
                self.isUserInteractionEnabled = true
            })
        }
        
    }
    
    //MARK: This function adds the background to the game
    func addBackground() {
        //Adds the colorful background
        
        let background = SKSpriteNode(imageNamed: "backGround")
        background.zPosition = layerPositions.background.rawValue
        self.addChild(background)
    }
    
    //MARK:This function adds the gameplay area including the dots and the barriers
    func addGamePlayArea() {
        //Adds the outside area where the game will be played
        
        gamePlayArea = SKSpriteNode(imageNamed: "PlayingArea")
        gamePlayArea.zPosition = layerPositions.gamePlayArea.rawValue
        gamePlayArea.position = CGPoint(x: 0, y: OFFSET)
        gameLayer.addChild(gamePlayArea)
        
        //Adds the Dots for the beginning of the game
        addScoreUnits()
        
        //Adds the muliplier to the game
        multiplier = SKSpriteNode(imageNamed: "Multiplier")
        multiplier.position = CGPoint(x: -260, y: -460)
        multiplier.zPosition = layerPositions.gamePlayArea.rawValue
        
        multiplyText.text = "1"
        multiplyText.fontName = "Grand Hotel"
        multiplyText.fontSize = 45.0
        multiplyText.position = CGPoint(x: 30, y: -30)
        multiplyText.zPosition = 40
        
        self.addChild(multiplier)
        multiplier.addChild(multiplyText)
        
    }
    
    //Mark: This function ads the hud
    func addHud() {
        
        //Adds the top bar area
        topBar = SKSpriteNode(imageNamed: "topBar")
        topBar.zPosition = layerPositions.topLayer.rawValue
        topBar.position = CGPoint(x: 0, y: (self.frame.height/2) - topBar.frame.height/2)
        hudLayer.addChild(topBar)
        
        //Adds the pause button
        pause = SKSpriteNode(imageNamed: "PauseButton")
        pause.zPosition = layerPositions.topLayer.rawValue
        pause.position = CGPoint(x: 245, y: 15)
        topBar.addChild(pause)
        
        //Adds the text that goes inside the top bar circle
        levelText.text = "\(levelInt)"
        levelText.fontName = "Grand Hotel"
        levelText.position = CGPoint(x: 0, y: -5)
        levelText.zPosition = layerPositions.textLayer.rawValue
        levelText.fontSize = 96.0
        topBar.addChild(levelText)
        
        
        //Adds the text "Score"
        scoreText.text = "Score:"
        scoreText.fontName = "Bodoni 72 Smallcaps"
        scoreText.position = CGPoint(x: -260, y: 0)
        scoreText.fontSize = 46.0
        scoreText.zPosition = layerPositions.textLayer.rawValue
        topBar.addChild(scoreText)
        
        //Adds the players score that is initialized to zero
        score.text = "0"
        score.fontName = "Bodoni 72 Smallcaps"
        score.position = CGPoint(x: -260, y: -45)
        score.fontSize = 46.0
        score.zPosition = layerPositions.textLayer.rawValue
        topBar.addChild(score)
        
    }
    
    //Mark: This animates the beginning of the game
    func animateBeginGame(_ completion_: @escaping () -> ()) {
        
        //Animates the gameLayer
        gameLayer.isHidden = false
        gameLayer.position = CGPoint(x: size.width, y: 0)
        let gameLayerMove = SKAction.move(by: CGVector(dx: -size.width, dy: 0), duration: 0.3)
        gameLayerMove.timingMode = .easeOut
        gameLayer.run(gameLayerMove)
        
        //Animates the hudlayer
        hudLayer.isHidden = false
        hudLayer.position = CGPoint(x: 0, y: size.height)
        let hudAction = SKAction.move(by: CGVector(dx: 0, dy: -size.height), duration: 0.5)
        hudAction.timingMode = .easeOut
        
        //Animates the multiplier on screen
        multiplier.position = CGPoint(x: multiplier.position.x - 400, y: multiplier.position.y)
        let multiplierAction = SKAction.move(by: CGVector(dx: 400, dy: 0), duration: 0.3)
        
        multiplier.run(multiplierAction)
        hudLayer.run(hudAction, completion: completion_)
    }
    
    //Mark: This function animates the end of the game when the character hits the barrier or when the home button is pressed during the pause screen.
    func animateEndGame(_ completion: @escaping () -> ()) {

        let gameLayerMove = SKAction.move(by: CGVector(dx: size.width, dy:0), duration: 0.3)
        
        gameLayerMove.timingMode = .easeIn
        
        let hudAction = SKAction.move(by: CGVector(dx: 0, dy: size.height), duration: 0.5)
        
        hudAction.timingMode = .easeIn
        
        let multiplierAction = SKAction.move(by: CGVector(dx: -400, dy: 0), duration: 0.3)
        
        gameLayer.run(gameLayerMove)
        multiplier.run(multiplierAction)
        hudLayer.run(hudAction, completion: completion)
    }
    
    //MARK: THIS function adds the barriers to the gameplay area
    func addBarriers() {
        barrier1.position = CGPoint(x: 0, y: 210)
        barrier1.zPosition = layerPositions.barriers.rawValue
        barrier1.zRotation = CGFloat(M_PI / 2)
        gamePlayArea.addChild(barrier1)
        barrier1.addRedBarrier()
        
        barrier2.position = CGPoint(x: 0, y: -122.5)
        barrier2.zPosition = layerPositions.barriers.rawValue
        barrier2.zRotation = CGFloat(3*M_PI / 2)
        gamePlayArea.addChild(barrier2)
        
        barrier5.position = CGPoint(x: -140, y: 135)
        barrier5.zPosition = layerPositions.barriers.rawValue
        barrier5.zRotation = CGFloat(5*M_PI / 6)
        gamePlayArea.addChild(barrier5)
        
        barrier3.position = CGPoint(x: 145.5, y: -40)
        barrier3.zPosition = layerPositions.barriers.rawValue
        barrier3.zRotation = CGFloat(11 * M_PI / 6)
        gamePlayArea.addChild(barrier3)
        
        barrier6.position = CGPoint(x: 140, y: 135)
        barrier6.zPosition = layerPositions.barriers.rawValue
        barrier6.zRotation = CGFloat(M_PI / 6)
        gamePlayArea.addChild(barrier6)
        
        barrier4.position = CGPoint(x: -145.5, y: -40)
        barrier4.zPosition = layerPositions.barriers.rawValue
        barrier4.zRotation = CGFloat(7 * M_PI / 6)
        gamePlayArea.addChild(barrier4)
    }
    
    //MARK: This function moves the barriers at the start of the game
    func MoveBarriers(){
        for barrier in barrierArray {
            let dx = barrier.position.x
            let dy = barrier.position.y - 45
            
            let rad = atan2(dy, dx)
            let Path3 = UIBezierPath(arcCenter: CGPoint(x: 0, y: 45), radius: 165, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
            
            let follow = SKAction.follow(Path3.cgPath, asOffset: false, orientToPath: true, speed: barrier.GetBarrierSpeed())
            barrier.run(SKAction.repeatForever(follow), withKey: "Moving")
        }
    }
    
    //Mark: This function moves the barriers in the opposite direction
    func ReversedMoveBarriers() {
        for barrier in barrierArray {
            let dx = barrier.position.x
            let dy = barrier.position.y - 45
            let rad = atan2(dy,dx)
            let Path3 = UIBezierPath(arcCenter: CGPoint(x: 0, y: 45), radius: 165, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
            
            let follow = SKAction.follow(Path3.cgPath, asOffset: false, orientToPath: true, speed: barrier.GetBarrierSpeed())
            barrier.run(SKAction.repeatForever(follow).reversed(), withKey: "Moving")
        }
    }
    
    //MARK: This function adds the dots to the gamePlay area
    func addScoreUnits() {
        
        //The constants
        let randomNum = Int(arc4random_uniform(15) + 1)
        let radius: CGFloat = CONSTANTRADIUS
        let numberOfCircle = NUMBEROFCIRCLES
        var added = false
        for i in 1...numberOfCircle {
            if (checkpoint != true) || (checkpoint == true && added == true) {
                //Physics body
                let circle = SKSpriteNode(imageNamed: "scoreDotYellow")
                circle.alpha = 0
                circle.physicsBody = nil
                
                if levelInt % 2 == 0 {
                    circle.texture = SKTexture(imageNamed: "scoreDotYellow")
                }
                else {
                    circle.texture = SKTexture(imageNamed: "scoreDotWhite")
                }
                
                // You can get every single circle by name:
                circle.name = String(format:"circle%d",i)
                dotsArray.append(circle.name!)
                let angle = 2 * M_PI / Double(numberOfCircle) * Double(i)
                
                let initialPosition = CGPoint(x:0, y:50)
                
                let circleX = radius * cos(CGFloat(angle))
                let circleY = radius * sin(CGFloat(angle))
                let finalPosition = CGPoint(x:circleX - gamePlayArea.position.x / 2, y:circleY - gamePlayArea.position.y / 2 - 10)
                
                circle.position = initialPosition
                circle.zPosition = layerPositions.dots.rawValue
                
                gamePlayArea.addChild(circle)
                animateDot(circle, location: finalPosition) {
                    circle.physicsBody = SKPhysicsBody(circleOfRadius: 2.5)
                    circle.physicsBody?.categoryBitMask = dotCategory
                    circle.physicsBody?.contactTestBitMask = ballCategory
                    circle.physicsBody?.affectedByGravity = false
                    circle.physicsBody?.isDynamic = false
                    
                }
            }
                
            else if checkpoint == true && added == false {
                if i == randomNum {
                    let star = StarIcon()
                    star.physicsBody = nil
                    star.name = "Star"
                    dotsArray.append("Star")
                    
                    let angle = 2 * M_PI / Double(numberOfCircle) * Double(i)
 
                    let initialPosition = CGPoint(x:0, y:50)
                    
                    let circleX = radius * cos(CGFloat(angle))
                    let circleY = radius * sin(CGFloat(angle))
                    
                    let finalPosition = CGPoint(x:circleX - gamePlayArea.position.x / 2, y:circleY - gamePlayArea.position.y / 2 - 10)
                    
                    star.position = initialPosition
                    
                    star.zPosition = layerPositions.dots.rawValue
                    
                    gamePlayArea.addChild(star)
                    animateDot(star, location: finalPosition){
                        star.LoadPhysics()
                    }
                    star.animateStar()
                    added = true
                }
                else {
                    let circle = SKSpriteNode(imageNamed: "scoreDotYellow")
                    circle.alpha = 0
                    circle.physicsBody = nil
                
                    if levelInt % 2 == 0 {
                        circle.texture = SKTexture(imageNamed: "scoreDotYellow")
                    }
                    else {
                        circle.texture = SKTexture(imageNamed: "scoreDotWhite")
                    }
                    
                    // You can get every single circle by name:
                    circle.name = String(format:"circle%d",i)
                    dotsArray.append(circle.name!)
                    let angle = 2 * M_PI / Double(numberOfCircle) * Double(i)
                    
                    let initialPosition = CGPoint(x:0, y:50)
                    
                    let circleX = radius * cos(CGFloat(angle))
                    let circleY = radius * sin(CGFloat(angle))
                    let finalPosition = CGPoint(x:circleX - gamePlayArea.position.x / 2, y:circleY - gamePlayArea.position.y / 2 - 10)
                    
                    circle.position = initialPosition
                    circle.zPosition = layerPositions.dots.rawValue
                    
                    gamePlayArea.addChild(circle)
                    animateDot(circle, location: finalPosition) {
                        circle.physicsBody = SKPhysicsBody(circleOfRadius: 2.5)
                        circle.physicsBody?.categoryBitMask = dotCategory
                        circle.physicsBody?.contactTestBitMask = ballCategory
                        circle.physicsBody?.affectedByGravity = false
                        circle.physicsBody?.isDynamic = false
                        
                    }
                }
            }
        }
    }
    
    //MARK: This is to animate the dots into view
    func animateDot(_ circle: SKSpriteNode, location: CGPoint, completion: @escaping () -> ()) {
        let moveAction = SKAction.move(to: location, duration: 0.7)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        moveAction.timingMode = .easeOut
        circle.run(SKAction.group([moveAction,fadeIn]), completion: completion)
    }
    
    //Mark: This Function adds the ball onto the area
    func addBall(_ completion: @escaping () -> ()) {
        ball = shopSkin.current.sprite
        ball.physicsBody = ballChar.loadPhysics()
        ball.size = ballChar.size
        ball.position = CGPoint(x: -40, y: 45)
        ball.zPosition = layerPositions.character.rawValue
        ball.isHidden = false
        gamePlayArea.addChild(ball)
        
        let moveAction = SKAction.move(by: CGVector(dx: 80, dy: 0), duration: 0.7)
        let wait = SKAction.wait(forDuration: 0.1)
        
        moveAction.timingMode = .easeOut
        
        ball.run(SKAction.repeatForever(SKAction.sequence([moveAction, wait, moveAction.reversed(), wait])), withKey: "moveAction")
        
        ball.run(SKAction.wait(forDuration: 0.0), completion: completion)
        
    }
    
    //Mark: Moves the ball counter clockwise
    func moveCounterClockWise(){
        let dx = ball.position.x
        let dy = ball.position.y - 45
        
        let rad = atan2(dy,dx)
        Path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 45), radius: 165, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
        
        let follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: false, speed: ballChar.getballSpeedCounterClockWise())
        ball.run(SKAction.repeatForever(follow))
        
    }
    
    //Mark: moves the ball Clockwise
    func moveClockWise() {
        let dx = ball.position.x
        let dy = ball.position.y - 45
        
        let rad = atan2(dy,dx)
        Path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 45), radius: 165, startAngle: rad, endAngle: rad+CGFloat(M_PI*4), clockwise: true)
        
        let follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: false, speed: ballChar.getballSpeedClockWise())
        ball.run(SKAction.repeatForever(follow).reversed())
    }
    
    

    //Mark: Executed When there is contact with the dots or the star
    // create a random percent, with a precision of one decimal place
    func randomPercent() -> Double {
        return Double(arc4random() % 1000) / 10.0;
    }
    
    //Mark: Checks to see whether or not there is a need to update the achievements
    func updatePointAchievements() {
        
        if scoreInt == 300 {
            self.incrementCurrentPercentageOfAchievement("achievement_300points", amount: 100.0)
        }
        
        if scoreInt == 800 {
            self.incrementCurrentPercentageOfAchievement("achievement_800points", amount: 100.0)
        }
        
        if scoreInt >= 1500 {
            self.incrementCurrentPercentageOfAchievement("achievement_1500points", amount: 100.0)
        }
        
        if scoreInt >= 3000 {
            self.incrementCurrentPercentageOfAchievement("achievement_3000points", amount: 100.0)
        }
    }
    
    //Mark: This function checks to see whether or not the player should go to the next level
    func handleNewLevel() {
        //If the there are no dots in play do this
        if dotsArray.count <= 0{
            
            let randomChance = arc4random_uniform(100)
            
            //Checks and sees whether or not between each level the barriers will reverse
            if randomChance < 70 {
                if barriersReversed == false{
                    ReversedMoveBarriers()
                    barriersReversed = true
                }
                else{
                    MoveBarriers()
                    barriersReversed = false
                }
            }
            
            //When their are no dots the level increase and check whether or not their should be a checkpoint
            levelInt += 1
            levelText.text = "\(levelInt)"
            
            let scale = SKAction.scale(to: 1.4, duration: 0.3)
            let scaleBack = SKAction.scale(to: 1.0, duration: 0.3)
            levelText.run(SKAction.sequence([scale, scaleBack]))
            
            if levelInt % 5 == 0 {
                checkpoint = true
            }
            else {
                checkpoint = false
            }
            
            //Adds the score units back into play for the next level
            addScoreUnits()
            
            
            //Checks to see whether or not to add more speed to the ball based on whether the effect "Motion" is up
            if ballChar.getballSpeedClockWise() < 350 && motionEffect.isActive == false{
                ballChar.AddBallSpeedClockWise(3)
                ballChar.AddBallSpeedCounterClockWise(3)
            }
            
            //Adds the new level in the beginning of every other level the level
            if levelInt % 2 == 1 {
                for barrier in barrierArray {
                    if barrier.isActive == false {
                        barrier.addRedBarrier()
                        break
                    }
                }
            }
            
            if levelInt % 3 == 0 {
                effectsArray.shuffleInPlace()
                for effect in effectsArray {
                    if effect.isActive == false {
                        switch effect.effectType {
                            
                        case .motion:
                            effectSprite.isHidden = false
                            let move = SKAction.move(by: CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .easeOut
                            
                            let resizing = SKAction.scale(to: 1.2, duration: 0.5)
                            let scaleback = SKAction.scale(to: 1.0, duration: 0.5)
                            let wait = SKAction.wait(forDuration: 1.0)
                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            
                            effectSprite.texture = SKTexture(imageNamed: "motion")
                            
                            IrregularMotion()
                            effect.isActive = true
                            
                            effectSprite.run(SKAction.sequence([move,resizeAction,move.reversed()]), completion: {
                                self.effectSprite.isHidden = true
                            })
                            
                        case .fluctuate:
                            
                            effectSprite.isHidden = false
                            let move = SKAction.move(by: CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .easeOut
                            
                            let resizing = SKAction.scale(to: 1.2, duration: 0.5)
                            let scaleback = SKAction.scale(to: 1.0, duration: 0.5)
                            let wait = SKAction.wait(forDuration: 1.0)
                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            effectSprite.texture = SKTexture(imageNamed: "fluctuate")
                            fluctuateBall()
                            effect.isActive = true
                            
                            effectSprite.run(SKAction.sequence([move,resizeAction,move.reversed()]), completion: {
                                self.effectSprite.isHidden = true
                            })
                            
                        case .haste:
                            effectSprite.isHidden = false
                            let move = SKAction.move(by: CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .easeOut
                            
                            let resizing = SKAction.scale(to: 1.2, duration: 0.5)
                            let scaleback = SKAction.scale(to: 1.0, duration: 0.5)
                            let wait = SKAction.wait(forDuration: 1.0)
                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            
                            effectSprite.texture = SKTexture(imageNamed: "haste")
                            Haste()
                            effect.isActive = true
                            
                            effectSprite.run(SKAction.sequence([move,resizeAction,move.reversed()]), completion: {
                                self.effectSprite.isHidden = true
                            })
                            
 
                        case .unstable:
                            effectSprite.isHidden = false
                            let move = SKAction.move(by: CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .easeOut
                            
                            let resizing = SKAction.scale(to: 1.2, duration: 0.5)
                            let scaleback = SKAction.scale(to: 1.0, duration: 0.5)
                            let wait = SKAction.wait(forDuration: 1.0)

                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            
                            effectSprite.texture = SKTexture(imageNamed: "unstable")
                            FluctuateBarriers()
                            effect.isActive = true
                            

                            effectSprite.run(SKAction.sequence([move,resizeAction,move.reversed()]), completion: {
                                self.effectSprite.isHidden = true
                            })
                            
 
                        case .ghost:
                            effectSprite.isHidden = false
                            let move = SKAction.move(by: CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .easeOut
                            let resizing = SKAction.scale(to: 1.2, duration: 0.5)
                            let scaleback = SKAction.scale(to: 1.0, duration: 0.5)
                            let wait = SKAction.wait(forDuration: 1.0)
                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            effectSprite.texture = SKTexture(imageNamed: "ghost")
                            Ghost()
                            effect.isActive = true
                            
                            effectSprite.run(SKAction.sequence([move,resizeAction,move.reversed()]), completion: {
                                self.effectSprite.isHidden = true
                            })
                            
                        case .shake:
                            
                            effectSprite.isHidden = false
                            let move = SKAction.move(by: CGVector(dx: -120, dy: 0), duration: 0.2)
                            move.timingMode = .easeOut
                            let resizing = SKAction.scale(to: 1.2, duration: 0.5)
                            let scaleback = SKAction.scale(to: 1.0, duration: 0.5)
                            let wait = SKAction.wait(forDuration: 1.0)
                            
                            let resizeAction = SKAction.sequence([resizing,scaleback,wait])
                            effectSprite.texture = SKTexture(imageNamed: "shake")
                            Shake()
                            effect.isActive = true
                            
                            effectSprite.run(SKAction.sequence([move,resizeAction,move.reversed()]), completion: {
                                self.effectSprite.isHidden = true
                            })
 
                        }
                        break
                    }
                }
            }
        }
    }


    //Mark: Adds the particles when the barrier breaks
    func addBarrierBreakParticles(_ bar: barrier) {
        let particles = SKEmitterNode(fileNamed: "BarrierBreak")!
        particles.position = bar.position
        particles.zPosition = bar.zPosition + 1
        self.addChild(particles)
        bar.removeBarrier()
        
        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
    }
    
    //Mark: This function handles the logic for when the star is hit
    func handleStarPickup(_ node:SKNode) {
        if node.name == "Star" {
            
            let moveR = SKAction.move(by: CGVector(dx: 10, dy:0), duration: 0.15)
            let moveL = SKAction.move(by: CGVector(dx: -20, dy:0), duration: 0.3)
            
            mulitplyCounter += 1
            multiplyText.text = "\(mulitplyCounter)"
            
            multiplyText.run(SKAction.sequence([moveR,moveL,moveL.reversed(),moveR.reversed()]))
            
            let randomNum = self.randomPercent()
            
            if levelInt < 15 {
                switch randomNum {
                    
                case 0..<90:
                    var limit = 0
                    for barriers in self.barrierArray {
                        if limit != 1 {
                            if barriers.isActive {
                                
                                addBarrierBreakParticles(barriers)
                                
                                limit += 1
                            }
                        }
                    }
                    
                default:
                    var limit = 0
                    for barriers in self.barrierArray {
                        if limit != 2 {
                            if barriers.isActive {
                                
                                addBarrierBreakParticles(barriers)
                                
                                limit += 1
                            }
                        }
                    }
                }
            }
            else {
                switch randomNum {
                    
                case 0..<90:
                    var limit = 0
                    for barriers in self.barrierArray {
                        if limit != 3 {
                            if barriers.isActive {
                                
                                addBarrierBreakParticles(barriers)
                                
                                limit += 1
                            }
                        }
                    }
                    
                default:
                    var limit = 0
                    for barriers in self.barrierArray {
                        if limit != 4 {
                            if barriers.isActive {
                                
                                addBarrierBreakParticles(barriers)
                                
                                limit += 1
                            }
                        }
                    }
                }
            }
        }

    }
    
    //Mark: This is an auxiliary function that does action when the ball hits the dots or the star
    func handleScoreUnitContact(_ node: SKNode) {
        node.physicsBody = nil
        node.run(SKAction.removeFromParent())
        
        for (index,value) in self.dotsArray.enumerated() {
            if node.name == value {
                
                self.dotsArray.remove(at: index)
                scoreInt += 1 * mulitplyCounter
                self.score.text = "\(scoreInt)"
                self.updatePointAchievements()
                let highscore = UserDefaults.standard.integer(forKey: "highscore")
                if scoreInt > highscore {
                    UserDefaults.standard.set(scoreInt, forKey: "highscore")
                }
                
                self.handleStarPickup(node)
                self.handleNewLevel()
            }
        }
        
        
    }
    
    // Mark: Lets me know when there is contact
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == ballCategory && (secondBody.categoryBitMask == dotCategory || secondBody.categoryBitMask == starCategory) {
            
            handleScoreUnitContact(secondBody.node!)
            
        }
            
        else if (firstBody.categoryBitMask == ballCategory || firstBody.categoryBitMask == ghostBallCategory) && secondBody.categoryBitMask == redBarrierCategory {
            
            gameOver(firstBody.node!)
        }
    }
    
    
    //Mark: This function is called when the player hits the barrier and the game is over
    func gameOver(_ node: SKNode) {
        
        currency.games += 1
        
        if currency.games == 50 {
        
            incrementCurrentPercentageOfAchievement("achievement_50games", amount: 100.0)
            currency.coins += 75
        }
        
        if currency.games == 100 {
            incrementCurrentPercentageOfAchievement("achievement_100games", amount: 100.0)
            currency.coins += 75
        }
        
        if currency.games == 200 {
            incrementCurrentPercentageOfAchievement("achievement_200games", amount: 100.0)
            currency.coins += 75
        }
        
        if currency.games == 500 {
            incrementCurrentPercentageOfAchievement("achievement_500games", amount: 100.0)
            currency.coins += 75
        }
        
        if highscoreInt == scoreInt {
            saveHighscore(highscoreInt)
        }
        
        dotsArray.removeAll()
        gameStarted = false
        isGameOver = true
        for barrier in barrierArray{
            barrier.removeAllActions()
        }
        
        ball.removeAllActions()
        
        let action1 = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.1)
        let action2 = SKAction.colorize(with: scene!.backgroundColor, colorBlendFactor: 1.0, duration: 0.1)
        self.scene?.run(SKAction.sequence([action1,action2]))
        
        let particles = SKEmitterNode(fileNamed: "GameOver")!
        particles.particlePosition = ball.position
        particles.zPosition = layerPositions.barriers.rawValue + 1
        gamePlayArea.addChild(particles)
        
        ball.removeFromParent()

        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]), completion: {
            self.animateEndGame({
                if let scene = GameOver(fileNamed:"GameScene") {
                    
                    // Configure the view.
                    let skView = self.view as SKView!
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView?.ignoresSiblingOrder = true
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .aspectFill
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(self.scoreInt, forKey: "score" as NSCopying)
                    skView?.presentScene(scene)
                }
            })
        }) 
    }
    
    //An effect that changes the motion of the ball
    func IrregularMotion() {
        ballChar.SetBallSpeedClockWise(350)
        ballChar.SetBallSpeedCounterClockWise(130)
    }
    
    //An effect that changes the size of the ball
    func fluctuateBall(){
        let scale = SKAction.scale(to: 1.0, duration: 0.3)
        let scaleUp = SKAction.scale(to: 1.35, duration: 0.3)
        let scaling = SKAction.sequence([scaleUp,scale])
        let scalingCycle = SKAction.repeatForever(scaling)
        ball.run(scalingCycle, withKey: "fluctuate")
    }
    
    //An effect that changes the visibility of the ball
    func Ghost() {
        let fade = SKAction.fadeAlpha(to: 0.5, duration: 0.0)
        let fadeBack = SKAction.fadeAlpha(to: 1.0, duration: 0.0)
        let cycle = SKAction.sequence([fade,SKAction.wait(forDuration: 0.5),fadeBack,SKAction.wait(forDuration: 2.0)])
        
        ball.run(SKAction.repeatForever(cycle))
    }
    
    //An effect that changes the speed of the barriers
    func Haste() {
        for bar in barrierArray {
            let speed = SKAction.speed(to: 1.45, duration: 0.1)
            let slow = SKAction.speed(by: 0.3, duration: 0.1)
            let wait = SKAction.wait(forDuration: 1.3)
            bar.run(SKAction.repeatForever(SKAction.sequence([slow,wait,speed,wait])))
        }
    }
    
    //An effect that changes the size of the barriers
    func FluctuateBarriers(){
        let scaler = SKAction.scaleY(to: 1.5, duration: 0.5)
        let scaleback = SKAction.scaleY(to: 1.0, duration: 0.5)
        let cycle = SKAction.sequence([scaler,SKAction.wait(forDuration: 0.5),scaleback,SKAction.wait(forDuration: 1.0)])
        for barrier in barrierArray{
            barrier.run(SKAction.repeatForever(cycle), withKey: "barrierfluctuation")
        }
    }
    
    //An effect that shakes the area
    func Shake() {
        let moveR = SKAction.move(by: CGVector(dx: -25, dy: 0), duration: 0.2)
        let moveU = SKAction.move(by: CGVector(dx: 0, dy: 25), duration: 0.2)
        let wait = SKAction.wait(forDuration: 0.1)
        
        moveR.timingMode = .easeOut
        moveU.timingMode = .easeOut
        
        let moveHorizonalActionL = SKAction.sequence([moveR,wait,moveR.reversed(),wait])
        let moveVerticalActionU = SKAction.sequence([moveU,wait,moveU.reversed(),wait])
        
        let moveHorizonalActionR = SKAction.sequence([moveR.reversed(),wait,moveR,wait])
        let moveVerticalActionD = SKAction.sequence([moveU.reversed(),wait,moveU,wait])
        
        let shakeAction = SKAction.sequence([moveHorizonalActionL, moveVerticalActionU, moveHorizonalActionR,moveVerticalActionD])
        
        gameLayer.run(SKAction.repeatForever(shakeAction))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        var node = SKNode()
        if let touch = touches.first {
            let pos = touch.location(in: topBar)
            node = topBar.atPoint(pos)
        }
        if gameStarted == false && IsPaused == false && node != pause{
            self.scene?.isUserInteractionEnabled = false
            
            if ball.position.x > gamePlayArea.position.x {
                ball.removeAllActions()
                let move = SKAction.move(by: CGVector(dx: CONSTANTRADIUS - ball.position.x, dy: 0), duration: 0.4)
                move.timingMode = .easeIn
                ball.run(move, completion: {
                    SKAction.wait(forDuration: 0.3)
                    self.moveCounterClockWise()
                    self.gameStarted = true
                    self.scene?.isUserInteractionEnabled = true
                })
            }
            else {
                ball.removeAllActions()
                let move = SKAction.move(by: CGVector(dx: -CONSTANTRADIUS - ball.position.x, dy: 0), duration: 0.4)
                move.timingMode = .easeIn
                ball.run(move, completion: {
                    SKAction.wait(forDuration: 0.3)
                    self.moveClockWise()
                    self.gameStarted = true
                    self.scene?.isUserInteractionEnabled = true
                })
            }
            
        }
        else if gameStarted == true && IsPaused == false && node != pause {
            
            if movingClockWise == true && IsPaused == false {
                moveCounterClockWise()
                movingClockWise = false
            }
            else if movingClockWise == false && IsPaused == false {
                moveClockWise()
                movingClockWise = true
            }
        }
        pause(touches)

    }
    
    //Mark: This function is called when the pause button is pressed
    func pause(_ touches: Set<UITouch>) {
        
        if let touch = touches.first as UITouch! {
            let pos = touch.location(in: topBar)
            let node = topBar.atPoint(pos)
            
            let loc = touch.location(in: pauseLayer)
            
            if node == pause && IsPaused == false {
                self.addChild(pauseLayer)
                pauseScreen = SKSpriteNode(imageNamed: "pauseLayer")
                pauseScreen.zPosition = 100
                pauseLayer.addChild(pauseScreen)
                
                homeButton = SKSpriteNode(imageNamed: "homebutton")
                homeButton.position = CGPoint(x: -240, y: 440)
                homeButton.zPosition = 150
                
                pausePlayButton = SKSpriteNode(imageNamed: "playButton")
                pausePlayButton.position = CGPoint(x: 0, y: -60)
                pausePlayButton.zPosition = 150
                
                pauseMusic = SKSpriteNode(imageNamed: "pauseMusic")
                pauseMusic.position = CGPoint(x: -100, y: -250)
                pauseMusic.zPosition = 150
                
                if AudioManager.sharedInstance().BackgroundisPlaying == false {
                    pauseMusic.alpha = 0.66
                }
                
                pauseSound = SKSpriteNode(imageNamed: "pauseSound")
                pauseSound.position = CGPoint(x: 100, y: -250)
                pauseSound.zPosition = 150
                
                if AudioManager.sharedInstance().SoundisPlaying == false {
                    pauseSound.alpha = 0.66
                }
                
                pauseLayer.addChild(pausePlayButton)
                pauseLayer.addChild(homeButton)
                pauseLayer.addChild(pauseMusic)
                pauseLayer.addChild(pauseSound)
                self.scene?.isPaused = true
                IsPaused = true
            }
            
            if IsPaused == true && pausePlayButton.contains(loc) {
                for children in pauseLayer.children {
                    children.removeFromParent()
                }
                pauseLayer.removeFromParent()
                self.scene?.isPaused = false
                IsPaused = false
                
            }
            
            if IsPaused == true && pauseMusic.contains(loc) {
                if AudioManager.sharedInstance().BackgroundisPlaying == false {
                    AudioManager.sharedInstance().BackgroundisPlaying = true
                    if AudioManager.sharedInstance().playerExist() {
                        AudioManager.sharedInstance().resumeBackgroundMusic()
                    }
                    else{
                        AudioManager.sharedInstance().playBackgroundMusic("bgMusic.wav")
                    }
                    pauseMusic.alpha = 1.0
                }
                else {
                    AudioManager.sharedInstance().BackgroundisPlaying = false
                    AudioManager.sharedInstance().pauseBackgroundMusic()
                    pauseMusic.alpha = 0.66
                }
            }
            
            if IsPaused == true && pauseSound.contains(loc) {
                if AudioManager.sharedInstance().SoundisPlaying == true {
                    AudioManager.sharedInstance().SoundisPlaying = false
                    pauseSound.alpha = 0.66
                }
                    
                else if AudioManager.sharedInstance().SoundisPlaying == false {
                    AudioManager.sharedInstance().SoundisPlaying = true
                    pauseSound.alpha = 1.0
                }
            }
            
            if IsPaused == true && homeButton.contains(loc) {
                scene?.isUserInteractionEnabled = false
                for children in pauseLayer.children {
                    children.removeFromParent()
                }
                pauseLayer.removeFromParent()
                self.scene!.isPaused = false
                self.animateEndGame({
                    if let scene = MainMenu(fileNamed:"GameScene") {
                        
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
    
    //MARK: GAMECENTER
    func saveHighscore(_ gameScore: Int) {
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "Highest_Scores")
            scoreReporter.value = Int64(gameScore)
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: {error -> Void in
                if error != nil {
                    print("An error has occured: \(error)")
                }
            })
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
    
    func resetAchievements() {
        GKAchievement.resetAchievements { (error) in
            if error != nil {
                print("why?")
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if ball.alpha != 1 {
            
            ball.physicsBody?.categoryBitMask = ghostBallCategory
            ball.physicsBody?.collisionBitMask = redBarrierCategory
        }
        else {
            ball.physicsBody?.categoryBitMask = ballCategory
            ball.physicsBody?.collisionBitMask = dotCategory | redBarrierCategory
        }

    }
}
