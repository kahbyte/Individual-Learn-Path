//
//  MenuVC.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 17/07/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import UIKit
import MultipeerConnectivity

//I think this should not be here.
enum GameMode {
    case easy
    case medium
    case hard
    case localMultiplayer
    case p2pMultiplayer
}

enum GameEvent: String {
    case startGame = "startGame"
    case endGame = "endGame"
    case pauseGame = "pauseGame"
}

//These two will be used for some cocain logic
var isConnected = false
var isHost = false


class MenuVC: UIViewController {
    let connectionManager = ConnectionManager.self

    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionManager.shared.connectionDelegate = self
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
    func moveToGame(game: GameMode){
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        currentGameMode = game
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    func sendCommand(event: GameEvent){
        if connectionManager.shared.mcSession?.connectedPeers.count == 0 { return } //acho que eu nunca vi tanto . concatenado
        let dataToSend = PeerData(type: .gameEvent, opponentLocationData: nil, ballLocationData: nil, gameEvent: event.rawValue)
        
        do{
            guard let command = try? JSONEncoder().encode(dataToSend) else { return }
            
            try connectionManager.shared.mcSession?.send(command, toPeers: connectionManager.shared.mcSession!.connectedPeers, with: .reliable)
        } catch let error {
            print(error) //change to NSLog have to study first.
        }
    }
    
    //fuck, isso aqui vai ter que virar um protocolo. /
//    func receivedCommand(action: String, peerID: String){
//
//    }
    
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


