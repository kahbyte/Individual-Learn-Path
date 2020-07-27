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

var peerID: MCPeerID?
var mcSession: MCSession?
var mcAdvertiserAssistant: MCAdvertiserAssistant?
var senderServiceType = "myString"


class MenuVC: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID!, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
    }
    
    @IBAction func play(_ sender: Any) {
        moveToGame(game: .easy)
    }
    
    //Receives a game mode and starts the game.
    func moveToGame(game: gameMode){
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        currentGameMode = game
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @IBAction func showConnectionPrompt(_ sender: UIButton) {
        let ac = UIAlertController(title: "Teste multipeer", message: "hmm coquinha", preferredStyle: .actionSheet) //(UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .actionSheet))
        
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            ac.popoverPresentationController?.sourceView = self.view
            ac.popoverPresentationController?.sourceRect = sender.frame
        }
        
        present(ac, animated: true)
    }
    
    
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: senderServiceType, discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction){
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: senderServiceType, session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let displayName = peerID.displayName
        
        switch state {
        case .connected:
            print("Connected: \(displayName)")
        case .connecting:
            print("Connecting: \(displayName)")
        case .notConnected:
            print("Not connected: \(displayName)")
        @unknown default:
            print("deu ruim, clã: \(displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}

