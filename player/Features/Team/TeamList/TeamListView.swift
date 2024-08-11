//
//  TeamListView.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import SwiftUI

struct TeamListView: View {
    @StateObject private var viewModel = TeamListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.teams) { team in
                NavigationLink(destination: TeamPlayerListView(team: team)) {
                    Text(team.name)
                        .font(.headline)
                }
            }
            .navigationTitle("Teams")
            .navigationBarItems(trailing: NavigationLink("Add", destination: AddTeamView(addTeamViewModel: viewModel.addTeamViewModel)))
            .onAppear {
                viewModel.fetchTeams()
                print("Teams loaded: \(viewModel.teams)")
            }
        }
    }
}
