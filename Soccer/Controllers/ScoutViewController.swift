//
//  ScoutViewController.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/27.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class ScoutViewController: UIViewController {
	@IBOutlet weak var txtInfo: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		let realm = try! Realm()
		let gameData = realm.objects(GameData.self).first!
		let leagueLv = gameData.leagueLv
		let scout = gameData.scout
		var players = [Player]()
		for _ in 1...scout {
			players.append(PlayerGenerator.scout(leagueLv: leagueLv))
		}
		
		//save
		try! realm.write {
			gameData.scout = 0
			realm.add(players)
		}
		
		//show info
		var info = """
		Your scout bring these players to you: 
		"""
		for player in players {
			info += "\n\(player.name)[\(player.position)]\(player.rating)"
		}
		txtInfo.text = info
    }
}
