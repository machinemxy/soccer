//
//  ResultTableViewController.swift
//  Soccer
//
//  Created by 马学渊 on 2018/07/10.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class ResultTableViewController: UITableViewController {
	var players: [Player]!
	var growths: [String]!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        let allPlayers = realm.objects(Player.self)
        
        try! realm.write {
            //players recovery from injury
            for player in allPlayers {
                if player.injuryTime > 0 {
                    player.injuryTime -= 1
                    
                    if player.injuryTime == 0 {
                        let recoveryReport = InjuryReport.createInjuryReport(reportType: 1, player: player)
                        realm.add(recoveryReport)
                    }
                }
            }
            
            //get players
            players = allPlayers.filter("inLineUp = true").sorted(by: { (p1, p2) -> Bool in
                return p1.positionOrder < p2.positionOrder
            })
            
            //player injury
            let injured = Int(randomBelow: 10)
            if injured == 0 && players.count > 0{
                let injuredPlayerId = Int(randomBelow: players.count)
                var maxInjuredPeriod = 10
                if UserDefaults.standard.bool(forKey: "PremiumManager") {
                    maxInjuredPeriod /= 2
                }
                players[injuredPlayerId].injuryTime = Int(randomBelow: maxInjuredPeriod) + 1
                let injuryReport = InjuryReport.createInjuryReport(reportType: 0, player: players[injuredPlayerId])
                realm.add(injuryReport)
            }
            
            //player growth
            growths = [String]()
            for player in players {
                //if player has no potential, no growth
                if player.potential <= 0 {
                    growths.append("")
                    continue
                }
                
                //reduce potential
                player.potential -= 1
                
                //add ability
                let randNumber = Int(randomBelow: player.rating)
                if player.verticalPosition == "GK" {
                    if randNumber < player.ldf {
                        player.ldf += 1
                        growths.append("(LDF⤴️)")
                    } else if randNumber < player.ldf + player.cdf {
                        player.cdf += 1
                        growths.append("(CDF⤴️)")
                    } else {
                        player.rdf += 1
                        growths.append("(RDF⤴️)")
                    }
                } else {
                    if randNumber < player.def {
                        player.def += 1
                        growths.append("(DEF⤴️)")
                    } else if randNumber < player.def + player.org {
                        player.org += 1
                        growths.append("(ORG⤴️)")
                    } else {
                        player.off += 1
                        growths.append("(OFF⤴️)")
                    }
                }
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Player Growth", comment: "")
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let player = players[indexPath.row]
		let growth = growths[indexPath.row]
		
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)

		//set cell
		cell.imageView?.image = player.gradeMark
        cell.textLabel?.text = player.brief + growth
        cell.detailTextLabel?.text = player.detail

        return cell
    }
}
