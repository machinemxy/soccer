//
//  PreviewViewController.swift
//  Soccer
//
//  Created by 马学渊 on 2018/07/07.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class PreviewViewController: UIViewController {
	@IBOutlet weak var lblTeam1: UILabel!
	@IBOutlet weak var lblLdf1: UILabel!
	@IBOutlet weak var lblCdf1: UILabel!
	@IBOutlet weak var lblRdf1: UILabel!
	@IBOutlet weak var lblLog1: UILabel!
	@IBOutlet weak var lblCog1: UILabel!
	@IBOutlet weak var lblRog1: UILabel!
	@IBOutlet weak var lblLof1: UILabel!
	@IBOutlet weak var lblCof1: UILabel!
	@IBOutlet weak var lblRof1: UILabel!
	@IBOutlet weak var lblTeam2: UILabel!
	@IBOutlet weak var lblLdf2: UILabel!
	@IBOutlet weak var lblCdf2: UILabel!
	@IBOutlet weak var lblRdf2: UILabel!
	@IBOutlet weak var lblLog2: UILabel!
	@IBOutlet weak var lblCog2: UILabel!
	@IBOutlet weak var lblRog2: UILabel!
	@IBOutlet weak var lblLof2: UILabel!
	@IBOutlet weak var lblCof2: UILabel!
	@IBOutlet weak var lblRof2: UILabel!
	
	var sides: [Side]!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
		let gameData = realm.objects(GameData.self).first!
		let myPlayers: [Player] = realm.objects(Player.self).filter( { (player) -> Bool in
			return player.inLineUp
		})
		
		//add player's team into sides
		sides = [Side]()
		sides.append(Side(teamName: gameData.teamName, players: myPlayers))
		
        //check if nextEnemyTeam exist
        let nextEnemyTeams = realm.objects(NextEnemyTeam.self)
        if nextEnemyTeams.count > 0 {
            sides.append(Side(nextEnemyTeam: nextEnemyTeams.first!))
            try! realm.write {
                realm.delete(nextEnemyTeams)
            }
        } else {
            //generate cpu's team and add into sides
            let cpuTeamName = TeamNameGenerator.pickTeamName()
            let cpuPlayers = PlayerGenerator.generateTeam(leagueLv: gameData.leagueLv)
            sides.append(Side(teamName: cpuTeamName, players: cpuPlayers))
        }
        
		//setUI
		setUI()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toMatchFromPreview" {
            //week + 1
            let realm = try! Realm()
            let gameData = realm.objects(GameData.self).first!
            try! realm.write {
                gameData.week += 1
            }
            
			let target = segue.destination as! MatchViewController
			target.sides = sides
        } else if segue.identifier == "unwindToMainFromPreview" {
            saveEnemyTeam()
        }
    }

	private func setUI() {
		lblTeam1.text = sides[0].teamName + "(\(sides[0].overall))"
		lblLdf1.text = "\(sides[0].abilities[0].def)"
		lblCdf1.text = "\(sides[0].abilities[1].def)"
		lblRdf1.text = "\(sides[0].abilities[2].def)"
		lblLog1.text = "\(sides[0].abilities[0].org)"
		lblCog1.text = "\(sides[0].abilities[1].org)"
		lblRog1.text = "\(sides[0].abilities[2].org)"
		lblLof1.text = "\(sides[0].abilities[0].off)"
		lblCof1.text = "\(sides[0].abilities[1].off)"
		lblRof1.text = "\(sides[0].abilities[2].off)"
		
		lblTeam2.text = sides[1].teamName + "(\(sides[1].overall))"
		lblLdf2.text = "\(sides[1].abilities[0].def)"
		lblCdf2.text = "\(sides[1].abilities[1].def)"
		lblRdf2.text = "\(sides[1].abilities[2].def)"
		lblLog2.text = "\(sides[1].abilities[0].org)"
		lblCog2.text = "\(sides[1].abilities[1].org)"
		lblRog2.text = "\(sides[1].abilities[2].org)"
		lblLof2.text = "\(sides[1].abilities[0].off)"
		lblCof2.text = "\(sides[1].abilities[1].off)"
		lblRof2.text = "\(sides[1].abilities[2].off)"
	}
    
    private func saveEnemyTeam() {
        let nextEnemyTeam = NextEnemyTeam()
        let enemySide = sides[1]
        nextEnemyTeam.teamName = enemySide.teamName
        nextEnemyTeam.ldef = enemySide.abilities[0].def
        nextEnemyTeam.lorg = enemySide.abilities[0].org
        nextEnemyTeam.loff = enemySide.abilities[0].off
        nextEnemyTeam.cdef = enemySide.abilities[1].def
        nextEnemyTeam.corg = enemySide.abilities[1].org
        nextEnemyTeam.coff = enemySide.abilities[1].off
        nextEnemyTeam.rdef = enemySide.abilities[2].def
        nextEnemyTeam.rorg = enemySide.abilities[2].org
        nextEnemyTeam.roff = enemySide.abilities[2].off
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(nextEnemyTeam)
        }
    }
}
