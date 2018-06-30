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

		setLineUpAndSub()
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
		let player = getPlayer(indexPath: indexPath)
		
		//set cell
		cell.imageView?.image = player.gradeMark
		cell.textLabel?.text = "[\(player.position)]\(player.name) \(player.rating)"
		if player.verticalPosition == "GK" {
			cell.detailTextLabel?.text = "LDF:\(player.ldf) CDF:\(player.cdf) RDF:\(player.rdf) POT:\(player.potentialPredict)"
		} else {
			cell.detailTextLabel?.text = "OFF:\(player.off) ORG:\(player.org) DEF:\(player.def) POT:\(player.potentialPredict)"
		}
		
        return cell
    }

	//Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//get player
		let player = getPlayer(indexPath: indexPath)
		
		let moveTitle = player.inLineUp ? "Move to Sub" : "Move to Lineup"
		//show action sheet
		let actionSheet = UIAlertController(title: "Action", message: "", preferredStyle: .actionSheet)
		let moveAction = UIAlertAction(title: moveTitle, style: .default) { (_) in
			self.movePlayer(player: player)
		}
		let trainAction = UIAlertAction(title: "Train", style: .default) { (_) in
			//code
		}
		let sacrificeAction = UIAlertAction(title: "Sacrifice", style: .destructive) { (_) in
			//code
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		actionSheet.addAction(moveAction)
		actionSheet.addAction(trainAction)
		actionSheet.addAction(sacrificeAction)
		actionSheet.addAction(cancelAction)
		
		//iPad crash avoid
		actionSheet.popoverPresentationController?.sourceView = view
		actionSheet.popoverPresentationController?.sourceRect = self.tableView(tableView, cellForRowAt: indexPath).frame
		self.present(actionSheet, animated: true, completion: nil)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	//private
	private func setLineUpAndSub() {
		let realm = try! Realm()
		lineUp = realm.objects(Player.self).filter("inLineUp = true").sorted(by: { (p1, p2) -> Bool in
			return p1.positionOrder < p2.positionOrder
		})
		sub = realm.objects(Player.self).filter("inLineUp = false").sorted(by: { (p1, p2) -> Bool in
			return p1.rating > p2.rating
		})
	}
	
	private func getPlayer(indexPath: IndexPath) -> Player {
		let player: Player
		if indexPath.section == 0 {
			player = lineUp[indexPath.row]
		} else {
			player = sub[indexPath.row]
		}
		return player
	}
	
	private func alert(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(alertAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	private func movePlayer(player: Player) {
		let realm = try! Realm()
		
		if player.inLineUp {
			//move player to sub
			try! realm.write {
				player.inLineUp = false
			}
		} else {
			//judge if the lineup already has 11 players
			if lineUp.count >= 11 {
				alert(title: "Illegal Lineup", message: "Your lineup already has 11 players. Please move somebody to sub first.")
				return
			}
			
			//in lineup GK and each side position allowed 1 player at max but 3 players at max in each center position
			//judge is the lineup break that rule
			let maxPlayer: Int
			if player.verticalPosition == "GK" {
				maxPlayer = 1
			} else if player.horizonPosition == "C" {
				maxPlayer = 3
			} else {
				maxPlayer = 1
			}
			let playerCountSamePosition = realm.objects(Player.self).filter("inLineUp = true && verticalPosition = %@ && horizonPosition = %@ ", player.verticalPosition, player.horizonPosition).count
			if playerCountSamePosition >= maxPlayer {
				self.alert(title: "Illegal Lineup", message: "Position \(player.position) only allow \(maxPlayer) player(s). Please move somebody to sub first.")
				return
			}
			
			//move player to lineup
			try! realm.write {
				player.inLineUp = true
			}
		}
		
		//reload data
		setLineUpAndSub()
		tableView.reloadData()
	}
}
