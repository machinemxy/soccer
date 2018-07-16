//
//  ExtraViewController.swift
//  Soccer
//
//  Created by Ma Xueyuan on 2018/07/16.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class ExtraViewController: UIViewController {
    @IBOutlet weak var btnGetPremiumManager: UIButton!
    @IBOutlet weak var btnRestorePurchase: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //if user already bought the premium manager, disable the buttom
        if UserDefaults.standard.bool(forKey: "PremiumManager") {
            btnGetPremiumManager.isEnabled = false
            btnRestorePurchase.isEnabled = false
        }
        
        //display the price
        setPrice()
    }
    
    @IBAction func getPremiumManager(_ sender: Any) {
        SwiftyStoreKit.purchaseProduct("PremiumManager", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                UserDefaults.standard.set(true, forKey: "PremiumManager")
                self.btnGetPremiumManager.isEnabled = false
                self.btnRestorePurchase.isEnabled = false
                print("Purchase Success: \(purchase.productId)")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                }
            }
        }
    }
    
    @IBAction func restorePurchase(_ sender: Any) {
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    UserDefaults.standard.set(true, forKey: "PremiumManager")
                    self.btnGetPremiumManager.isEnabled = false
                    self.btnRestorePurchase.isEnabled = false
                    
                    // fetch content from your server, then:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                print("Restore Success: \(results.restoredPurchases)")
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    @IBAction func readTutorial(_ sender: Any) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func setPrice() {
        SwiftyStoreKit.retrieveProductsInfo(["PremiumManager"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                self.btnGetPremiumManager.setTitle("Get Premium Manager by \(priceString)", for: .normal)
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error")
            }
        }
    }
}
