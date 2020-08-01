//
//  ConnectionManager.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 01/08/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import Foundation
import MultipeerConnectivity

/*singleton*/
class ConnectionManager: NSObject {
    
    
    var delegate: ConnectionManagerDelegate?
    
    //MARK: INITIAL MULTIPEER CONFIG
    private let senderServiceType = "ILP-Pong"
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    private let mcAdvertiserAssistant: MCAdvertiserAssistant?
    private let mcSession: MCSession?
    private let mcBrowser: MCBrowserViewController?
    
    static let shared = ConnectionManager()
    
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
    
    func join() -> MCBrowserViewController {
        mcBrowser?.maximumNumberOfPeers = 1
        mcBrowser?.delegate = self
        
        return mcBrowser!
    }
    
    func disconnect(){
        mcSession?.disconnect()
        mcAdvertiserAssistant?.stop()
        
        isConnected = false
        isHost = false
    }
}

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
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.delegate?.dismissBrowserVC()
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.delegate?.dismissBrowserVC()
    }
    
    
}
