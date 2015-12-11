//
//  EndScene.swift
//  Final_ReichHawkins
//
//  Created by Stephen Reich on 12/10/15.
//  Copyright © 2015 Stephen Reich. All rights reserved.
//

import SpriteKit


class EndScene: SKScene {
    
    var score: Int = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = view.frame.size
        self.scaleMode = .AspectFill
        let texture = SKTexture(imageNamed: "gameEnd")
        let background = SKSpriteNode(texture: texture)
        background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(background)
        background.size = view.frame.size
        
        let scoreTitleLabel = SKLabelNode(fontNamed:"Chalkduster")
        scoreTitleLabel.text = "you killed";
        scoreTitleLabel.name = "playButton"
        scoreTitleLabel.fontSize = 45;
        scoreTitleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height * 0.85);
        scoreTitleLabel.zPosition = 100
        
        let scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
        scoreLabel.text = "\(score) Mileys";
        scoreLabel.name = "playButton"
        scoreLabel.fontSize = 45;
        scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height * 0.75);
        scoreLabel.zPosition = 100
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Play Again?";
        myLabel.name = "playButton"
        myLabel.fontColor = UIColor.redColor()
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height * 0.40);
        myLabel.zPosition = 100
        
        self.addChild(myLabel)
        self.addChild(scoreTitleLabel)
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
            
            if let name = touchedNode.name {
                if name == "playButton"{
                    presentGameScene()
                }
            }
        }
    }
    
    func presentGameScene() {
        if let scene = GameScene(fileNamed:"GameScene") {
            self.view?.presentScene(scene, transition: SKTransition.doorsCloseHorizontalWithDuration(0.75))
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}



