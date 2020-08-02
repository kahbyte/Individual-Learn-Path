//
//  ConnectionManagerExtension.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 02/08/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct PeerData: Codable {
    var type: PossibleReceivedDataType
    var opponentLocationData: CGFloat?
    var ballLocationData: CGPoint?
    var gameEvent: String?
}

enum PossibleReceivedDataType: String, Codable {
    case gameEvent = "GameEvent"
    case opponentLocationData = "opponentLocationData"
    case ballLocationData = "ballLocationData"
}

enum Type {
    case event
    case opponentPosition
    case ballPosition
}

//MARK: DATA RECEIVING FUNCTIONS
extension ConnectionManager: MCSessionDelegate {
    
    //It keeps me up with the state of the session
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let displayName = peerID.displayName
        
        switch state{
        case .connecting:
            print("Connecting: \(displayName)")
        case .connected:
            print("Connected: \(displayName)")
        case .notConnected:
            print("Not connected: \(displayName)")
        @unknown default:
            print("Deu ruim, clã")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        guard let receivedData = try? JSONDecoder().decode(PeerData.self, from: data) else { return }
        
        /*if receivedData.type == possibleReceivedDataType.gameEvent.rawValue {
            self.connectionDelegate?.receivedCommand(command: (receivedData.gameEvent!), peerID: peerID.displayName)
        } else if receivedData.type == possibleReceivedDataType.opponentLocationData.rawValue {
            //self.gameSceneDelegate?.updateMCOpponentPosition(yPosition: opponentLocationData!)
        } else if receivedData.type == possibleReceivedDataType{
            //ball function
        }*/
        
        switch receivedData.type {
        case .gameEvent:
            self.connectionDelegate?.receivedCommand(command: receivedData.gameEvent ?? "", peerID: peerID.displayName)
            
        case .opponentLocationData:
            self.gameSceneDelegate?.updateMCOpponentPosition(yPosition: receivedData.opponentLocationData ?? 0.0)
            
        case .ballLocationData:
            self.gameSceneDelegate?.updateMCBallPosition(position: receivedData.ballLocationData!)
        }
        
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
        self.connectionDelegate?.dismissBrowserVC()
    }
    
    //if cancel is tapped, dismiss the VC
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.connectionDelegate?.dismissBrowserVC()
    }
}
