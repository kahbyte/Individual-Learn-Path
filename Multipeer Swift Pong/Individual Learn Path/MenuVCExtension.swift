//
//  MenuVCExtension.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 28/07/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import Foundation
import MultipeerConnectivity

extension MenuVC: MCSessionDelegate{
    
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
        
        if (mcSession?.connectedPeers.count)! >= 1{
            mcAdvertiserAssistant?.stop()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let command = String(data: data, encoding: .utf8) else { return }
        
        receivedCommand(action: command, peerID: peerID.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
    

}

extension MenuVC: MCBrowserViewControllerDelegate{
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}
