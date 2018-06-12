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
	
	var time = 0
	var sides: [Side]!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
	}
}
