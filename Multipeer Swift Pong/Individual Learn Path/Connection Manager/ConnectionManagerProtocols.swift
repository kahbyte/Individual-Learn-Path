//
//  ConnectionManagerProtocols.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 01/08/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ConnectionManagerDelegate {
    func dismissBrowserVC()
    func receivedCommand(command: String, peerID: String)
}

protocol GameSceneDelegate {
    func updateMCOpponentPosition(yPosition: CGFloat)
    func updateMCBallPosition(position: CGPoint)
}
