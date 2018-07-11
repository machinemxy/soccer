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

		//get players
		let realm = try! Realm()
		players = realm.objects(Player.self).filter("inLineUp = true").sorted(by: { (p1, p2) -> Bool in
			return p1.positionOrder < p2.positionOrder
		})
		
		//player growth
		try! realm.write {
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
						growths.append("(LDF+1)")
					} else if randNumber < player.ldf + player.cdf {
						player.cdf += 1
						growths.append("(CDF+1)")
					} else {
						player.rdf += 1
						growths.append("(RDF+1)")
					}
				} else {
					if randNumber < player.def {
						player.def += 1
						growths.append("(DEF+1)")
					} else if randNumber < player.def + player.org {
						player.org += 1
						growths.append("(ORG+1)")
					} else {
						player.off += 1
						growths.append("(OFF+1)")
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
		return "Player Growth"
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
		cell.textLabel?.text = "[\(player.position)]\(player.name) \(player.rating)\(growth)"
		if player.verticalPosition == "GK" {
			cell.detailTextLabel?.text = "LDF:\(player.ldf) CDF:\(player.cdf) RDF:\(player.rdf) POT:\(player.potentialPredict)"
		} else {
			cell.detailTextLabel?.text = "OFF:\(player.off) ORG:\(player.org) DEF:\(player.def) POT:\(player.potentialPredict)"
		}

        return cell
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
