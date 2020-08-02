//
//  MenuVCExtension.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 28/07/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import Foundation
import MultipeerConnectivity

extension MenuVC: ConnectionManagerDelegate{
    func dismissBrowserVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func receivedCommand(command: String, peerID: String){
        print("batata1")
        DispatchQueue.main.async {
            print("batata2")
            if command == GameEvent.startGame.rawValue {
                self.moveToGame(game: .p2pMultiplayer)
            }
            
            if command == GameEvent.endGame.rawValue {
                
            }
        }
    }
}
