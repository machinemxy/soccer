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

class MainViewController: UIViewController {
	@IBOutlet weak var txtInfo: UITextView!
	@IBOutlet weak var btnNextGame: UIButton!
	@IBOutlet weak var btnTeamManage: UIButton!
	@IBOutlet weak var btnScout: UIButton!
	@IBOutlet weak var btnExtra: UIButton!
	
	var gameData: GameData!

    override func viewDidLoad() {
        super.viewDidLoad()

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
		case "Pick Team":
			performSegue(withIdentifier: "toTeamNameChooseFromMain", sender: nil)
		case "Next Game":
			performSegue(withIdentifier: "toPreviewFromMain", sender: nil)
		default:
			return
		}
	}
	// MARK: - Navigation
	@IBAction func unwindToMain(segue: UIStoryboardSegue) {
		if segue.identifier == "unwindToMainFromTeamNameChoose" {
			resetUIAfterPickTeam()
		}
		showGameData()
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toPreviewFromMain" {
			//week + 1
			let realm = try! Realm()
			let gameData = realm.objects(GameData.self).first!
			try! realm.write {
				gameData.week += 1
			}
		}
    }
	
	private func setUIForPickTeam() {
		txtInfo.text = """
		Welcome to Light Football Manager!
		Please pick your team badge and name first!
		"""
		btnNextGame.setTitle("Pick Team", for: .normal)
		btnTeamManage.isEnabled = false
		btnScout.isEnabled = false
		btnExtra.isEnabled = false
	}
	
	private func resetUIAfterPickTeam() {
		btnNextGame.setTitle("Next Game", for: .normal)
		btnTeamManage.isEnabled = true
		btnExtra.isEnabled = true
	}
	
	private func showGameData() {
		let realm = try! Realm()
		gameData = realm.objects(GameData.self).first
		
		//txtInfo
		txtInfo.text = """
		\(gameData.teamName)
		League Lv: \(gameData.leagueLv)
		Weeks: \(gameData.week)/10
		Points: \(gameData.points) (W\(gameData.win)/D\(gameData.draw)/L\(gameData.lose))
		Points to Stay: \(gameData.pointsToStay)
		Points to Upgrade: \(gameData.pointsToUpgrade)
		"""
		
		//btnScout
		btnScout.setTitle("Scout(\(gameData.scout))", for: .normal)
		btnScout.isEnabled = gameData.scout > 0
	}
}
