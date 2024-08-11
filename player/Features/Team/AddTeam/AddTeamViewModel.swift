//
//  AddTeamViewModel.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import Combine
import database

class AddTeamViewModel: ObservableObject {
    @Published var newTeamName: String = ""

    private var databaseManager = DatabaseManager.shared
    private var cancellables = Set<AnyCancellable>()

    func addTeam() {
        guard !newTeamName.isEmpty else { return }
        
        do {
            _ = try databaseManager.addTeam(name: newTeamName)
            newTeamName = ""
        } catch {
            print("Add team failed: \(error)")
        }
    }
}
