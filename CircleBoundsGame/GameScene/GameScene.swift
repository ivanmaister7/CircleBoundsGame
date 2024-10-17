//
//  GameScene.swift
//  CircleBoundsGame
//
//  Created by ivan on 16.10.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: Constants
    private static let initialCircleScale = 1.0
    private static let minCircleScale = 0.5
    private static let maxCircleScale = 9.0
    private static let stepCircleScale = 0.5
    
    private static let lifes = 5
    private static let lifesFontSize = 30.0
    
    private static let plusButtonXOffset = 100.0
    private static let plusButtonYOffset = 100.0
    
    private static let lifesLabelXOffset = 150.0
    private static let lifesLabelYOffset = 150.0
     
    private static let alertTitle = "Гра закінчена"
    private static let alertMessage = "Перезапустити?"
    private static let alertButton = "Так"
    
    //MARK: Properties
    var circleNode: CircleNode?
    
    var lifesLabel: GameLabelNode?
    
    var pauseButton: GameLabelNode?
    var plusButton: GameLabelNode?
    var minusButton: GameLabelNode?
    
    var gameEngine: GameEngine?
    
    private var collisionCount = 0 {
        didSet {
            if collisionCount >= GameScene.lifes {
                showAlert()
            }
            lifesLabel?.text = "Lifes ♥️ \(GameScene.lifes - collisionCount)"
        }
    }
    private var currentScale = GameScene.initialCircleScale {
        didSet {
            if currentScale < GameScene.minCircleScale || currentScale > GameScene.maxCircleScale {
                currentScale = oldValue
            }
            circleNode?.runScaleAction(scale: currentScale)
        }
    }
    
    private var isGamePause = false {
        didSet {
            isPaused = isGamePause
            pauseButton?.text = "\(isGamePause ? "▶️" : "⏸️")"
        }
    }
    
    //MARK: Lifecycle
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        createCircle()
        createButtons()
        createLifeLabel()
        createPauseButton()
        
        gameEngine = .init(scene: self)
        gameEngine?.startSpawningObstacles()
        
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "plus" {
            currentScale += GameScene.stepCircleScale
        } else if touchedNode.name == "minus" {
            currentScale -= GameScene.stepCircleScale
        } else if touchedNode.name == "pause" {
            isGamePause.toggle()
        }
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
        plusButton = GameLabelNode(text: "➕",
                                   nodeName: "plus",
                                   x: frame.midX - GameScene.plusButtonXOffset,
                                   y: frame.minY + GameScene.plusButtonYOffset)
        
        minusButton = GameLabelNode(text: "➖",
                                    nodeName: "minus",
                                    x: frame.midX + GameScene.plusButtonXOffset,
                                    y: frame.minY + GameScene.plusButtonYOffset)
        
        guard let plusButton, let minusButton else { return }
        
        addChild(plusButton)
        addChild(minusButton)
    }
    
    private func createLifeLabel() {
        lifesLabel = GameLabelNode(text: "Lifes ♥️ \(GameScene.lifes - collisionCount)",
                                   nodeName: "lifes",
                                   fontSize: GameScene.lifesFontSize,
                                   x: frame.midX - GameScene.lifesLabelXOffset,
                                   y: frame.maxY - GameScene.lifesLabelYOffset)
        
        guard let lifesLabel else { return }
        
        addChild(lifesLabel)
    }
    
    private func createPauseButton() {
        pauseButton = GameLabelNode(text: "",
                                   nodeName: "pause",
                                    fontSize: GameScene.lifesFontSize,
                                   x: frame.midX + GameScene.lifesLabelXOffset,
                                   y: frame.maxY - GameScene.lifesLabelYOffset)
        isGamePause = false
        guard let pauseButton else { return }
        
        addChild(pauseButton)
    }
    
    private func resetGame() {
        collisionCount = 0
        currentScale = GameScene.initialCircleScale
        gameEngine?.startSpawningObstacles()
    }
    
    private func showAlert() {
        removeAllActions()
        let alert = UIAlertController(title: GameScene.alertTitle, message: GameScene.alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: GameScene.alertButton, style: .default, handler: { _ in
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
