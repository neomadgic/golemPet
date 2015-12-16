//
//  ViewController.swift
//  golemPet
//
//  Created by Vu Dang on 12/8/15.
//  Copyright © 2015 Vu Dang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController
{
    
    @IBOutlet weak var golemImage: MonsterImg!
    @IBOutlet weak var heartImage: DragImage!
    @IBOutlet weak var meatImage: DragImage!
    @IBOutlet weak var penalty1Image: UIImageView!
    @IBOutlet weak var penalty2Image: UIImageView!
    @IBOutlet weak var penalty3Image: UIImageView!
    @IBOutlet weak var startOverBtn: UIButton!
    
    let MAX_PENALTY = 3;
    let DIM_ALPHA: CGFloat = 0.2;
    let MAX_ALPHA: CGFloat = 1.0;
    
    var penalties = 0;
    var timer: NSTimer!;
    var isGolemHappy = true;
    var currentMood: UInt32 = 0;
    
    var bgMusic: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        do
            {
            try bgMusic = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            bgMusic.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            bgMusic.play()
                
            } catch let err as NSError
                {
                    print(err.debugDescription);
                }
        
        
        
        startGame();
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject)
    {
        isGolemHappy = true;
        heartImage.alpha = DIM_ALPHA;
        meatImage.alpha = DIM_ALPHA;
        heartImage.userInteractionEnabled = false
        meatImage.userInteractionEnabled = false
        
        if currentMood == 0
            {
                sfxHeart.play()
            }
        else
            {
                sfxBite.play();
            }
        
        startTimer();
    }
    
    func startTimer()
    {
        if timer != nil
            
            {
            timer.invalidate();
            }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState()
    {
        if !isGolemHappy
        {
        penalties++
        sfxSkull.play();
        
        if penalties == 1
            {
                penalty1Image.alpha = MAX_ALPHA;
            }
        else if penalties == 2
            {
                penalty2Image.alpha = MAX_ALPHA;
            }
        else if penalties >= 3
            {
                penalty3Image.alpha = MAX_ALPHA;
            }
        else
            {
                penalty1Image.alpha = DIM_ALPHA;
                penalty2Image.alpha = DIM_ALPHA;
                penalty3Image.alpha = DIM_ALPHA;
            }
        
        if penalties >= MAX_PENALTY
            {
                gameOver();
            }
        }
        
        let rand = arc4random_uniform(2);
        currentMood = rand;
        
        if rand == 0
            {
                meatImage.alpha = DIM_ALPHA;
                meatImage.userInteractionEnabled = false
            
                heartImage.alpha = MAX_ALPHA;
                heartImage.userInteractionEnabled = true
            }
        else
            {
                heartImage.alpha = DIM_ALPHA;
                heartImage.userInteractionEnabled = false
                
                meatImage.alpha = MAX_ALPHA;
                meatImage.userInteractionEnabled = true
            }
        
        isGolemHappy = false;
    }
        
    
    func gameOver()
    {
        timer.invalidate();
        sfxDeath.play();
        golemImage.playDeathAnimation();
        penalties = 0;
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "showStartButton", userInfo: nil, repeats: false)
    }
    
    func startGame()
    {
        isGolemHappy = true;
        meatImage.dropTarget = golemImage;
        heartImage.dropTarget = golemImage;
        heartImage.alpha = DIM_ALPHA;
        meatImage.alpha = DIM_ALPHA;
        heartImage.userInteractionEnabled = false;
        meatImage.userInteractionEnabled = false;
        
        penalty1Image.alpha = DIM_ALPHA;
        penalty2Image.alpha = DIM_ALPHA;
        penalty3Image.alpha = DIM_ALPHA;
        startTimer();
        
        golemImage.playIdleAnimation();
        startOverBtn.hidden = true;
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "OnTargetDropped", object: nil)
    }
    
    @IBAction func onStartOverPressed(sender: AnyObject)
    {
        startGame();
    }
    
    func showStartButton()
    {
        startOverBtn.hidden = false;
    }
    
    

}

