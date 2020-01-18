//
//  ItemTableViewController.swift
//  Soccer
//
//  Created by 马学渊 on 2018/07/01.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class ItemTableViewController: UITableViewController {
	var player: Player!
	var items: [TrainingItem]!

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
		items = realm.objects(TrainingItem.self).sorted(by: { (item1, item2) -> Bool in
			//order by trainingPoint, abilityType
			if item1.trainingPoint == item2.trainingPoint {
				return item1.abilityType < item2.abilityType
			} else {
				return item1.trainingPoint > item2.trainingPoint
			}
		})
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)

		let item = items[indexPath.row]
		cell.imageView?.image = item.trainingPointMark
		cell.textLabel?.text = item.title

        return cell
    }
	
	// MARK: - Table view delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = items[indexPath.row]
		
		//perform training
		let realm = try! Realm()
		try! realm.write {
			//add ability
			switch item.abilityType {
			case 0:
				player.def += item.trainingPoint
			case 1:
				player.org += item.trainingPoint
			case 2:
				player.off += item.trainingPoint
			case 3:
				player.ldf += item.trainingPoint
			case 4:
				player.cdf += item.trainingPoint
			default:
				player.rdf += item.trainingPoint
			}
			
			//reduce potential
			if item.trainingPoint > player.potential {
				player.potential = 0
			} else {
				player.potential -= item.trainingPoint
			}
			
			//delete training item
			realm.delete(item)
		}
		
		performSegue(withIdentifier: "unwindToTeamFromItem", sender: nil)
	}
}
