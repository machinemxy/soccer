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
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet var lblLetters: [UILabel]!
    
    var badgeIndex = 0 {
        didSet {
            lblBadge.text = TeamNameGenerator.badges[badgeIndex]
        }
    }
    
    var letterIndexs = [0, 0, 0] {
        didSet {
            for i in 0...2 {
                lblLetters[i].text = TeamNameGenerator.getLetter(index: letterIndexs[i])
            }
        }
    }
    
    @IBAction func reduceBadgeIndex(_ sender: Any) {
        if badgeIndex == 0 {
            badgeIndex = TeamNameGenerator.badges.count - 1
        } else {
            badgeIndex -= 1
        }
    }
    
    @IBAction func increaseBadgeIndex(_ sender: Any) {
        if badgeIndex == TeamNameGenerator.badges.count - 1 {
            badgeIndex = 0
        } else {
            badgeIndex += 1
        }
    }
    
    @IBAction func increaseLetterIndex(_ sender: UIButton) {
        if letterIndexs[sender.tag] == TeamNameGenerator.letters.count - 1 {
            letterIndexs[sender.tag] = 0
        } else {
            letterIndexs[sender.tag] += 1
        }
    }
    
    @IBAction func reduceLetterIndex(_ sender: UIButton) {
        if letterIndexs[sender.tag] == 0 {
            letterIndexs[sender.tag] = TeamNameGenerator.letters.count - 1
        } else {
            letterIndexs[sender.tag] -= 1
        }
    }
    
	@IBAction func randomizeBadgeAndName(_ sender: Any) {
		badgeIndex = Int(randomBelow: TeamNameGenerator.badges.count)
        for i in 0...2 {
            letterIndexs[i] = Int(randomBelow: TeamNameGenerator.letters.count)
        }
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//generate gameData
		let gameData = GameData()
        
        //set teamName
        var teamName = ""
        teamName.append(lblBadge.text!)
        for i in 0...2 {
            teamName.append(lblLetters[i].text!)
        }
		gameData.teamName = teamName
		
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
