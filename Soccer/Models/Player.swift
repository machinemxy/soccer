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
	
	var gradeMark: String {
		var gradeMark = ""
		for _ in 1...grade {
			gradeMark += "⭐️"
		}
		return gradeMark
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
			return "None"
		} else if potential < 10 {
			return "Very Low"
		} else if potential < 20 {
			return "Low"
		} else if potential < 30 {
			return "Medium"
		} else if potential < 40 {
			return "High"
		} else {
			return "Very High"
		}
	}
}
