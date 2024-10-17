//
//  GameEngine.swift
//  CircleBoundsGame
//
//  Created by ivan on 17.10.2024.
//

import SpriteKit

class GameEngine {
    //MARK: Constants
    private static let obstacleWidth = 200.0
    private static let obstacleHeight = 10.0
     
    private static let minTimeForFirstSpawn = 2
    private static let maxTimeForFirstSpawn = 5
    
    private static let minObstacleSpeed = 1
    private static let maxObstacleSpeed = 5
    private static let timeBetweenNextSpawn = 5.0
    
    private static let topObstacleYOffset = 150.0
    private static let midObstacleYOffset = 50.0
    private static let bottomObstacleYOffset = 180.0
    
    //MARK: Properties
    var scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func startSpawningObstacles() {
        startSpawningObstacle(.top)
        startSpawningObstacle(.bottom)
    }
    
    private func startSpawningObstacle(_ type: ObstacleType) {
        let waitForFirstSpawnAction = SKAction.wait(forDuration: TimeInterval(Int.random(in: GameEngine.minTimeForFirstSpawn...GameEngine.maxTimeForFirstSpawn)))
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnObstacle(type)
        }
        let waitForNextSpawnAction = SKAction.wait(forDuration: GameEngine.timeBetweenNextSpawn)
        let gameLoopSequence = SKAction.sequence([spawnAction, waitForNextSpawnAction])
        let gameLoopAction = SKAction.repeatForever(gameLoopSequence)
        
        let fullObstacleLifecycleSequence = SKAction.sequence([waitForFirstSpawnAction, gameLoopAction])
        scene.run(fullObstacleLifecycleSequence)
    }
    
    private func spawnObstacle(_ type: ObstacleType) {
        let obstacle = ObstacleNode(size: CGSize(width: GameEngine.obstacleWidth,
                                                 height: GameEngine.obstacleHeight),
                                    x: scene.frame.maxX + GameEngine.obstacleWidth / 2,
                                    y: generateRandomY(type: type))
        
        scene.addChild(obstacle)
        
        let time = TimeInterval(Int.random(in: GameEngine.minObstacleSpeed...GameEngine.maxObstacleSpeed))
        let moveAction = SKAction.moveTo(x: scene.frame.minX - GameEngine.obstacleWidth / 2, duration: time)
        let removeAction = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    private func generateRandomY(type: ObstacleType) -> CGFloat {
        switch type {
        case .top:
            CGFloat.random(in: scene.frame.midY + GameEngine.midObstacleYOffset...scene.frame.maxY - GameEngine.topObstacleYOffset)
        case .bottom:
            CGFloat.random(in: scene.frame.minY + GameEngine.bottomObstacleYOffset...scene.frame.midY - GameEngine.midObstacleYOffset)
        default:
            0
        }
    }
}
