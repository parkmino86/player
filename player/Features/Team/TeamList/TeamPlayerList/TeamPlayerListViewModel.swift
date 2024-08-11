//
//  TeamPlayerListViewModel.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import Combine
import database
import Foundation

class TeamPlayerListViewModel: ObservableObject {
    @Published var players: [Player] = []
    private(set) var team: Team  // 외부에서 읽기만 가능하게 설정
    private var databaseManager = DatabaseManager.shared

    init(team: Team) {
        self.team = team
        fetchPlayers()
    }

    // 해당 팀의 선수 목록을 가져오는 메서드
    func fetchPlayers() {
        do {
            players = try databaseManager.fetchPlayers(forTeam: team.toDBModel).map { Player(dto: $0) }
            print("Players loaded: \(players)")
        } catch {
            print("Fetch players for team \(team.name) failed: \(error)")
        }
    }
    
    // 팀에서 선수를 제거하는 메서드
    func removePlayer(at offsets: IndexSet) {
        offsets.forEach { index in
            let player = players[index]
            
            do {
                // DatabaseManager를 사용하여 팀에서 선수 제거
                try databaseManager.removePlayer(player.id, fromTeam: team.id)
                print("Player \(player.name) removed from team \(team.name) successfully.")
                fetchPlayers() // 삭제 후 플레이어 목록을 갱신
            } catch {
                print("Failed to remove player \(player.name) from team \(team.name): \(error)")
            }
        }
    }

}
