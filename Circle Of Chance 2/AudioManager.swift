//
//  AudioManager.swift
//  CircleOfChance
//
//  Created by Mac on 1/9/17.
//  Copyright © 2017 KJB Apps LLC. All rights reserved.
//

import Foundation
import AVFoundation

open class AudioManager {
    open var backgroundMusicPlayer: AVAudioPlayer?
    open var soundEffectPlayer: AVAudioPlayer?
    
    open var SoundisPlaying: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "sound")
        }
        set(value){
            UserDefaults.standard.set(value, forKey: "sound")
        }
    }
    
    open var BackgroundisPlaying: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "music")
        }
        set(value){
            UserDefaults.standard.set(value, forKey: "music")
        }
    }
    
    open class func sharedInstance() -> AudioManager {
        return AudioManagerInstance
    }
    
    init() {
        let sess = AVAudioSession.sharedInstance()
        if sess.isOtherAudioPlaying {
            _ = try? sess.setCategory(AVAudioSessionCategoryAmbient, with: [])
            _ = try? sess.setActive(true, with: [])
        }
        
        if let boolexist = UserDefaults.standard.object(forKey: "sound"),
            boolexist is Bool {
                print("EXIST")
            }
        else {
            SoundisPlaying = true
        }
        
        if let boolexist = UserDefaults.standard.object(forKey: "music"),
            boolexist is Bool {
                print("Exist")
            }
        else {
            BackgroundisPlaying = true
            playBackgroundMusic("bgMusic.wav")
        }
    }
    
    open func playSoundEffect(_ filename: String) {
        if SoundisPlaying != false {
            let url = Bundle.main.url(forResource: filename, withExtension: nil)
            if (url == nil) {
                print("Could not find file: \(filename)")
                return
            }
            
            var error: NSError? = nil
            do {
                soundEffectPlayer = try AVAudioPlayer(contentsOf: url!)
            } catch let error1 as NSError {
                error = error1
                soundEffectPlayer = nil
            }
            if let player = soundEffectPlayer {
                player.numberOfLoops = 0
                player.prepareToPlay()
                player.play()
            } else {
                print("Could not create audio player: \(error!)")
            }
        }
    }
    
    
    open func playBackgroundMusic(_ filename: String) {
        if BackgroundisPlaying != false{
            let url = Bundle.main.url(forResource: filename, withExtension: nil)
            if (url == nil) {
                print("Could not find file: \(filename)")
                return
            }
            
            var error: NSError? = nil
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
            } catch let error1 as NSError {
                error = error1
                backgroundMusicPlayer = nil
            }
            if let player = backgroundMusicPlayer {
                player.numberOfLoops = -1
                player.prepareToPlay()
                player.play()
            } else {
                print("Could not create audio player: \(error!)")
            }
        }
    }
    
    open func pauseBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if player.isPlaying {
                player.pause()
            }
        }
    }
    
    open func resumeBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if !player.isPlaying {
                player.play()
            }
        }
    }
    open func playerExist() -> Bool {
        return backgroundMusicPlayer != nil
    }
}

private let AudioManagerInstance = AudioManager()
