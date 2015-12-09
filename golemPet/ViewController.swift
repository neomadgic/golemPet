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
    
    @IBOutlet weak var golemImage: UIImageView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var imageArray = [UIImage]();
        for var x = 1; x <= 4; x++
        {
            let image = UIImage(named: "idle\(x).png")
            imageArray.append(image!);
        }
        
        golemImage.animationImages = imageArray;
        golemImage.animationDuration = 0.8;
        golemImage.animationRepeatCount = 0;
        golemImage.startAnimating();
        
    }


}

