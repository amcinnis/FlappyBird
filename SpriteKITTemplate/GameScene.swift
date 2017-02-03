//
//  GameScene.swift
//  SpriteKITTemplate
//
//  Created by John Bellardo on 1/10/17.
//  Copyright © 2017 John Bellardo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let SPRITE_CATEGORY : UInt32 = 0x01 << 0
    private let EDGE_CATEGORY : UInt32 = 0x01 << 1
    private let OBSTACLE_CATEGORY : UInt32 = 0x01 << 2
    
    private var label : SKLabelNode?
    private var sprite = Bird()
    
    private var sand1 = SKSpriteNode(imageNamed: "sand")
    private var sand2 = SKSpriteNode(imageNamed: "sand")
    private var sand3 = SKSpriteNode(imageNamed: "sand")
    

    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = UIColor(red: 237/256.0, green: 140/256.0, blue: 29/256.0, alpha: 1.0)
        physicsWorld.contactDelegate = self
        
        label = SKLabelNode(text: "Tap to begin")
        if let label = label {
            label.fontSize = 65
            label.fontName = "TastyBirds-Bold"
            label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

            addChild(label)
        }
        
        sand1.setScale(0.5)
        sand2.setScale(0.5)
        sand3.setScale(0.5)
        sand1.position = CGPoint(x: 0.0, y: sand1.size.height / 2.0)
        sand2.position = CGPoint(x: sand1.position.x + sand1.size.width, y: sand2.size.height / 2.0)
        sand3.position = CGPoint(x: sand2.position.x + sand2.size.width, y: sand3.size.height / 2.0)
        
        addChild(sand1)
        addChild(sand2)
        addChild(sand3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.label != nil {
            self.label?.isHidden = true
            self.label = nil

            if let view = self.view {
                self.physicsBody = SKPhysicsBody(edgeLoopFrom: view.frame)
                self.physicsBody?.categoryBitMask = EDGE_CATEGORY
                self.physicsBody?.collisionBitMask = SPRITE_CATEGORY
            }
            
            sprite.name = "Bird"
            sprite.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            sprite.zPosition = 2.0
            sprite.physicsBody?.mass = 0.15
            sprite.physicsBody?.categoryBitMask = SPRITE_CATEGORY
            sprite.physicsBody?.collisionBitMask = EDGE_CATEGORY
            sprite.physicsBody?.contactTestBitMask = OBSTACLE_CATEGORY
            
            addChild(sprite)
            
            //Obstacles
            let addObstaclePair = SKAction.sequence([
                SKAction.run {
                    self.addObstaclePair()
                },
                SKAction.wait(forDuration: 3.0)
                ])
            
            let addObstacles = SKAction.repeatForever(addObstaclePair)
            run(addObstacles)
        }
        else {
            sprite.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 125.0))
            let wingFlap = SKAction.playSoundFileNamed("wingFlap.wav", waitForCompletion: false)
            sprite.run(wingFlap)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let view = view {
            view.presentScene(GameOverScene(size: view.frame.size))
        }
    }
    
    func addObstaclePair() {
        
        let obstacle1 = SKSpriteNode(imageNamed: "Umbrella")
        obstacle1.name = "Bottom Obstacle"
        obstacle1.setScale(0.08)
        obstacle1.zRotation = .pi/12
        obstacle1.zPosition = 1.0

        let umbTexture = SKTexture(imageNamed: "Umbrella")
        obstacle1.physicsBody = SKPhysicsBody(texture: umbTexture, size: obstacle1.size)
        if let physicsBody1 = obstacle1.physicsBody {
            physicsBody1.affectedByGravity = false
            physicsBody1.velocity = CGVector(dx: -75, dy: 0)
            physicsBody1.linearDamping = 0.0
            physicsBody1.categoryBitMask = OBSTACLE_CATEGORY
            physicsBody1.contactTestBitMask = SPRITE_CATEGORY
            physicsBody1.collisionBitMask = SPRITE_CATEGORY
        }
        
        let obstacle2 = SKSpriteNode(imageNamed: "Umbrella")
        obstacle2.name = "Top Obstacle"
        obstacle2.setScale(0.08)
        obstacle2.zRotation = .pi + (.pi/12)
        obstacle1.zPosition = 1.0
        
        obstacle2.physicsBody = SKPhysicsBody(texture: umbTexture, size: obstacle2.size)
        if let physicsBody2 = obstacle2.physicsBody {
            physicsBody2.affectedByGravity = false
            physicsBody2.velocity = CGVector(dx: -75, dy: 0)
            physicsBody2.linearDamping = 0.0
            physicsBody2.categoryBitMask = OBSTACLE_CATEGORY
            physicsBody2.contactTestBitMask = SPRITE_CATEGORY
            physicsBody2.collisionBitMask = SPRITE_CATEGORY
        }
        
        
        let random = skRand(lowerBound: 0.0 - obstacle1.size.height, upperBound: self.frame.height / 2.0)
        obstacle1.position = CGPoint(x: self.frame.width + obstacle1.size.width, y: (obstacle1.size.height / 2.0) + random)
        obstacle2.position = CGPoint(x: self.frame.width + obstacle2.size.width, y: self.frame.height - (obstacle1.size.height / 2.0) + random)
        
        addChild(obstacle1)
        addChild(obstacle2)
    }
    
    func skRandf() -> CGFloat {
        return CGFloat(Double(arc4random()) / Double(UINT32_MAX))
    }
    
    func skRand(lowerBound: CGFloat, upperBound: CGFloat) -> CGFloat {
        return skRandf() * (upperBound - lowerBound) + lowerBound
    }
    
    override func update(_ currentTime: TimeInterval) {
        sand3.position.x -= 2
        sand2.position.x -= 2
        sand1.position.x -= 2
        
        if sand1.position.x + sand1.size.width < 0 {
            sand1.position.x = sand3.position.x + sand3.size.width
        }
        
        if sand2.position.x + sand2.size.width < 0 {
            sand2.position.x = sand1.position.x + sand1.size.width
        }
        
        if sand3.position.x + sand3.size.width < 0 {
            sand3.position.x = sand2.position.x + sand2.size.width
        }
    }
}
