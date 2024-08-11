//
//  PlayerViewModel.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import Combine
import database
import Foundation

class PlayerViewModel: ObservableObject {
    @Published var players: [Player] = []
    @Published var teams: [Team] = []
    @Published var selectedTeam: Team?

    private var databaseManager = DatabaseManager.shared

    init() {
        fetchTeams()
    }

    func fetchTeams() {
        do {
            teams = try databaseManager.fetchTeams().map { Team(dto: $0) }
        } catch {
            print("Fetch teams failed: \(error)")
        }
    }

    func fetchPlayers() {
        do {
            players = try databaseManager.fetchAllPlayers().map { Player(dto: $0) }
        } catch {
            print("Fetch players failed: \(error)")
        }
    }

    func addPlayer(name: String, backNumber: String) {
        guard let team = selectedTeam, !name.isEmpty, let backNumber = Int(backNumber) else { return }

        do {
            try databaseManager.addPlayer(name: name, backNumber: backNumber, toTeam: team.toDBModel)
            fetchPlayers()
        } catch {
            print("Add player failed: \(error)")
        }
    }

    // 삭제 기능 추가
    func deletePlayer(at offsets: IndexSet) {
        for index in offsets {
            let player = players[index]
            do {
                try databaseManager.deletePlayer(withId: player.id)
                fetchPlayers() // 삭제 후 플레이어 목록을 갱신
            } catch {
                print("Delete player failed: \(error)")
            }
        }
    }
}
