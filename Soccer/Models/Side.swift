//
//  Side.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/12.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import Foundation

class Side {
	var teamName: String
	var abilities: [Ability]!
	var score: Int = 0
	var log: String = ""
	var direction: Int!
	
	var currentAbility: Ability {
		return abilities[direction]
	}
	
	var overall: Int {
		var overall = 0
		for ability in abilities {
			overall += ability.off
			overall += ability.org
			overall += ability.def
		}
		return overall
	}
	
	init(teamName: String, players: [Player]) {
		self.teamName = teamName
		abilities = [Ability(), Ability(), Ability()]
		for player in players {
			if player.verticalPosition == "GK" {
				abilities[0].def += player.ldf
				abilities[1].def += player.cdf
				abilities[2].def += player.rdf
			} else {
				let sideIndex: Int
				switch player.horizonPosition {
				case "L":
					sideIndex = 0
				case "C":
					sideIndex = 1
				default:
					sideIndex = 2
				}
				abilities[sideIndex].def += player.def
				abilities[sideIndex].org += player.org
				abilities[sideIndex].off += player.off
			}
		}
	}
}
