//
//  CircleNode.swift
//  CircleBoundsGame
//
//  Created by ivan on 16.10.2024.
//

import SpriteKit

class CircleNode: SKCropNode {
    
    init(view: SKView,
         radius: CGFloat = 50.0,
         startColor: UIColor = .blue,
         endColor: UIColor = .green,
         x: CGFloat = 0,
         y: CGFloat = 0) {
        
        super.init()
        
        let texture = SKTexture(startColor: startColor,
                                endColor: endColor,
                                size: CGSize(width: radius * 2, height: radius * 2))
        
        let circleSprite = SKSpriteNode(texture: texture)
        circleSprite.size = CGSize(width: radius * 2, height: radius * 2)
        
        let maskNode = SKShapeNode(circleOfRadius: radius)
        maskNode.fillColor = .white
        maskNode.lineWidth = 0
        
        if let maskTexture = view.texture(from: maskNode) {
            self.maskNode = SKSpriteNode(texture: maskTexture)
        }
        
        self.position = CGPoint(x: x, y: y)
        self.addChild(circleSprite)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.categoryBitMask = CollisionCircleBitMask.circle.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCircleBitMask.obstacle.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startRotatingCircle() {
        let rotateAction = SKAction.rotate(byAngle: -.pi * 2, duration: 2)
        let repeatAction = SKAction.repeatForever(rotateAction)
        self.run(repeatAction)
    }
    
    func runScaleAction(scale: CGFloat, duration: CGFloat = 0.2) {
        self.run(SKAction.scale(to: scale, duration: duration))
    }
}
