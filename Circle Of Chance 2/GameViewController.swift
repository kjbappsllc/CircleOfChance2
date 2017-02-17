//
//  GameViewController.swift
//  CircleOfChance
//
//  Created by Mac on 7/13/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import AVFoundation

class GameViewController: UIViewController, GKGameCenterControllerDelegate{
    
    //var googleBannerView : GADBannerView!
    var leaderboardIdentifier: String? = nil
    var gameCenterEnabled: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        AudioManager.sharedInstance().playBackgroundMusic("bgMusic.wav")
        if let scene = MainMenu(fileNamed:"GameScene") {
            
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 0.8)
            skView.presentScene(scene, transition: transition)
        }
        
        //loadBanner()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        authenticateLocalPlayer()
    }
    
    /*
    func loadBanner() {
        googleBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        googleBannerView.adUnitID = "ca-app-pub-7649281918688809/7940530179"
        googleBannerView.rootViewController = self
        
        let request:GADRequest = GADRequest()
        request.testDevices = [kGADSimulatorID, "ada15951f72c9f6e621f23e6dc7118d6"]
        googleBannerView.load(request)
        
        googleBannerView.frame = CGRect(x: 0, y: view.bounds.height - googleBannerView.frame.size.height, width: googleBannerView.frame.size.width, height: googleBannerView.frame.size.height)
        
        self.view.addSubview(googleBannerView!)
        
        bannerHeight = googleBannerView.frame.size.height
    }
    */
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController : UIViewController?, error : Error?) -> Void in
            
            if viewController != nil {
                
                self.present(viewController!, animated: true, completion: nil)
                
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        }
        else {
            return .portrait
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
