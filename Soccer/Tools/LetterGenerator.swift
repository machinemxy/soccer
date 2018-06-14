//
//  LetterGenerator.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/14.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import Foundation

class LetterGenerator {
	static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	
	static func pickLetter() -> String {
		let index = Int(randomBelow: letters.count)
		let from = letters.index(letters.startIndex, offsetBy: index)
		let to = from
		return String(letters[from...to])
	}
}
