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
	var sides: [Side]!
    var timer: Timer!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//set team name
		for i in 0...1 {
			lblTeams[i].text = sides[i].teamName
		}
        
        //shedule timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (_) in
            self.proceed()
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultFromMatch" {
            let realm = try! Realm()
            let gameData = realm.objects(GameData.self).first!
            try! realm.write {
                //judge match result
                if sides[0].score > sides[1].score {
                    gameData.win += 1
                } else if sides[0].score == sides[1].score {
                    gameData.draw += 1
                } else {
                    gameData.lose += 1
                }
                
                //add scout
                if UserDefaults.standard.bool(forKey: "PremiumManager") {
                    gameData.scout += 1
                } else if gameData.week % 2 == 1 {
                    gameData.scout += 1
                }
            }
        }
    }
    
	private func proceed() {
		//time proceeded
		time += 10
		
		//randomize ball direction
		let direction = Int(randomBelow: 3)
		sides[0].direction = direction
		sides[1].direction = 2 - direction
		
		//randomize which side get the ball
		var sideWhoGetBall = Int(randomBelow: 4)
		if sideWhoGetBall > 1 {
			//use org ability to decide
			let sumOrg = sides[0].currentAbility.org + sides[1].currentAbility.org
			let randOrg = Int(randomBelow: sumOrg)
			if randOrg < sides[0].currentAbility.org {
				sideWhoGetBall = 0
			} else {
				sideWhoGetBall = 1
			}
		}
		
		//perform the offence
		let offSide = sideWhoGetBall
		let defSide = 1 - sideWhoGetBall
		let offPower = Int(randomBelow: sides[offSide].currentAbility.off * 2)
		let defPower = sides[defSide].currentAbility.def
		if offPower >= defPower {
			//goal
			sides[offSide].score += 1
			let goalTime = time - Int(randomBelow: 10)
			let strGoalTime = goalTime < 10 ? " \(goalTime)'" : "\(goalTime)'"
			let goalDirection: String
			switch sides[offSide].direction {
			case 0:
				goalDirection = "Left"
			case 1:
				goalDirection = "Center"
			default:
				goalDirection = "Right"
			}
			
			//update ui
			lblScores[offSide].text = "\(sides[offSide].score)"
			textLogs[offSide].text! += "⚽️\(strGoalTime) \(goalDirection)\n"
			textLogs[defSide].text! += "\n"
		}
        
        if time >= 90 {
            timer.invalidate()
            btnProceed.isEnabled = true
        }
	}
}
