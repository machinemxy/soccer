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
	@objc dynamic var scout = 1
    let maxLeagueLv = 13
	
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
	
	var pointsToPromote: Int {
		return 18
	}
    
    var leagueLvDescription: String {
        switch leagueLv {
        case 1:
            return NSLocalizedString("Amateur", comment: "") + " 1"
        case 2:
            return NSLocalizedString("Amateur", comment: "") + " 2"
        case 3:
            return NSLocalizedString("Amateur", comment: "") + " 3"
        case 4:
            return NSLocalizedString("Amateur", comment: "") + " 4"
        case 5:
            return NSLocalizedString("Semipro", comment: "") + " 1"
        case 6:
            return NSLocalizedString("Semipro", comment: "") + " 2"
        case 7:
            return NSLocalizedString("Semipro", comment: "") + " 3"
        case 8:
            return NSLocalizedString("Semipro", comment: "") + " 4"
        case 9:
            return NSLocalizedString("Professional", comment: "") + " 1"
        case 10:
            return NSLocalizedString("Professional", comment: "") + " 2"
        case 11:
            return NSLocalizedString("Professional", comment: "") + " 3"
        case 12:
            return NSLocalizedString("Professional", comment: "") + " 4"
        default:
            return NSLocalizedString("World Class", comment: "")
        }
    }
}
