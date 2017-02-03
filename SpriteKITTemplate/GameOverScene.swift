//
//  GameOverScene.swift
//  SpriteKITTemplate
//
//  Created by Austin McInnis on 2/2/17.
//  Copyright © 2017 John Bellardo. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        let label = SKLabelNode(text: "Game Over")
        label.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        label.fontName = "TastyBirds-Bold"
        label.fontSize = 65
        
        addChild(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let view = view {
            view.presentScene(GameScene(size: view.frame.size))
        }
    }
}
