//
//  InjuryReport.swift
//  Soccer
//
//  Created by Ma Xueyuan on 2020/01/21.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class InjuryReport: Object {
    @objc dynamic var reportType = 0
    @objc dynamic var message = ""
    
    var title: String {
        if reportType == 0 {
            return NSLocalizedString("Injury Report", comment: "")
        } else {
            return NSLocalizedString("Recovery Report", comment: "")
        }
    }
    
    static func createInjuryReport(reportType: Int, player: Player) -> InjuryReport {
        let injuryReport = InjuryReport()
        injuryReport.reportType = reportType
        
        if reportType == 0 {
            injuryReport.message = "[\(player.position)]\(player.name)" + (NSString(format: NSLocalizedString("Injury message", comment: "") as NSString, player.injuryTime) as String)
        } else {
            injuryReport.message = "[\(player.position)]\(player.name)" + NSLocalizedString("Recovery message", comment: "")
        }
        
        return injuryReport
    }
}
