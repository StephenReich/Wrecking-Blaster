//
//  IntroScene.swift
//  Final_ReichHawkins
//
//  Created by Stephen Reich on 12/10/15.
//  Copyright © 2015 Stephen Reich. All rights reserved.
//

import Foundation

import SpriteKit

class IntroScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = view.frame.size
        self.scaleMode = .AspectFill
        let texture = SKTexture(imageNamed: "gameMenu")
        let background = SKSpriteNode(texture: texture)
        background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(background)
        background.size = view.frame.size
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Play";
        myLabel.name = "playButton"
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height * 0.25);
        myLabel.zPosition = 100
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
            
            if let name = touchedNode.name where name == "playButton" {
                presentGameScene()
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
