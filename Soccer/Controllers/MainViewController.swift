//
//  MainViewController.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/15.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import StoreKit

class MainViewController: UIViewController {
	@IBOutlet weak var txtInfo: UITextView!
	@IBOutlet weak var btnNextGame: UIButton!
	@IBOutlet weak var btnTeamManage: UIButton!
	@IBOutlet weak var btnScout: UIButton!
	@IBOutlet weak var btnExtra: UIButton!
	
	var gameData: GameData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Light Football Manager"

		//try to get the gameData
		let realm = try! Realm()
		let countOfGameData = realm.objects(GameData.self).count
		if countOfGameData == 0 {
			//the first time launching the app
			setUIForPickTeam()
			return
		}
		showGameData()
    }

	@IBAction func nextGame(_ sender: Any) {
		switch btnNextGame.title(for: .normal) {
		case "Create Team":
			performSegue(withIdentifier: "toTeamNameChooseFromMain", sender: nil)
		case "Next Game":
			performSegue(withIdentifier: "toPreviewFromMain", sender: nil)
		case "Next Season":
			nextSeason()
		default:
			return
		}
	}
    
    @IBAction func scout(_ sender: Any) {
        let scoutedPlayer = PlayerGenerator.scout(leagueLv: gameData.leagueLv)
        let realm = try! Realm()
        try! realm.write {
            gameData.scout -= 1
            realm.add(scoutedPlayer)
        }
        
        //btnScout
        btnScout.setTitle("Scout(\(gameData.scout))", for: .normal)
        btnScout.isEnabled = gameData.scout > 0
        
        alert(title: "Scout Result", message: "[\(scoutedPlayer.position)]\(scoutedPlayer.name) \(scoutedPlayer.rating)")
    }
    
    
	// MARK: - Navigation
	@IBAction func unwindToMain(segue: UIStoryboardSegue) {
		if segue.identifier == "unwindToMainFromTeamNameChoose" {
			resetUIAfterPickTeam()
        } else if segue.identifier == "unwindToMainFromResult" {
            removeInjuredPlayerFromLineUp()
        }
		showGameData()
	}
	
	private func setUIForPickTeam() {
		txtInfo.text = """
		Welcome to Light Football Manager!
		Please create your team first!
		"""
		btnNextGame.setTitle("Create Team", for: .normal)
		btnTeamManage.isEnabled = false
		btnScout.isEnabled = false
		btnExtra.isEnabled = false
	}
	
	private func resetUIAfterPickTeam() {
		btnTeamManage.isEnabled = true
		btnExtra.isEnabled = true
	}
    
    private func removeInjuredPlayerFromLineUp() {
        let realm = try! Realm()
        let injuredPlayersInLineUp = realm.objects(Player.self).filter { (player) -> Bool in
            player.inLineUp && player.injuryTime > 0
        }
        if injuredPlayersInLineUp.count > 0 {
            try! realm.write {
                for injuredPlayer in injuredPlayersInLineUp {
                    injuredPlayer.inLineUp = false
                }
            }
        }
    }
	
	private func showGameData() {
		let realm = try! Realm()
		gameData = realm.objects(GameData.self).first
		
		//txtInfo
		var info = "\(gameData.teamName)\n"
		info += "League Lv: \(gameData.leagueLvDescription)\n"
		if gameData.week > 10 {
			info += "Season ended. "
			if gameData.points < gameData.pointsToStay {
				info += "Your team got relegated."
			} else if gameData.points >= gameData.pointsToPromote {
				if gameData.leagueLv == gameData.maxLeagueLv {
					info += "Congratulations! Your team won the world champion!"
				} else {
					info += "Your team got promoted!"
				}
			} else {
				info += "Your team got stayed."
			}
			info += "\n"
		} else {
			info += "Weeks: \(gameData.week)/10\n"
		}
		info += "Points: \(gameData.points) (W\(gameData.win)/D\(gameData.draw)/L\(gameData.lose))\n"
		info += "Points to Stay: \(gameData.pointsToStay)\n"
		if gameData.leagueLv < gameData.maxLeagueLv {
			info += "Points to Upgrade: \(gameData.pointsToPromote)"
		} else {
			info += "Points to World Champion: \(gameData.pointsToPromote)"
		}
		txtInfo.text = info
		
		//btnNextGame
		if gameData.week > 10 {
			btnNextGame.setTitle("Next Season", for: .normal)
		} else {
			btnNextGame.setTitle("Next Game", for: .normal)
		}
		
		//btnScout
		btnScout.setTitle("Scout(\(gameData.scout))", for: .normal)
		btnScout.isEnabled = gameData.scout > 0
	}
	
	private func nextSeason() {
		let realm = try! Realm()
		let gameData = realm.objects(GameData.self).first!
		if gameData.scout > 0 {
			alert(title: "Scout Report Left", message: "Please check your scout report before entering next season.")
			return
		}
		
		//reset gameData
		try! realm.write {
			if gameData.points < gameData.pointsToStay {
				gameData.leagueLv -= 1
			} else if gameData.points >= gameData.pointsToPromote {
				if gameData.leagueLv == gameData.maxLeagueLv {
					let startIndex = gameData.teamName.index(gameData.teamName.startIndex, offsetBy: 1)
					let subTeamName = String(gameData.teamName[startIndex...])
					gameData.teamName = "👑" + subTeamName
				} else {
					gameData.leagueLv += 1
				}
			}
			
			gameData.week = 1
			gameData.win = 0
			gameData.draw = 0
			gameData.lose = 0
		}
        
        //ask user to rate the app
        let llv = gameData.leagueLv
        if llv % 3 == 0 {
            SKStoreReviewController.requestReview()
        }
		
		showGameData()
	}
}
