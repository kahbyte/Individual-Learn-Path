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

enum gameEvent: String{
    case startGame = "startGame"
    case endGame = "endGame"
    case pauseGame = "pauseGame"
}

var peerID: MCPeerID?
var mcSession: MCSession?
var mcAdvertiserAssistant: MCAdvertiserAssistant?
var senderServiceType = "myString"
var isConnected = false
var isHost = false

class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID!, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
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
        if mcSession?.connectedPeers.count == 0 { return }
        do{
            try mcSession?.send(event.rawValue.data(using: .utf8)!, toPeers: mcSession!.connectedPeers, with: .reliable)
        } catch let error {
            print(error)
        }
    }
    
    func receivedCommand(action: String, peerID: String){
        DispatchQueue.main.async {
                    if action == gameEvent.startGame.rawValue {
                        self.moveToGame(game: .p2pMultiplayer)
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
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: senderServiceType, discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
        
        isConnected = true
        isHost = true
    }
    
    func joinSession(action: UIAlertAction){
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: senderServiceType, session: mcSession)
        mcBrowser.maximumNumberOfPeers = 1
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
        
        isConnected = true
        isHost = false
    }
    
    func disconnectSession(action: UIAlertAction){
        guard let mcSession = mcSession else { return }
        mcSession.disconnect()
        mcAdvertiserAssistant?.stop()
        
        isConnected = false
        isHost = false
    }
}
