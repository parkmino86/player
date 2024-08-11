//
//  TeamListViewModel.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import Combine
import database

class TeamListViewModel: ObservableObject {
    @Published var teams: [Team] = []

    private var databaseManager = DatabaseManager.shared
    private var cancellables = Set<AnyCancellable>()

    let addTeamViewModel = AddTeamViewModel()

    init() {
        fetchTeams()
        setupBindings()
    }

    func fetchTeams() {
        do {
            teams = try databaseManager.fetchTeams().map { Team(dto: $0) }
        } catch {
            print("Fetch teams failed: \(error)")
        }
    }

    func refreshTeams() {
        fetchTeams()
    }

    private func setupBindings() {
        // 팀이 추가된 후 자동으로 목록을 갱신
        addTeamViewModel.$newTeamName
            .sink { [weak self] _ in
                self?.fetchTeams()
            }
            .store(in: &cancellables)
    }
}
