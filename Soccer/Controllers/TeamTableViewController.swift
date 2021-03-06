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
        return 2
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return NSLocalizedString("Lineup", comment: "") + "(\(lineUp.count)/11)"
		} else {
			return NSLocalizedString("Sub", comment: "")
		}
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell.textLabel?.text = player.brief
        cell.detailTextLabel?.text = player.detail
		
        return cell
    }

	// MARK: - Table view delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//get player
		let player = getPlayer(indexPath: indexPath)
		
        let moveTitle = player.inLineUp ? NSLocalizedString("Move to Sub", comment: "") : NSLocalizedString("Move to Lineup", comment: "")
		//show action sheet
        let actionSheet = UIAlertController(title: NSLocalizedString("Action", comment: ""), message: "", preferredStyle: .actionSheet)
		let moveAction = UIAlertAction(title: moveTitle, style: .default) { (_) in
			self.movePlayer(player: player, indexPath: indexPath)
		}
        let trainAction = UIAlertAction(title: NSLocalizedString("Training", comment: ""), style: .default) { (_) in
			self.train(player: player, indexPath: indexPath)
		}
        let sacrificeAction = UIAlertAction(title: NSLocalizedString("Sacrifice", comment: ""), style: .destructive) { (_) in
			self.sacrifice(player: player)
		}
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (_) in
			self.tableView.deselectRow(at: indexPath, animated: true)
		}
		actionSheet.addAction(moveAction)
		actionSheet.addAction(trainAction)
		actionSheet.addAction(sacrificeAction)
		actionSheet.addAction(cancelAction)
		
		//iPad crash avoid
		actionSheet.popoverPresentationController?.sourceView = view
		actionSheet.popoverPresentationController?.sourceRect = tableView.cellForRow(at: indexPath)!.frame
        
        //make it green
        actionSheet.view.tintColor = .systemGreen
		self.present(actionSheet, animated: true, completion: nil)
	}

    // MARK: - Navigation
	@IBAction func unwindToTeam(segue: UIStoryboardSegue) {
		if segue.identifier == "unwindToTeamFromItem" {
			tableView.reloadData()
		}
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toItemFromTeam" {
			let target = segue.destination as! ItemTableViewController
            target.player = (sender as! Player)
		}
    }
	
	//private
	private func setLineUpAndSub() {
		let realm = try! Realm()
        lineUp = Player.getLineup(realm: realm)
        sub = Player.getSub(realm: realm)
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
	
	private func movePlayer(player: Player, indexPath: IndexPath) {
		let realm = try! Realm()
		
		if player.inLineUp {
			//move player to sub
			try! realm.write {
				player.inLineUp = false
			}
		} else {
			//judge if the lineup already has 11 players
			if lineUp.count >= 11 {
                alert(title: NSLocalizedString("Illegal Lineup", comment: ""), message: NSLocalizedString("Over 11", comment: ""))
				tableView.deselectRow(at: indexPath, animated: true)
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
                self.alert(title: NSLocalizedString("Illegal Lineup", comment: ""), message: NSString(format: NSLocalizedString("Duplicated position", comment: "") as NSString, player.position, maxPlayer) as String)
				tableView.deselectRow(at: indexPath, animated: true)
				return
			}
            
            //the play is injured
            if player.injuryTime > 0 {
                self.alert(title: NSLocalizedString("Illegal Lineup", comment: ""), message: player.name + NSLocalizedString("Injured", comment: ""))
                tableView.deselectRow(at: indexPath, animated: true)
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
	
	private func train(player: Player, indexPath: IndexPath) {
		//player who has no potential cannot be trained
		if player.potential <= 0 {
            alert(title: NSLocalizedString("Training Failed", comment: ""), message: player.name + NSLocalizedString("Cannot Trainning", comment: ""))
			tableView.deselectRow(at: indexPath, animated: true)
			return
		}
		
		//perform segue to ItemTableView
		performSegue(withIdentifier: "toItemFromTeam", sender: player)
	}
	
	private func sacrifice(player: Player) {
		//init the training item
		let item = TrainingItem()
		item.trainingPoint = player.grade
		
		//decide ability type
		let randNumber = Int(randomBelow: player.rating)
		if player.verticalPosition == "GK" {
			if randNumber < player.ldf {
				item.abilityType = 3
			} else if randNumber < player.ldf + player.cdf {
				item.abilityType = 4
			} else {
				item.abilityType = 5
			}
		} else {
			if randNumber < player.def {
				item.abilityType = 0
			} else if randNumber < player.def + player.org {
				item.abilityType = 1
			} else {
				item.abilityType = 2
			}
		}
		
        alert(title: NSLocalizedString("Sacrifice Done", comment: ""), message: NSString(format: NSLocalizedString("Sacrifice Message", comment: "") as NSString, player.name, item.title) as String)
		
		//sacrifice player and get training item
		let realm = try! Realm()
		try! realm.write {
			realm.add(item)
			realm.delete(player)
		}
		
		//reload data
		setLineUpAndSub()
		tableView.reloadData()
	}
}
