//
//  MatchPreviewViewController.swift
//  Soccer
//
//  Created by Ma Xueyuan on 2020/01/20.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class MatchPreviewViewController: UIViewController {
    @IBOutlet var myTeamName: UILabel!
    @IBOutlet var myTeamPreviewView: TeamPreviewView!
    @IBOutlet var enemyTeamName: UILabel!
    @IBOutlet var enemyTeamPreviewView: TeamPreviewView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        
        // set my team
        let gameData = realm.objects(GameData.self).first!
        let teamName = gameData.teamName
        let players = Player.getLineup(realm: realm)
        let team = Team(teamName: teamName, players: players)
        myTeamName.text = team.teamDisp
        myTeamPreviewView.team = team
        myTeamPreviewView.reverted = false
        myTeamPreviewView.setPreview()
        
        // set enemy Team
        let enemyTeamName = TeamNameGenerator.pickTeamName()
        let enemyPlayers = PlayerGenerator.generateTeam(leagueLv: gameData.leagueLv)
        let enemyTeam = Team(teamName: enemyTeamName, players: enemyPlayers)
        self.enemyTeamName.text = enemyTeam.teamDisp
        enemyTeamPreviewView.team = enemyTeam
        enemyTeamPreviewView.reverted = true
        enemyTeamPreviewView.setPreview()
    }
    
    @IBAction func startMatch(_ sender: Any) {
        //week + 1
        let realm = try! Realm()
        let gameData = realm.objects(GameData.self).first!
        try! realm.write {
            gameData.week += 1
        }
        
        // show match view
        presentWithFullScreen(storyboardId: "match") { (matchView: MatchViewController) -> Void in
            let myTeam = self.myTeamPreviewView.team!
            let enemyTeam = self.enemyTeamPreviewView.team!
            matchView.teams = [myTeam, enemyTeam]
        }
    }
    
}
