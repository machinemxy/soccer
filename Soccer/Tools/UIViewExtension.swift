//
//  UIViewExtension.swift
//  Soccer
//
//  Created by @ktaguchi 2016年07月21日に更新
//  https://qiita.com/ktaguchi/items/c95821b6b1c53a79c5c2
//

import UIKit

extension UIView {
	
	// 枠線の色
	@IBInspectable var borderColor: UIColor? {
		get {
			return layer.borderColor.map { UIColor(cgColor: $0) }
		}
		set {
			layer.borderColor = newValue?.cgColor
		}
	}
	
	// 枠線のWidth
	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
}
