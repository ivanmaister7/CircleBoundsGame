//
//  GameEngine.swift
//  CircleBoundsGame
//
//  Created by ivan on 17.10.2024.
//

import SpriteKit

class GameEngine {
    var scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func startSpawningObstacles() {
        let spawnTopAction = SKAction.run { [weak self] in
            self?.startSpawningObstacle(.top)
        }
        let waitForFirstSpawnTopAction = SKAction.wait(forDuration: TimeInterval(Int.random(in: 2...5)))
        let sequenceTop = SKAction.sequence([waitForFirstSpawnTopAction, spawnTopAction])
        scene.run(sequenceTop)
        
        
        let spawnBottomAction = SKAction.run { [weak self] in
            self?.startSpawningObstacle(.bottom)
        }
        let waitForFirstSpawnBottomAction = SKAction.wait(forDuration: TimeInterval(Int.random(in: 2...5)))
        let sequenceBottom = SKAction.sequence([waitForFirstSpawnBottomAction, spawnBottomAction])
        scene.run(sequenceBottom)
    }
    
    private func startSpawningObstacle(_ type: ObstacleType) {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnObstacle(type)
        }
        let waitForNextSpawnAction = SKAction.wait(forDuration: 5)
        let sequence = SKAction.sequence([spawnAction, waitForNextSpawnAction])
        let repeatAction = SKAction.repeatForever(sequence)
        scene.run(repeatAction)
    }
    
    private func spawnObstacle(_ type: ObstacleType) {
        let obstacle = ObstacleNode(size: CGSize(width: 200, height: 10),
                                x: scene.frame.maxX + 100,
                                   y: generateRandomY(type: type))
        
        scene.addChild(obstacle)
        
        let time = TimeInterval(Int.random(in: 1...5))
        let moveAction = SKAction.moveTo(x: scene.frame.minX - 100, duration: time)
        let removeAction = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    private func generateRandomY(type: ObstacleType) -> CGFloat {
        switch type {
        case .top:
            CGFloat.random(in: scene.frame.midY + 50...scene.frame.maxY - 150)
        case .bottom:
            CGFloat.random(in: scene.frame.minY + 150...scene.frame.midY - 50)
        default:
            0
        }
    }
}
