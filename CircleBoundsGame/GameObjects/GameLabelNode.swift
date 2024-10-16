//
//  GameLabelNode.swift
//  CircleBoundsGame
//
//  Created by ivan on 16.10.2024.
//

import SpriteKit

class GameLabelNode: SKLabelNode {
    
    convenience init(text: String,
                     nodeName: String,
                     fontSize: CGFloat = 80,
                     x: CGFloat = 0,
                     y: CGFloat = 0) {
        
        self.init(text: text)
        self.fontSize = fontSize
        self.setScale(1.5)
        self.fontColor = .black
        self.position = CGPoint(x: x, y: y)
        self.name = nodeName
    }
}
