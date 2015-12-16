//
//  ViewController.swift
//  golemPet
//
//  Created by Vu Dang on 12/8/15.
//  Copyright © 2015 Vu Dang. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    @IBOutlet weak var golemImage: MonsterImg!
    @IBOutlet weak var heartImage: DragImage!
    @IBOutlet weak var meatImage: DragImage!
    @IBOutlet weak var penalty1Image: UIImageView!
    @IBOutlet weak var penalty2Image: UIImageView!
    @IBOutlet weak var penalty3Image: UIImageView!
    
    let MAX_PENALTY = 3;
    let DIM_ALPHA: CGFloat = 0.2;
    let MAX_ALPHA: CGFloat = 1.0;
    
    var penalties = 0;
    var timer: NSTimer!;
    var isGolemHappy = false;
    var currentMood: UInt32 = 0;
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        meatImage.dropTarget = golemImage;
        heartImage.dropTarget = golemImage;
        
        penalty1Image.alpha = DIM_ALPHA;
        penalty2Image.alpha = DIM_ALPHA;
        penalty3Image.alpha = DIM_ALPHA;
        startTimer();
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "OnTargetDropped", object: nil)
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject)
    {
        isGolemHappy = true;
        heartImage.alpha = DIM_ALPHA;
        meatImage.alpha = DIM_ALPHA;
        heartImage.userInteractionEnabled = false
        meatImage.userInteractionEnabled = false
        
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
        golemImage.playDeathAnimation();
        penalties = 0;
    }

}

