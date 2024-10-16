//
//  SKNodeExtension.swift
//  CircleBoundsGame
//
//  Created by ivan on 16.10.2024.
//

import SpriteKit

extension SKNode {
    func runVibrationEffect() {
        let originalPosition = self.position
        
        // Create an action sequence to simulate vibration
        let moveLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.05)
        let moveRight = SKAction.moveBy(x: 10, y: 0, duration: 0.05)
        
        let vibrationSequence = SKAction.sequence([
            moveLeft,
            moveRight,
            moveLeft,
            moveRight,
            SKAction.move(to: originalPosition, duration: 0.05) // Return to original position
        ])
        
        // Run the vibration effect on the node
        self.run(vibrationSequence)
    }
}
