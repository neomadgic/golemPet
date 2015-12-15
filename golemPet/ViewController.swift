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
        print("Item DROPPED")
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
    
    func gameOver()
    {
        timer.invalidate();
        golemImage.playDeathAnimation();
        penalties = 0;
    }

}

