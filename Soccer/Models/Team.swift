//
//  Team.swift
//  Soccer
//
//  Created by Ma Xueyuan on 2020/01/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import Foundation

struct Team {
    var teamName: String
    var players: [Player]
    var abilities: [Ability]
    var overall: Int
    
    init(teamName: String, players: [Player]) {
        self.teamName = teamName
        self.players = players
        
        abilities = [Ability(), Ability(), Ability()]
        for player in players {
            if player.verticalPosition == "GK" {
                abilities[0].def += player.ldf
                abilities[1].def += player.cdf
                abilities[2].def += player.rdf
            } else {
                let sideIndex: Int
                switch player.horizonPosition {
                case "L":
                    sideIndex = 0
                case "C":
                    sideIndex = 1
                default:
                    sideIndex = 2
                }
                abilities[sideIndex].def += player.def
                abilities[sideIndex].org += player.org
                abilities[sideIndex].off += player.off
            }
        }
        
        overall = 0
        for ability in abilities {
            overall += ability.off
            overall += ability.org
            overall += ability.def
        }
    }
    
    var teamDisp: String {
        return "\(teamName)(\(overall))"
    }
    
    func getPlayerWhoGoaled(side: Int) -> Player? {
        var restOffPower = Int(randomBelow: abilities[side].off)
        let sidePlayers = getPlayersBySide(side: side)
        for player in sidePlayers {
            if restOffPower < player.off {
                return player
            } else {
                restOffPower -= player.off
            }
        }
        
        return nil
    }
    
    private func getPlayersBySide(side: Int) -> [Player] {
        switch side {
        case 0:
            return players.filter { (p) -> Bool in
                p.horizonPosition == "L"
            }
        case 1:
            return players.filter { (p) -> Bool in
                p.horizonPosition == "C"
            }
        default:
            return players.filter { (p) -> Bool in
                p.horizonPosition == "R"
            }
        }
    }
}
