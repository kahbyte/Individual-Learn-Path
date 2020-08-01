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
}

