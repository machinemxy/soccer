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
	
	static func generateTeam(leagueLv: Int) -> [Player] {
		var players = [Player]()
		//gk
		let gk = generatePlayer(grade: randGrade(leagueLv: leagueLv), horizonPosition: "", verticalPosition: "GK", inLineUp: true)
		players.append(gk)
		
		//player in each other positions
		let horizionPositions = ["L", "C", "R"]
		let verticalPositions = ["B", "M", "F"]
		for i in 0...2 {
			for j in 0...2 {
				let grade = randGrade(leagueLv: leagueLv)
				let player = generatePlayer(grade: grade, horizonPosition: horizionPositions[i], verticalPosition: verticalPositions[j], inLineUp: true)
				players.append(player)
			}
		}
		
		//additional player
		let additionalPlayer = generatePlayer(grade: randGrade(leagueLv: leagueLv), horizonPosition: "C", verticalPosition: verticalPositions[Int(randomBelow: 3)], inLineUp: true)
		players.append(additionalPlayer)
		
		return players
	}
	
	static func scout(leagueLv: Int) -> Player {
		//player cannot get player whose grade is over 5
		var grade = randGrade(leagueLv: leagueLv)
		if grade > 5 {
			grade = 5
		}
		
		let dice = Int(randomBelow: 11)
		if dice == 0 {
			//gk
			return generatePlayer(grade: grade, horizonPosition: "", verticalPosition: "GK", inLineUp: false)
		}
		
		//position except gk
		let horizionPositions = ["L", "C", "R"]
		let verticalPositions = ["B", "M", "F"]
		let horizonPosition = horizionPositions[Int(randomBelow: 3)]
		let verticalPosition = verticalPositions[Int(randomBelow: 3)]
		return generatePlayer(grade: grade, horizonPosition: horizonPosition, verticalPosition: verticalPosition, inLineUp: false)
	}
	
	private static func generateAbilities(rating: Int) -> [Int] {
		var restAbility = rating
		var abilities = [Int]()
		for _ in 1...2 {
			let randAbility = Int(randomBelow: restAbility * 4 / 5 + 1)
			abilities.append(randAbility)
			restAbility -= randAbility
		}
		abilities.append(restAbility)
		
		return abilities
	}
	
	//legueLevel 1: 90% grade 1, 10% grade 2
	//legueLevel 2: 40% grade 1, 60% grade 2
	//legueLevel 3: 90% grade 2, 10% grade 3
	//legueLevel 4: 40% grade 2, 60% grade 3
	private static func randGrade(leagueLv: Int) -> Int {
		let minGrade = (leagueLv + 1) / 2
		let percentageWall: Int
		if leagueLv % 2 == 1 {
			percentageWall = 9
		} else {
			percentageWall = 4
		}
		let percentage = Int(randomBelow: 10)
		if percentage < percentageWall {
			return minGrade
		} else {
			return minGrade + 1
		}
	}
}
