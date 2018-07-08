//
//  UIViewExtension.swift
//  Soccer
//
//  Created by 马学渊 on 2018/07/07.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit

extension UIView {
	@IBInspectable var borderColor: UIColor? {
		get {
			return layer.borderColor.map { UIColor(cgColor: $0) }
		}
		set {
			layer.borderColor = newValue?.cgColor
		}
	}
	
	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
}
