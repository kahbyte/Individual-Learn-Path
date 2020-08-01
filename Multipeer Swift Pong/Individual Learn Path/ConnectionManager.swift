//
//  ConnectionManager.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 01/08/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import Foundation
import MultipeerConnectivity

/*singleton, because I want to use the same configuration and peers for the entire session and over different screens. If I had just instantiated the class, for instance, in the MenuVC, and then instantiated it again in the GameScene, they wouldn't carry the same information or peers. */
class ConnectionManager: NSObject {
    
    /*This one made possible to dismiss the browser view controller using a function from the MCBrowserViewControllerDelegate. It was implemented in the MenuVC*/
    var delegate: ConnectionManagerDelegate?
    
    //MARK: INITIAL MULTIPEER CONFIG
    private let senderServiceType = "ILP-Pong" //an unique string that will be used to identify what I'm peering / looking for peers for.
    private let peerID = MCPeerID(displayName: UIDevice.current.name) //The ID of the current device that will be transmitted over the sessions
    private let mcAdvertiserAssistant: MCAdvertiserAssistant? //Will help to advertise my peer, when looking to host or join a session
    let mcSession: MCSession? //The session itself. When stablished, will be used for sending, receiving and streaming data.
    private let mcBrowser: MCBrowserViewController? //A standard view controller that's using when looking for and joining a session
    
    static let shared = ConnectionManager() //this shit is making the magic happen. Thanks Igor =D
    
    /*Classic. No need to explain.*/
    override private init(){
        self.mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        
        self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: senderServiceType, discoveryInfo: nil, session: mcSession!)
        
        self.mcBrowser = MCBrowserViewController(serviceType: senderServiceType, session: mcSession!)
        
        super.init()
        
        mcSession?.delegate = self
    }
    
    //MARK: CONNECTION PROMPT FUNCTIONS
    func startHosting() {
        mcAdvertiserAssistant?.start()
    }
    
    /*Returns a view controller that will be using for browsing*/
    func join() -> MCBrowserViewController {
        mcBrowser?.maximumNumberOfPeers = 1
        mcBrowser?.delegate = self
        
        return mcBrowser!
    }
    
    func disconnect(){
        mcSession?.disconnect()
        mcAdvertiserAssistant?.stop()
    }
}

//MARK: DATA RECEIVING FUNCTIONS
extension ConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}

extension ConnectionManager: MCBrowserViewControllerDelegate {
    //if done is tapped, dismiss the VC
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.delegate?.dismissBrowserVC()
    }
    
    //if cancel is tapped, dismiss the VC
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.delegate?.dismissBrowserVC()
    }
    
    
}

//░░░░▓█───────▄▄▀▀█──────
//░░░░▒░█────▄█▒░░▄░█─────
//░░░░░░░▀▄─▄▀▒▀▀▀▄▄▀─────
//░░░░░░░░░█▒░░░░▄▀───────
//▒▒▒░░░░▄▀▒░░░░▄▀────────
//▓▓▓▓▒░█▒░░░░░█▄─────────
//█████▀▒░░░░░█░▀▄────────
//█████▒▒░░░▒█░░░▀▄───────
//███▓▓▒▒▒▀▀▀█▄░░░░█──────
//▓██▓▒▒▒▒▒▒▒▒▒█░░░░█─────
//▓▓█▓▒▒▒▒▒▒▓▒▒█░░░░░█────
//░▒▒▀▀▄▄▄▄█▄▄▀░░░░░░░█───
