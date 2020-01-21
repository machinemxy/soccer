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
            return "Injury Report"
        } else {
            return "Recovery Report"
        }
    }
    
    static func createInjuryReport(reportType: Int, player: Player) -> InjuryReport {
        let injuryReport = InjuryReport()
        injuryReport.reportType = reportType
        
        if reportType == 0 {
            injuryReport.message = "[\(player.position)]\(player.name) was injured in the game. He need \(player.injuryTime) weeks to recover."
        } else {
            injuryReport.message = "[\(player.position)]\(player.name) has been recovered from injury."
        }
        
        return injuryReport
    }
}
