//
//  MenuVCProtocols.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 01/08/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import Foundation

protocol MenuVCDelegate {
    func receivedCommand(command: String, peerID: String)
}
