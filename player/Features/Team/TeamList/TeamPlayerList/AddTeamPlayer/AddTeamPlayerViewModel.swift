//
//  AddTeamPlayerViewModel.swift
//  player
//
//  Created by minoh.park on 8/11/24.
//

import Combine
import database
import SwiftUI

class AddTeamPlayerViewModel: ObservableObject {
    
    // 선택 가능한 선수 모델
    struct SelectablePlayer: Identifiable {
        let player: Player
        var isSelected: Bool

        var id: UUID { player.id }
        var name: String { player.name }
        var backNumber: Int { player.backNumber }
    }
    
    @Published var players: [SelectablePlayer] = []  // 체크 가능한 선수 목록
    @Published var selectedTeam: Team  // 현재 선택된 팀

    private var databaseManager = DatabaseManager.shared

    init(team: Team) {
        self.selectedTeam = team
        fetchPlayers()
    }

    // 모든 선수 목록을 가져와서 현재 팀에 속한 선수는 체크 표시
    func fetchPlayers() {
        do {
            let allPlayers = try databaseManager.fetchAllPlayers().map { Player(dto: $0) }
            let teamPlayers = try databaseManager.fetchPlayers(forTeam: selectedTeam.toDBModel)
            let teamPlayerIds = Set(teamPlayers.map { $0.id })
            
            players = allPlayers.map { player in
                SelectablePlayer(player: player, isSelected: teamPlayerIds.contains(player.id))
            }
        } catch {
            print("Failed to fetch players: \(error)")
        }
    }

    // 선수 추가/제거 기능
    func toggleSelection(for player: SelectablePlayer) {
        guard let index = players.firstIndex(where: { $0.id == player.id }) else { return }
        players[index].isSelected.toggle()
    }

    // 변경 사항을 데이터베이스에 저장
    func saveChanges() -> Bool {
        do {
            // 선택된 선수를 팀에 추가
            let selectedPlayers = players.filter { $0.isSelected }
            let teamPlayerIds = Set(try databaseManager.fetchPlayers(forTeam: selectedTeam.toDBModel).map { $0.id })

            // 추가되지 않은 선수만 추가
            for player in selectedPlayers where !teamPlayerIds.contains(player.id) {
                try databaseManager.addPlayer(player.id, toTeam: selectedTeam.toDBModel)
            }
            
            // 팀에서 제거된 선수 처리 (선택 해제된 선수 중 현재 팀에 소속된 선수)
            for player in players.filter({ !$0.isSelected }) where teamPlayerIds.contains(player.id) {
                try databaseManager.removePlayer(player.id, fromTeam: selectedTeam.id)
            }
            
            return true
            
        } catch {
            print("Failed to save player changes: \(error)")
            return false
        }
    }
}
