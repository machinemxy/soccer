//
//  IntExtension.swift
//  Soccer
//
//  Created by 马学渊 on 2018/06/13.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import Foundation

extension Int {
	public init(randomBelow upperLimit: Int) {
		if upperLimit <= 0 {
			self.init(0)
		}
		self.init(arc4random_uniform(UInt32(upperLimit)))
	}
}
