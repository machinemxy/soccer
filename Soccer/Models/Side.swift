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
	var abilities: [Ability]
	var score: Int = 0
	var log: String = ""
	var direction: Int!
	
	var currentAbility: Ability {
		return abilities[direction]
	}
	
	init(teamName: String, abilities: [Ability]) {
		self.teamName = teamName
		self.abilities = abilities
	}
}
