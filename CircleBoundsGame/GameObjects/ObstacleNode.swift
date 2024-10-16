//
//  ObstacleNode.swift
//  CircleBoundsGame
//
//  Created by ivan on 16.10.2024.
//

import SpriteKit

class ObstacleNode: SKShapeNode {
    convenience init(size: CGSize,
                     x: CGFloat,
                     y: CGFloat) {
        
        self.init(rectOf: size)
        self.fillColor = .red
        self.position = CGPoint(x: x, y: y)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = false
    }
}

enum ObstacleType {
    case top, bottom
}
