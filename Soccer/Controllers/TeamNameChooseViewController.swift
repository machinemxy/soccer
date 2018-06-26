//
//  TeamNameChooseViewController.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/14.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class TeamNameChooseViewController: UIViewController {
	var teamBadge = ""
	var teamName = ""
	@IBOutlet weak var txtInfo: UITextView!
	@IBOutlet weak var btnDecide: UIButton!
	
	@IBAction func randomizeBadgeAndName(_ sender: Any) {
		//randomize badge
		teamBadge = BadgeGenerator.pickBadge()
		
		//randomize team name
		var tempName = ""
		for _ in 1...3 {
			tempName += LetterGenerator.pickLetter()
		}
		teamName = tempName
		
		//set txtInfo
		fillTxtInfo()
		
		//enable proceed button
		btnDecide.isEnabled = true
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		fillTxtInfo()
    }

	private func fillTxtInfo() {
		let info = """
		Press "Randomize" to generate randomly.
		
		Badge: \(teamBadge)
		Name: \(teamName)
		"""
		txtInfo.text = info
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//generate gameData
		let gameData = GameData()
		gameData.teamName = teamBadge + teamName
		
		//generate default players
		let players = PlayerGenerator.generateTeam(leagueLv: 1)
		
		let realm = try! Realm()
		try! realm.write {
			//save gameData
			realm.add(gameData)
			
			//save default players
			realm.add(players)
		}
	}
}
