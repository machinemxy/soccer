//
//  PlayerGenerator.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/22.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit

class PlayerGenerator: NSObject {
	static func generatePlayer(grade: Int, horizonPosition: String, verticalPosition: String, inLineUp: Bool) -> Player {
		let player = Player()
		player.name = NameGenerator.pickName()
		player.grade = grade
		player.horizonPosition = horizonPosition
		player.verticalPosition = verticalPosition
		player.inLineUp = inLineUp
		
		//set ability
		let rating = 40 + player.grade * 20 + Int(randomBelow: 20)
		let abilities = generateAbilities(rating: rating)
		if verticalPosition == "GK" {
			let shuffledAbilities = abilities.shuffled()
			player.ldf = shuffledAbilities[0]
			player.cdf = shuffledAbilities[1]
			player.rdf = shuffledAbilities[2]
		}else if verticalPosition == "F" {
			let sortedAbilities = abilities.sorted()
			player.def = sortedAbilities[0]
			player.org = sortedAbilities[1]
			player.off = sortedAbilities[2]
		}else if verticalPosition == "B" {
			let sortedAbilities = abilities.sorted()
			player.off = sortedAbilities[0]
			player.org = sortedAbilities[1]
			player.def = sortedAbilities[2]
		}else {
			//midfield
			let sortedAbilities = abilities.sorted()
			player.org = sortedAbilities[2]
			let dice = Int(randomBelow: 2)
			if dice == 0 {
				//defensive midfield
				player.off = sortedAbilities[0]
				player.def = sortedAbilities[1]
			}else {
				//offensive midfield
				player.def = sortedAbilities[0]
				player.off = sortedAbilities[1]
			}
		}
		
		//set potential
		player.potential = Int(randomBelow: grade * 10)
		
		return player
	}
	
	private static func generateAbilities(rating: Int) -> [Int] {
		var restAbility = rating
		var abilities = [Int]()
		for _ in 1...2 {
			let randAbility = Int(randomBelow: restAbility)
			abilities.append(randAbility)
			restAbility -= randAbility
		}
		abilities.append(restAbility)
		
		return abilities
	}
}
