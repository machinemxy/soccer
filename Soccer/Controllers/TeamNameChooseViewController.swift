//
//  TeamNameChooseViewController.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/14.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit

class TeamNameChooseViewController: UIViewController {
	@IBOutlet weak var lblBadge: UILabel!
	@IBOutlet weak var lblTeam: UILabel!
	@IBOutlet weak var btnProceed: UIButton!
	
	@IBAction func randomizeBadgeAndName(_ sender: Any) {
		//randomize badge
		lblBadge.text = BadgeGenerator.pickBadge()
		
		//randomize team name
		var teamName = ""
		for _ in 1...3 {
			teamName += LetterGenerator.pickLetter()
		}
		lblTeam.text = teamName
		
		//enable proceed button
		btnProceed.isEnabled = true
	}
	
	@IBAction func proceed(_ sender: Any) {
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.set(lblBadge.text! + lblTeam.text!, forKey: "test")
    }

}
