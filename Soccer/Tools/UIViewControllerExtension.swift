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
        //make it green
        alertController.view.tintColor = .systemGreen
		self.present(alertController, animated: true, completion: nil)
	}
    
    func presentWithFullScreen<T: UIViewController>(storyboardId: String, handler: @escaping (T)->()?){
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(identifier: storyboardId) as! T
            handler(vc)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true)
        }
    }
}
