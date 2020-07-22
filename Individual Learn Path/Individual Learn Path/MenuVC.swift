//
//  MenuVC.swift
//  Individual Learn Path
//
//  Created by Kauê Sales on 17/07/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import UIKit

enum gameMode {
    case easy
    case medium
    case hard
    case localMultiplayer
    case p2pMultiplayer
}

class MenuVC: UIViewController {
    
    @IBAction func play(_ sender: Any) {
        moveToGame(game: .easy)
    }
    
    //Receives a game mode and starts the game.
    func moveToGame(game: gameMode){
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        currentGameMode = game
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
}

