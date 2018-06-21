//
//  Player.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/19.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Player: Object {
	@objc dynamic var name = ""
	@objc dynamic var grade = 0
	@objc dynamic var horizonPosition = 0
	@objc dynamic var verticalPosition = 0
	@objc dynamic var inLineUp = false
	@objc dynamic var off = 0
	@objc dynamic var org = 0
	@objc dynamic var def = 0
	@objc dynamic var ldf = 0
	@objc dynamic var cdf = 0
	@objc dynamic var rdf = 0
	@objc dynamic var potential = 0
	
	var position: String {
		if verticalPosition == 0 {
			return "GK"
		}
		var tempPosition: String
		switch horizonPosition {
		case 0:
			tempPosition = "L"
		case 1:
			tempPosition = "C"
		default:
			tempPosition = "R"
		}
		switch verticalPosition {
		case 1:
			tempPosition += "B"
		case 2:
			tempPosition += "M"
		default:
			tempPosition += "F"
		}
		return tempPosition
	}
}
