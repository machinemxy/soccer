//
//  NameGeneratorTests.swift
//  SoccerTests
//
//  Created by 马学渊 on 2018/06/22.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import XCTest
@testable import Soccer

class NameGeneratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
		let names: [String] = JsonHelper.parse(jsonFileName: "names")
		NameGenerator.names = names
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPickName() {
		let name = NameGenerator.pickName()
		print(name)
		XCTAssertFalse(name == "")
    }
}
