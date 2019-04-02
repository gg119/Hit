//
//  GameOverView.swift
//  FinalProject
//
//  Created by Taylor on 5/7/17.
//  Copyright © 2017 Geon D Gayles. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverView : SKScene{
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.red
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = "You Lose!!!!!!!!!!"
        label.fontSize = 50
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)

        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                let open = SKTransition.doorsOpenVertical(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:open)
            }
            ]))
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
