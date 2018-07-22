//
//  BadgeGenerator.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/14.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import Foundation

class TeamNameGenerator {
	static let badges =
	[
		"😈","👹","🤡","💩","👻","☠️","👽","👾","🤖","🎃",
		"👁","🧠","👒","⚰️","🐶","🐱","🐭","🐹","🐰","🦊",
		"🐻","🐼","🐨","🐯","🦁","🐮","🐷","🐸","🐵","🐔",
		"🐥","🦆","🦅","🦉","🦇","🐺","🐗","🐴","🦄","🐝",
		"🐛","🦋","🐌","🐚","🐞","🕷","🦂","🐢","🐍","🦎",
		"🦖","🐙","🦑","🦐","🦀","⚔️","💊","🐟","🐬","🐳",
		"🐋","🦈","🐊","🐉","🐲","🌵","🎄","🍀","🍄","🌷",
		"🌹","🌻","🌞","🛡","🌛","🌚","🌎","🌟","⚡️","☄️",
		"🔥","🌪","🌈","❄️","🌊","💎","🍖","🌭","🍔","🍟",
		"🍕","🎱","🏹","🎸","🎲","🎯","🎰","🚀","🛸","💣"
	]
	
	static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	
	static func pickTeamName() -> String {
		var teamName = pickBadge()
		for _ in 1...3 {
			teamName += pickLetter()
		}
		return teamName
	}
	
    static func getLetter(index: Int) -> String {
        let from = letters.index(letters.startIndex, offsetBy: index)
        let to = from
        return String(letters[from...to])
    }
    
	private static func pickBadge() -> String {
		let index = Int(randomBelow: badges.count)
		return badges[index]
	}
	
	private static func pickLetter() -> String {
		let index = Int(randomBelow: letters.count)
		return getLetter(index: index)
	}
}
