//
//  TrainingItem.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/30.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class TrainingItem: Object {
	@objc dynamic var abilityId = 0
	@objc dynamic var trainingPoint = 1
	
	var trainingPointMark: UIImage {
		switch trainingPoint {
		case 1:
			return #imageLiteral(resourceName: "star-1")
		case 2:
			return #imageLiteral(resourceName: "star-2")
		case 3:
			return #imageLiteral(resourceName: "star-3")
		case 4:
			return #imageLiteral(resourceName: "star-4")
		default:
			return #imageLiteral(resourceName: "star-5")
		}
	}
	
	var title: String {
		let preTitle: String
		switch abilityId {
		case 0:
			preTitle = "OFF+"
		case 1:
			preTitle = "ORG+"
		case 2:
			preTitle = "DEF+"
		case 3:
			preTitle = "LDF+"
		case 4:
			preTitle = "CDF+"
		default:
			preTitle = "RDF+"
		}
		return preTitle + "\(trainingPoint)"
	}
}
