//
//  TeamPreviewViewController.swift
//  Soccer
//
//  Created by Ma Xueyuan on 2020/01/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class TeamPreviewViewController: UIViewController {
    @IBOutlet var teamPreviewView: TeamPreviewView!
    @IBOutlet var lblTeam: UILabel!
    var teamName: String!
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        if let gameData = realm.objects(GameData.self).first {
            teamName = gameData.teamName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let realm = try! Realm()
        let players = Player.getLineup(realm: realm)
        team = Team(teamName: teamName, players: players)
        lblTeam.text = team?.teamDisp
        
        teamPreviewView.team = team
        teamPreviewView.reverted = false
        teamPreviewView.setPreview()
    }
}
