//
//  NextEnemyTeam.swift
//  Soccer
//
//  Created by Ma Xueyuan on 2019/09/14.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class NextEnemyTeam: Object {
    @objc dynamic var teamName = ""
    @objc dynamic var ldef = 0
    @objc dynamic var lorg = 0
    @objc dynamic var loff = 0
    @objc dynamic var cdef = 0
    @objc dynamic var corg = 0
    @objc dynamic var coff = 0
    @objc dynamic var rdef = 0
    @objc dynamic var rorg = 0
    @objc dynamic var roff = 0
}
