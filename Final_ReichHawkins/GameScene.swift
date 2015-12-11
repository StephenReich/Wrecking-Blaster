//
//  GameScene.swift
//  Final_ReichHawkins
//
//  Created by Stephen Reich on 12/8/15.
//  Copyright (c) 2015 Stephen Reich. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let contact:Bool = false
    
    let mileyTexture = SKTexture(imageNamed: "miley")
    let billyTexture = SKTexture(imageNamed: "billy")
    
    var score:Int = 0 {
        didSet {
            if let label = self.childNodeWithName("//score") as? SKLabelNode {
                label.text = "\(self.score)"
            }
        }
    }
    var time:Int = 20 {
        didSet {
            if let label = self.childNodeWithName("//timer") as? SKLabelNode {
                label.text = "\(self.time)"
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = view.frame.size
        self.scaleMode = .AspectFill
        self.physicsWorld.contactDelegate = self

        createTimer()
        createScoreLabel()
        createShooter()
        createBackground()
        createMileyGenerator()
    }
    
    func createBackground() {
        let texture = SKTexture(imageNamed: "gameScene")
        let background = SKSpriteNode(texture: texture)
        background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(background)
        background.size = self.view!.frame.size
    }
    
    func createTimer() {
        let key = "timer"
        let timer = SKLabelNode(fontNamed:"Chalkduster")
        timer.name = "timer"
        timer.text = "\(self.time)"
        timer.fontSize = 45
        timer.fontColor = UIColor.greenColor()
        timer.zPosition = 100
        timer.position = CGPoint(x:self.frame.width * 0.15, y:self.frame.height * 0.02);
        self.addChild(timer)

        
        let ticker = SKAction.sequence([SKAction.waitForDuration(1), SKAction.customActionWithDuration(0, actionBlock: { (node, time) -> Void in
            self.time -= 1
            if self.time <= 0 {
                node.removeActionForKey(key)
                self.gameOver()
            }
        })])
        timer.runAction(SKAction.repeatActionForever(ticker), withKey:key)
    }
    
    func createScoreLabel() {
        //TODO: By you  this text is handled byt he didSet above by the declaration
        //let key = "score"
        let score1 = SKLabelNode(fontNamed:"Chalkduster")
        score1.name = "score"
        score1.text = "\(self.score)"
        score1.fontSize = 45
        score1.fontColor = UIColor.redColor()
        score1.zPosition = 100
        score1.position = CGPoint(x:self.frame.width * 0.90, y:self.frame.height * 0.02);
        self.addChild(score1)
    }
    
    func createShooter() {
        
        let shooter = SKSpriteNode(color: SKColor.clearColor(), size: 	CGSize(width: 60, height: 60))
        self.addChild(shooter)
        shooter.name = "shooter"
        shooter.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0)
        
    }
    
    func createMileyGenerator() {
        
        let generator = SKNode()
        self.addChild(generator)
        let thrower = SKAction.sequence([SKAction.waitForDuration(0.5), SKAction.customActionWithDuration(0, actionBlock: { (node, time) -> Void in
            self.throwMiley()
        })])
        generator.runAction(SKAction.repeatActionForever(thrower))
        self.throwMiley()
        
    }
    
    func throwMiley() {
        
        let miley = SKSpriteNode(texture: self.mileyTexture)
        miley.physicsBody = createPhysicsBody(miley.size, miley: true)
        miley.zPosition = 100
        
        //TODO: Generate random x using arc4Random (or something)
        let x = self.size.width * CGFloat(Float(arc4random()) / Float(UINT32_MAX))

        miley.position = CGPoint(x: x, y: self.size.height + (self.mileyTexture.size().height * 0.5))
        
        miley.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -self.size.height, duration: 2.5)))
        
        miley.setScale(0.5)
        
        self.addChild(miley)
    }
    
    func shootAtPosition(point:CGPoint) {
        
        if let shooter = self.childNodeWithName("//shooter") {
        
            let billy = SKSpriteNode(texture: self.billyTexture)
            billy.physicsBody = createPhysicsBody(billy.size, miley: false)
            billy.zPosition = 100
            
            billy.setScale(0.5)
            
            billy.position = CGPoint(x: self.size.width * 0.5, y: 0)
            
            billy.runAction(SKAction.moveTo(point, duration: 0.3))
            
            
            //TODO: billy seems to go the opposite direction at the end
            let x = shooter.position.x - point.x
            
            let y = shooter.position.y - point.y
        
            billy.runAction(SKAction.repeatActionForever(SKAction.moveByX(x, y: y, duration: 0.5)))
            
            self.addChild(billy)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            self.shootAtPosition(location)
        }
    }
    
    func gameOver() {
        let scene = EndScene()
        scene.score = self.score
        self.view?.presentScene(scene, transition: SKTransition.doorsCloseHorizontalWithDuration(0.75))
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch (contactMask) {
            
        case BodyType.Miley.rawValue |  BodyType.Billy.rawValue:
            removeBodiesFromScreenAndAddOneToScore(contact.bodyA.node, bodyB:contact.bodyB.node)
            contact == true
            break;
            
        default:
            break;
        }
    }
    
    func createPhysicsBody(size:CGSize, miley:Bool) -> SKPhysicsBody {
        let body = SKPhysicsBody(circleOfRadius: size.width / 4)
        body.dynamic = true
        body.affectedByGravity = false
        body.categoryBitMask = miley ? BodyType.Miley.rawValue : BodyType.Billy.rawValue
        body.contactTestBitMask = miley ? BodyType.Billy.rawValue : BodyType.Miley.rawValue
        return body
    }
    
    func removeBodiesFromScreenAndAddOneToScore(bodyA:SKNode?, bodyB:SKNode?) {
        bodyB?.removeAllActions()
        bodyB?.runAction(SKAction.scaleTo(0, duration: 0.33), completion: { () -> Void in
            bodyB?.removeFromParent()
        })
        bodyA?.removeAllActions()
        bodyA?.runAction(SKAction.scaleTo(0, duration: 0.33), completion: { () -> Void in
            bodyA?.removeAllActions()
        })
        self.score += 1
    }
}

enum BodyType : UInt32 {
        case Miley = 1  // (1 << 0)
        case Billy = 2  // (1 << 1)
}

