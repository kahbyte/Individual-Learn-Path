//
//  GameScene.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 06/07/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    ///MARK: Nodes
    var ball = SKSpriteNode()
    var player = SKSpriteNode()
    var opponent = SKSpriteNode()
    
    ///MARK: Labels
    
    var score = (playerScore: 0, enemyScore: 0)
    var force = 5
    let maxScore = 10
    
    override func didMove(to view: SKView){
        
        //this allows me to use the nodes
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        player.position.x = (-self.frame.width / 2) + 70 // sets paddle position programmatically. Helps with different sizes
            
        opponent = self.childNode(withName: "opponent") as! SKSpriteNode
        opponent.position.x = (self.frame.width / 2) - 70 // sets paddle position programmatically. Helps with different sizes
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        //Frame settings
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        startGame()
    }
    
    //MARK: Match settings
    //Sets the score to 0 and apply the initial impulse of (10, 10) with random -1 or 1 scalars
    func startGame(){
        score.playerScore = 0
        score.enemyScore = 0
        
        ball.physicsBody?.applyImpulse(CGVector(dx: force, dy: force))
    }
    
    func updateScore(playerWhoScored: SKSpriteNode){
        var impulse: CGVector!
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        if playerWhoScored == player{
            score.playerScore += 1
            impulse = CGVector(dx: force, dy: force)
        }
        
        else if playerWhoScored == opponent{
            score.enemyScore += 1
            impulse = CGVector(dx: -force, dy: -force)
        }
        
        print(score)
        
        if score.playerScore == maxScore || score.enemyScore == maxScore{
            endGame()
        } else{
            ball.physicsBody?.applyImpulse(impulse)
        }
        
    }
    
    func endGame(){
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            if location.x < 0{
                player.run(SKAction.moveTo(y: location.y, duration: 0.1))
            } else if location.x > 0{
                opponent.run(SKAction.moveTo(y: location.y, duration: 0.1))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            if location.x < 0{
                player.run(SKAction.moveTo(y: location.y, duration: 0.1))
            } else if location.x > 0{
                opponent.run(SKAction.moveTo(y: location.y, duration: 0.1))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if ball.position.x <= player.position.x{
            updateScore(playerWhoScored: opponent)
        }
        
        else if ball.position.x >= opponent.position.x{
            updateScore(playerWhoScored: player)
        }
    }
}
