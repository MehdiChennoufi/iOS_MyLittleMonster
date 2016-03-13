//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Mehdi Chennoufi on 12/03/2016.
//  Copyright © 2016 Mehdi Chennoufi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // === VARIABLES & CONSTANTES ===
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImage: DragImg!
    @IBOutlet weak var heartImage: DragImg!
    
    // Skulls
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    // Constants for the Opacity of the Skulls
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    // Others
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImage.dropTarget = monsterImg
        heartImage.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            // Long way (but more explicit)
            let resourcePath = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
            try musicPlayer = AVAudioPlayer(contentsOfURL: url)
            
            // Short way less explicit
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    
    // === EXPLANATIONS ===
    /*
        Every three second, the game changing is state
        it add a penalty. If the penalty is greater or equal to MAX_PENALTIES, the game stopping.
    */
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties++
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penalty3Img.alpha = OPAQUE
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
            
        }
        
        let rand = arc4random_uniform(2) // 0 or 1
        
        if rand == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
        } else {
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
        
        }
        
        currentItem = rand
        monsterHappy = false
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
        
    }

}

