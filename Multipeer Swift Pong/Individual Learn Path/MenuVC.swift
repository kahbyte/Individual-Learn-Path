//
//  MenuVC.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 17/07/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import UIKit
import MultipeerConnectivity

enum gameMode {
    case easy
    case medium
    case hard
    case localMultiplayer
    case p2pMultiplayer
}

enum gameEvent: String {
    case startGame = "startGame"
    case endGame = "endGame"
    case pauseGame = "pauseGame"
}

protocol menuVCDelegate{
    func receivedOpponentPosition(opponentYPosition: CGFloat)
}

/*var peerID: MCPeerID?
var mcSession: MCSession?
var mcAdvertiserAssistant: MCAdvertiserAssistant?
var senderServiceType = "myString" */
var isConnected = false
var isHost = false

let connectionManager = ConnectionManager.self

class MenuVC: UIViewController {
    var delegate: menuVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID!, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self*/
        
        connectionManager.shared.delegate = self
    }
    
    @IBAction func play(_ sender: Any) {
        if !isConnected || isHost {
            moveToGame(game: .easy)
            
            if isConnected{
                sendCommand(event: .startGame)
            }
        }
    }
    
    //Receives a game mode and starts the game.
    func moveToGame(game: gameMode){
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        currentGameMode = game
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    func sendCommand(event: gameEvent){
        /*if mcSession?.connectedPeers.count == 0 { return }
        do{
            let command = NSKeyedArchiver.archivedData(withRootObject: event.rawValue)
            
            try mcSession?.send(command, toPeers: mcSession!.connectedPeers, with: .reliable)
        } catch let error {
            print(error)
        }*/
    }
    
    func receivedCommand(action: String, peerID: String){
        DispatchQueue.main.async {
            if action == gameEvent.startGame.rawValue {
                self.moveToGame(game: .p2pMultiplayer)
            }
            
            if action == gameEvent.endGame.rawValue {
                
            }
        }
    }
    
    @IBAction func showConnectionPrompt(_ sender: UIButton) {
    
        let sessionAlertController = UIAlertController(title: "Teste multipeer", message: "hmm coquinha", preferredStyle: .actionSheet) //(UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .actionSheet))
        if !isConnected {
            sessionAlertController.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHostingSession))
            
            sessionAlertController.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
            }
        else{
            sessionAlertController.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: disconnectSession))
        }
            
            sessionAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            sessionAlertController.popoverPresentationController?.sourceView = self.view
            sessionAlertController.popoverPresentationController?.sourceRect = sender.frame
        }
        
        present(sessionAlertController, animated: true)
    }
    
    //MARK: START, JOIN and DISCONNECT functions
    func startHostingSession(action: UIAlertAction) {
        connectionManager.shared.startHosting()
        
        isConnected = true
        isHost = true
    }
    
    
    func joinSession(action: UIAlertAction){
        let mcBrowser = connectionManager.shared.join()
        present(mcBrowser, animated: true)
        
        isConnected = true
        isHost = false
    }
    
    func disconnectSession(action: UIAlertAction){
        connectionManager.shared.disconnect()
        
        isConnected = false
        isHost = false
    }
    
}


