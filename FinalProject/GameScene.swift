//
//  GameScene.swift
//  FinalProject
//
//  Created by Geon D Gayles on 5/3/17.
//  Copyright © 2017 Geon D Gayles. All rights reserved.
/* boy picture ----- https://clipartfest.com/categories/view/9ec9441bf34549354b8bc8630f16db5ce1bc4714/animated-boy-clipart.html */
/* fireball picture ---- https://vfx.city/tutorials/fireball */
/* ghost picture ---- http://www.clipartsfree.net/clipart/1457-halloween-small-ghost-clipart.html */
/* Help ---- iOS Swift Game Development Cookbook: Simple Solutions for Game Development by Jonathon Manning. */

import SpriteKit
import GameplayKit

let boyCategory : UInt32 = 1 << 0
let ghostCategory : UInt32 = 1 << 1
let fireballCategory : UInt32 = 1 << 2


func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

 extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
   }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "boy.gif") // boy
    let header = SKLabelNode(fontNamed: "Zapfino") // label
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.gray
       
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        
        header.text = "Welcome to Hit!!!!"
        header.position = CGPoint(x: size.width*0.5, y: size.height * 0.9)
        header.fontColor = SKColor.black
        addChild(player) // add Boy to screen
        addChild(header) // add Label to screen
        
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever( //Actually Run the program and make it repeat
            SKAction.sequence([SKAction.run(addSprite),SKAction.wait(forDuration: 1.0)])))
        }
    
    
    func touchDown(atPoint pos : CGPoint) {
           }
 /*
    func touchMoved(toPoint pos : CGPoint) {
            }
    func touchUp(atPoint pos : CGPoint) {
            }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    
        guard let touch = touches.first
            
        else {
            return
        }
        let touchLocation = touch.location(in: self)
        

        let fireball = SKSpriteNode(imageNamed: "fireball.gif") //fireball
        fireball.position = player.position
        fireball.physicsBody = SKPhysicsBody(circleOfRadius: fireball.size.width/2)
        fireball.physicsBody?.isDynamic = true
        fireball.physicsBody?.categoryBitMask = fireballCategory
        fireball.physicsBody?.contactTestBitMask = ghostCategory
    
        let distance = touchLocation - fireball.position
        
       
        if (distance.y < 0) {
            return
        }
        addChild(fireball) //add Fireball to screen
        let direction = distance.normalized() //Direction of fireball
        let shootAmount = direction * 2000 //How far out to shoot ball
        let realDest = shootAmount + fireball.position //What Direction
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        fireball.run(SKAction.sequence([actionMove, actionMoveDone]))

    }
    
/*    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }*/
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addSprite() {
        
        let ghost = SKSpriteNode(imageNamed: "ghost1.gif") //ghost
        
        ghost.physicsBody = SKPhysicsBody(rectangleOf: ghost.size)
        ghost.physicsBody?.isDynamic = true
        ghost.physicsBody?.categoryBitMask = ghostCategory
        ghost.physicsBody?.contactTestBitMask = fireballCategory
        ghost.physicsBody?.collisionBitMask = boyCategory
        
        let ghostY = random(min: ghost.size.height, max: size.width)
        ghost.position = CGPoint(x: ghostY , y: size.height + ghost.size.height)
        addChild(ghost)
        
        let Duration = random(min: CGFloat(2.0), max: CGFloat(5.0)) //speed
        
        let actionMove = SKAction.move(to: CGPoint(x: ghostY, y: -ghost.size.height/2), duration: TimeInterval(Duration))
        let actionMoveDone = SKAction.removeFromParent()
        let youLose = SKAction.run() {
            let close = SKTransition.doorsCloseVertical(withDuration: 0.5)
            let gameOverScene = GameOverView(size: self.size)
            self.view?.presentScene(gameOverScene, transition: close)
        }
        ghost.run(SKAction.sequence([actionMove, youLose, actionMoveDone]))
        
    }
    
    func collision(fireball: SKSpriteNode, ghost: SKSpriteNode) {
        fireball.removeFromParent()
        ghost.removeFromParent()
        backgroundColor = SKColor.cyan
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var Body1, Body2: SKPhysicsBody
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            Body1 = contact.bodyA
            Body2 = contact.bodyB
        } else {
            Body1 = contact.bodyB
            Body2 = contact.bodyA
        }
        
        if ((Body1.categoryBitMask & ghostCategory != 0) && (Body2.categoryBitMask & fireballCategory != 0)) {
            if let ghost = Body1.node as? SKSpriteNode, let fireball = Body2.node as? SKSpriteNode {
                collision(fireball: fireball, ghost: ghost)
            }
        }
    }
}
