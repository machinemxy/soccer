//
//  TeamTableViewController.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/25.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class TeamTableViewController: UITableViewController {
	var lineUp: [Player]!
	var sub: [Player]!

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
		lineUp = realm.objects(Player.self).filter("inLineUp = true").sorted(by: { (p1, p2) -> Bool in
			return p1.positionOrder < p2.positionOrder
		})
		sub = realm.objects(Player.self).filter("inLineUp = false").sorted(by: { (p1, p2) -> Bool in
			return p1.rating > p2.rating
		})
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Lineup"
		} else {
			return "Sub"
		}
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if section == 0 {
			return lineUp.count
		} else {
			return sub.count
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)

        //get player
		let player: Player
		if indexPath.section == 0 {
			player = lineUp[indexPath.row]
		} else {
			player = sub[indexPath.row]
		}
		
		//set cell
		cell.imageView?.image = player.gradeMark
		cell.textLabel?.text = "\(player.name)[\(player.position)]\(player.rating)"
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
