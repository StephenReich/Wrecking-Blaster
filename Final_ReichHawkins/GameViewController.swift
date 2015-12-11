//
//  GameViewController.swift
//  Final_ReichHawkins
//
//  Created by Stephen Reich on 12/8/15.
//  Copyright (c) 2015 Stephen Reich. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    @IBOutlet weak var gameImage: UIImageView!

    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    var count = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var countdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        
        
        let scene = IntroScene()
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)

    }
    
    func updateTimer() {
//        
//        if(count > 0)
//        {
//            timer.text = String(count--)
//        }
//        if(count == 0){
//            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("endController") as? EndViewController {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
