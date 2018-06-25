//
//  PlayerGeneratorTests.swift
//  SoccerTests
//
//  Created by 马学渊 on 2018/06/24.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import XCTest
@testable import Soccer

class PlayerGeneratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGK() {
        let player = PlayerGenerator.generatePlayer(grade: 1, horizonPosition: "", verticalPosition: "GK", inLineUp: true)
		printPlayer(player: player)
    }
	
	func testLB() {
		let player = PlayerGenerator.generatePlayer(grade: 2, horizonPosition: "L", verticalPosition: "B", inLineUp: false)
		printPlayer(player: player)
	}
	
	func testCM() {
		let player = PlayerGenerator.generatePlayer(grade: 3, horizonPosition: "C", verticalPosition: "M", inLineUp: true)
		printPlayer(player: player)
	}
	
	func testRF() {
		let player = PlayerGenerator.generatePlayer(grade: 4, horizonPosition: "R", verticalPosition: "F", inLineUp: false)
		printPlayer(player: player)
	}
	
	func testScout() {
		let player = PlayerGenerator.scout(leagueLevel: 2)
		printPlayer(player: player)
	}
	
	func testGenerateTeam() {
		let players = PlayerGenerator.generateTeam(leagueLevel: 4)
		for player in players {
			print("\(player.name) grade:\(player.grade) position:\(player.position) rating:\(player.rating)")
		}
	}
	
	private func printPlayer(player: Player) {
		print(player.name)
		print("grade:\(player.grade)")
		print(player.horizonPosition)
		print(player.verticalPosition)
		print("inLineUp:\(player.inLineUp)")
		print("off:\(player.off)")
		print("org:\(player.org)")
		print("def:\(player.def)")
		print("ldf:\(player.ldf)")
		print("cdf:\(player.cdf)")
		print("rdf:\(player.rdf)")
		print("potential:\(player.potential)")
	}
}
