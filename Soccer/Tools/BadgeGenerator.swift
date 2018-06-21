//
//  BadgeGenerator.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/14.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import Foundation

class BadgeGenerator {
	static let badges =
	[
		"😈","👹","🤡","💩","👻","☠️","👽","👾","🤖","🎃",
		"👁","🧠","👒","👑","🐶","🐱","🐭","🐹","🐰","🦊",
		"🐻","🐼","🐨","🐯","🦁","🐮","🐷","🐸","🐵","🐔",
		"🐥","🦆","🦅","🦉","🦇","🐺","🐗","🐴","🦄","🐝",
		"🐛","🦋","🐌","🐚","🐞","🕷","🦂","🐢","🐍","🦎",
		"🦖","🐙","🦑","🦐","🦀","⚔️","💊","🐟","🐬","🐳",
		"🐋","🦈","🐊","🐉","🐲","🌵","🎄","🍀","🍄","🌷",
		"🌹","🌻","🌞","🛡","🌛","🌚","🌎","🌟","⚡️","☄️",
		"🔥","🌪","🌈","❄️","🌊","💎","🍖","🌭","🍔","🍟",
		"🍕","🎱","🏹","🎸","🎲","🎯","🎰","🚀","🛸","💣"
	]
	
	static func pickBadge() -> String {
		let index = Int(randomBelow: badges.count)
		return badges[index]
	}
}