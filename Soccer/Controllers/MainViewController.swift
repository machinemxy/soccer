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
		if btnNextGame.title(for: .normal) == "Pick Team" {
			performSegue(withIdentifier: "toTeamNameChooseFromMain", sender: nil)
		}
	}
	// MARK: - Navigation
	@IBAction func unwindToMain(segue: UIStoryboardSegue) {
		if segue.identifier == "unwindToMainFromTeamNameChoose" {
			resetUIAfterPickTeam()
		}
		showGameData()
	}

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
