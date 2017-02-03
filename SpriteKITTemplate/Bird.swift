//
//  Bird.swift
//  SpriteKITTemplate
//
//  Created by Austin McInnis on 1/19/17.
//  Copyright © 2017 John Bellardo. All rights reserved.
//

import UIKit
import SpriteKit

class Bird: SKNode {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        let bird = SKSpriteNode(imageNamed: "frame-1")
        bird.setScale(0.1)

        let birdTexture = SKTexture(imageNamed: "frame-2")
        self.physicsBody = SKPhysicsBody(texture: birdTexture, size: bird.size)
        
        if let physicsBody = self.physicsBody {
            physicsBody.allowsRotation = false
        }
        
        
        let textureAtlas = SKTextureAtlas(named: "BlueTopHat")
        var textures = [SKTexture]()
        
        for i in 1...textureAtlas.textureNames.count {
            let texture = SKTexture(imageNamed: "frame-\(i)")
            textures.append(texture)
        }
        
        let fly = SKAction.animate(with: textures, timePerFrame: 0.15)
        let flying = SKAction.repeatForever(fly)
        bird.run(flying)
        
        addChild(bird)
    }
}
