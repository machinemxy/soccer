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
    enum NextStatus {
        case createTeam
        case nextGame
        case nextSeason
    }
    
	@IBOutlet weak var txtInfo: UITextView!
	@IBOutlet weak var btnNextGame: UIButton!
	@IBOutlet weak var btnTeamManage: UIButton!
	@IBOutlet weak var btnScout: UIButton!
	@IBOutlet weak var btnExtra: UIButton!
    @IBOutlet var btnInjuryReport: UIButton!
    
	var gameData: GameData!
    var nextStatus = NextStatus.createTeam

    override func viewDidLoad() {
        super.viewDidLoad()

		//try to get the gameData
		let realm = try! Realm()
		let countOfGameData = realm.objects(GameData.self).count
		if countOfGameData == 0 {
			//the first time launching the app
			setUIForPickTeam()
        } else {
            showGameData()
        }
    }

	@IBAction func nextGame(_ sender: Any) {
		switch nextStatus {
        case .createTeam:
			performSegue(withIdentifier: "toTeamNameChooseFromMain", sender: nil)
        case .nextGame:
            let realm = try! Realm()
            let countOfPlayer = realm.objects(Player.self).filter { (p) -> Bool in
                p.inLineUp
            }.count
            if countOfPlayer < 11 {
                let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Less than 11", comment: ""), preferredStyle: .alert)
                let yes = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (_) in
                    self.presentWithFullScreen(storyboardId: "preview", handler: nil)
                }
                let no = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default, handler: nil)
                alert.addAction(yes)
                alert.addAction(no)
                present(alert, animated: true)
            } else {
                presentWithFullScreen(storyboardId: "preview", handler: nil)
            }
        case .nextSeason:
			nextSeason()
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
        btnScout.setTitle(NSLocalizedString("Scout", comment: "") + "(\(gameData.scout))", for: .normal)
        btnScout.isEnabled = gameData.scout > 0
        
        alert(title: NSLocalizedString("Scout Result", comment: ""), message: "[\(scoutedPlayer.position)]\(scoutedPlayer.name) \(scoutedPlayer.rating)")
    }
    
    @IBAction func showInjuryReport(_ sender: Any) {
        let realm = try! Realm()
        var countOfInjuryReport = realm.objects(InjuryReport.self).count
        guard let injuryReport = realm.objects(InjuryReport.self).first else {return}
        alert(title: injuryReport.title, message: injuryReport.message)
        
        // delete current injury report
        try! realm.write {
            realm.delete(injuryReport)
        }
        countOfInjuryReport -= 1
        
        btnInjuryReport.setTitle(NSLocalizedString("Injury Report", comment: "") + "(\(countOfInjuryReport))", for: .normal)
        btnInjuryReport.isEnabled = countOfInjuryReport > 0
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
		txtInfo.text = NSLocalizedString("Welcome", comment: "")
        nextStatus = .createTeam
		btnNextGame.setTitle(NSLocalizedString("Create Team", comment: ""), for: .normal)
		btnTeamManage.isEnabled = false
		btnScout.isEnabled = false
		btnExtra.isEnabled = false
        btnInjuryReport.isEnabled = false
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
		setTxtInfo()
		
		//btnNextGame
		if gameData.week > 10 {
            nextStatus = .nextSeason
			btnNextGame.setTitle(NSLocalizedString("Next Season", comment: ""), for: .normal)
		} else {
            nextStatus = .nextGame
			btnNextGame.setTitle(NSLocalizedString("Next Game", comment: ""), for: .normal)
		}
		
		//btnScout
		btnScout.setTitle(NSLocalizedString("Scout", comment: "") + "(\(gameData.scout))", for: .normal)
		btnScout.isEnabled = gameData.scout > 0
        
        //btnInjuryReport
        let countOfInjuryReport = realm.objects(InjuryReport.self).count
        btnInjuryReport.setTitle(NSLocalizedString("Injury Report", comment: "") + "(\(countOfInjuryReport))", for: .normal)
        btnInjuryReport.isEnabled = countOfInjuryReport > 0
	}
    
    private func setTxtInfo() {
        //txtInfo
        var info = "\(gameData.teamName)\n"
        info += NSLocalizedString("League Lv: ", comment: "")
        info += "\(gameData.leagueLvDescription)\n"
        if gameData.week > 10 {
            info += NSLocalizedString("Season ended. ", comment: "")
            if gameData.points < gameData.pointsToStay {
                info += NSLocalizedString("Relegated", comment: "")
            } else if gameData.points >= gameData.pointsToPromote {
                if gameData.leagueLv == gameData.maxLeagueLv {
                    info += NSLocalizedString("World champion", comment: "")
                } else {
                    info += NSLocalizedString("Promoted", comment: "")
                }
            } else {
                info += NSLocalizedString("Stayed", comment: "")
            }
            info += "\n"
        } else {
            info += NSLocalizedString("Weeks: ", comment: "")
            info += "\(gameData.week)/10\n"
        }
        info += NSLocalizedString("Points: ", comment: "")
        info += "\(gameData.points) (W\(gameData.win)/D\(gameData.draw)/L\(gameData.lose))\n"
        info += NSLocalizedString("Points to Stay: ", comment: "")
        info += "\(gameData.pointsToStay)\n"
        if gameData.leagueLv < gameData.maxLeagueLv {
            info += NSLocalizedString("Points to Upgrade: ", comment: "")
            info += "\(gameData.pointsToPromote)"
        } else {
            info += NSLocalizedString("Points to World Champion: ", comment: "")
            info += "\(gameData.pointsToPromote)"
        }
        txtInfo.text = info
    }
	
	private func nextSeason() {
		let realm = try! Realm()
		let gameData = realm.objects(GameData.self).first!
		if gameData.scout > 0 {
			alert(title: NSLocalizedString("Scout Report Left", comment: ""), message: NSLocalizedString("Check scout hint", comment: ""))
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
