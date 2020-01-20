//
//  MatchViewController.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/12.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class MatchViewController: UIViewController {
	@IBOutlet weak var lblTime: UILabel!
	@IBOutlet var lblTeams: [UILabel]!
	@IBOutlet var lblScores: [UILabel]!
	@IBOutlet var textLogs: [UITextView]!
    @IBOutlet weak var btnProceed: UIButton!
    
	var time = 0 {
		didSet {
			lblTime.text = "\(time)'"
		}
	}
    var teams: [Team]!
    var timer: Timer!
    var side = 0
    var revertSide: Int {
        2 - side
    }
    var scores = [0, 0] {
        didSet {
            lblScores[0].text = "\(scores[0])"
            lblScores[1].text = "\(scores[1])"
        }
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//set team name
		for i in 0...1 {
			lblTeams[i].text = teams[i].teamName
		}
        
        //shedule timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (_) in
            self.proceed()
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toResultFromMatch" {
//            let realm = try! Realm()
//            let gameData = realm.objects(GameData.self).first!
//            try! realm.write {
//                //judge match result
//                if sides[0].score > sides[1].score {
//                    gameData.win += 1
//                } else if sides[0].score == sides[1].score {
//                    gameData.draw += 1
//                } else {
//                    gameData.lose += 1
//                }
//
//                //add scout
//                if UserDefaults.standard.bool(forKey: "PremiumManager") {
//                    gameData.scout += 1
//                } else if gameData.week % 2 == 1 {
//                    gameData.scout += 1
//                }
//            }
//        }
    }
    
	private func proceed() {
		//time proceeded
		time += 10
		
		//randomize ball direction
		side = Int(randomBelow: 3)
		
		//randomize which side get the ball
		var whoGetBall = Int(randomBelow: 4)
		if whoGetBall > 1 {
			//use org ability to decide
            let myOrg = teams[0].abilities[side].org
            let enemyOrg = teams[1].abilities[revertSide].org
            let sumOrg = myOrg + enemyOrg
			let randOrg = Int(randomBelow: sumOrg)
			if randOrg < myOrg {
				whoGetBall = 0
			} else {
				whoGetBall = 1
			}
		}
		
        // perform the attack
        let isPlayerAttack = whoGetBall == 0
        var goal = false
        var goalPlayer: Player?
        if isPlayerAttack {
            let offPower = Int(randomBelow: teams[0].abilities[side].off * 2)
            let defPower = teams[1].abilities[revertSide].def
            if offPower >= defPower {
                goal = true
                goalPlayer = teams[0].getPlayerWhoGoaled(side: side)
                let realm = try! Realm()
                try! realm.write {
                    goalPlayer?.goal += 1
                }
            }
        } else {
            let offPower = Int(randomBelow: teams[1].abilities[revertSide].off * 2)
            let defPower = teams[0].abilities[side].def
            if offPower >= defPower {
                goal = true
                goalPlayer = teams[1].getPlayerWhoGoaled(side: revertSide)
            }
        }
        
        if goal {
            //change score
            scores[whoGetBall] += 1
            
            // append goal log
            let goalTime = time - Int(randomBelow: 10)
            let goalPlayer = goalPlayer!
            textLogs[whoGetBall].text! += "⚽️\(goalTime)' [\(goalPlayer.position)]\(goalPlayer.name)\n"
            textLogs[1 - whoGetBall].text! += "\n"
		}
        
        if time >= 90 {
            timer.invalidate()
            btnProceed.isEnabled = true
        }
	}
}
