//
//  IntExtensionTests.swift
//  SoccerTests
//
//  Created by 马学渊 on 2018/06/14.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import XCTest
@testable import Soccer

class IntExtensionTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testBelowZero() {
		let a = Int(randomBelow: -1)
		XCTAssertEqual(a, 0)
	}
	
	func testZero() {
		let a = Int(randomBelow: 0)
		XCTAssertEqual(a, 0)
	}
	
	func testOne() {
		let a = Int(randomBelow: 1)
		XCTAssertEqual(a, 0)
	}
	
	func testALargeNumber() {
		let a = Int(randomBelow: 10000)
		print(a)
	}
}
