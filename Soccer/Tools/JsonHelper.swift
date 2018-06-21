//
//  JsonHelper.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/21.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import Foundation

class JsonHelper {
	static func parse<T: Codable>(jsonFileName: String) -> T {
		let jsonDecoder = JSONDecoder()
		let tornamentsFile = Bundle.main.path(forResource: jsonFileName, ofType: "json")
		let data = try! Data(contentsOf: URL(fileURLWithPath: tornamentsFile!))
		return try! jsonDecoder.decode(T.self, from: data)
	}
}
