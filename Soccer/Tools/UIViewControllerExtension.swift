//
//  UIViewControllerExtension.swift
//  Soccer
//
//  Created by 马学渊 on 2018/07/13.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit

extension UIViewController {
	func alert(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(alertAction)
		self.present(alertController, animated: true, completion: nil)
	}
}
