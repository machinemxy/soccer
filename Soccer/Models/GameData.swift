//
//  GameData.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/14.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class GameData: Object {
	@objc dynamic var leagueLv = 1
	@objc dynamic var teamName = ""
	@objc dynamic var week = 1
	@objc dynamic var win = 0
	@objc dynamic var draw = 0
	@objc dynamic var lose = 0
	//debug use
	@objc dynamic var scout = 30
	
	var points: Int {
		return win * 3 + draw
	}
	
	var pointsToStay: Int {
		if leagueLv == 1 {
			return 0
		} else {
			return 9
		}
	}
	
	var pointsToUpgrade: Int {
		return 18
	}
}
