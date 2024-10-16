//
//  GameScene.swift
//  CircleBoundsGame
//
//  Created by ivan on 16.10.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: Properties
    var circleNode: CircleNode?
    var lifesLabel: SKLabelNode?
    var gameEngine: GameEngine?
    let lifes = 5
    
    private var collisionCount = 0 {
        didSet {
            if collisionCount >= 5 {
                showAlert()
            }
            lifesLabel?.text = "Lifes ♥️ \(lifes - collisionCount)"
        }
    }
    private var currentScale = 1.0 {
        didSet {
            if currentScale < 0.5 || currentScale > 10.0 {
                currentScale = oldValue
            }
        }
    }
    
    //MARK: Lifecycle
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        createCircle()
        createButtons()
        createLifeLabel()
        gameEngine = .init(scene: self)
        gameEngine?.startSpawningObstacles()
        
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "plus" {
            currentScale += 0.5
        } else if touchedNode.name == "minus" {
            currentScale -= 0.5
        }
        
        circleNode?.runScaleAction(scale: currentScale)
    }
    
    //MARK: private methods
    private func createCircle() {
        guard let sceneView = self.view else { return }
        
        circleNode = CircleNode(view: sceneView,
                                x: frame.midX,
                                y: frame.midY)
        
        guard let circleNode else { return }
        
        circleNode.startRotatingCircle()
        addChild(circleNode)
    }
    
    private func createButtons() {
        let plusButton = GameLabelNode(text: "＋",
                                         nodeName: "plus",
                                         x: frame.midX - 100,
                                         y: frame.minY + 100)
        
        let minusButton = GameLabelNode(text: "－",
                                          nodeName: "minus",
                                          x: frame.midX + 100,
                                          y: frame.minY + 100)
        
        addChild(plusButton)
        addChild(minusButton)
    }
    
    private func createLifeLabel() {
        lifesLabel = GameLabelNode(text: "Lifes ♥️ \(lifes - collisionCount)",
                                   nodeName: "lifes",
                                   fontSize: 30,
                                   x: frame.midX - 150,
                                   y: frame.maxY - 150)
        guard let lifesLabel else { return }
        addChild(lifesLabel)
    }
    
    private func resetGame() {
        collisionCount = 0
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Гра закінчена", message: "Перезапустити?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Так", style: .default, handler: { _ in
            self.resetGame()
        }))
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

//MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == circleNode || contact.bodyB.node == circleNode {
            circleCollisionAction()
        }
    }
    
    private func circleCollisionAction() {
        Vibration.success.vibrate()
        circleNode?.runVibrationEffect()
        collisionCount += 1
    }
}
