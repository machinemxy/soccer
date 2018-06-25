//
//  Player.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/19.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Player: Object {
	@objc dynamic var name = ""
	@objc dynamic var grade = 0
	@objc dynamic var horizonPosition = ""
	@objc dynamic var verticalPosition = ""
	@objc dynamic var inLineUp = false
	@objc dynamic var off = 0
	@objc dynamic var org = 0
	@objc dynamic var def = 0
	@objc dynamic var ldf = 0
	@objc dynamic var cdf = 0
	@objc dynamic var rdf = 0
	@objc dynamic var potential = 0
	
	var gradeMark: UIImage {
		switch grade {
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
	
	var position: String {
		return horizonPosition + verticalPosition
	}
	
	var rating: Int {
		if verticalPosition == "GK" {
			return ldf + cdf + rdf
		} else {
			return off + org + def
		}
	}
	
	var potentialPredict: String {
		if potential <= 0 {
			return "F"
		} else if potential < 10 {
			return "E"
		} else if potential < 20 {
			return "D"
		} else if potential < 30 {
			return "C"
		} else if potential < 40 {
			return "B"
		} else {
			return "A"
		}
	}
}
