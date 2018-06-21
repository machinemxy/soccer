//
//  NameGenerator.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/21.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import Foundation

class NameGenerator {
	static var names: [String]!
	
	static func pickName() -> String {
		let index = Int(randomBelow: names.count)
		return names[index]
	}
}
