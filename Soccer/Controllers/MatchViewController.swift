//
//  MatchViewController.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/12.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
	@IBOutlet weak var lblTime: UILabel!
	@IBOutlet var lblTeams: [UILabel]!
	@IBOutlet var lblScores: [UILabel]!
	@IBOutlet var textLogs: [UITextView]!
	
	var time = 0 {
		didSet {
			lblTime.text = "\(time)'"
		}
	}
	var sides: [Side]!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		//test: set two sides' abilities
		sides = [
			Side(teamName: "Team1", abilities: [
				Ability(off: 10, org: 20, def: 30),
				Ability(off: 40, org: 50, def: 60),
				Ability(off: 70, org: 80, def: 90)
			]),
			Side(teamName: "Team2", abilities: [
				Ability(off: 90, org: 80, def: 70),
				Ability(off: 60, org: 50, def: 40),
				Ability(off: 30, org: 20, def: 10)
			]),
		]
		
		//set team name
		for i in 0...1 {
			lblTeams[i].text = sides[i].teamName
		}
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	@IBAction func proceed(_ sender: Any) {
		if time >= 90 {
			//show time up alert
			let alert = UIAlertController(title: "Time Up", message: nil, preferredStyle: .alert)
			let action = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(action)
			self.present(alert, animated: true, completion: nil)
			
			return
		}
		
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
			textLogs[offSide].text! += "⚽️ \(goalTime)' \(goalDirection)\n"
			textLogs[defSide].text! += "\n"
		}
	}
}
