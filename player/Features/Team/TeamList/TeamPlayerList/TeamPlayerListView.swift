//
//  TeamPlayerListView.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import SwiftUI

struct TeamPlayerListView: View {
    @StateObject private var viewModel: TeamPlayerListViewModel
    @State private var showingAddPlayerView = false

    init(team: Team) {
        _viewModel = StateObject(wrappedValue: TeamPlayerListViewModel(team: team))
    }

    var body: some View {
        List {
            ForEach(viewModel.players) { player in
                VStack(alignment: .leading) {
                    Text(player.name)
                        .font(.headline)
                    Text("BackNumber: \(player.backNumber)")
                        .font(.subheadline)
                }
            }
            .onDelete { offsets in
                viewModel.removePlayer(at: offsets)
            }
        }
        .navigationTitle(viewModel.team.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showingAddPlayerView = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddPlayerView, onDismiss: {
            viewModel.fetchPlayers()
        }) {
            AddTeamPlayerView(team: viewModel.team)
        }
        .onAppear {
            viewModel.fetchPlayers()
            print("Players loaded: \(viewModel.players)")
        }
    }
}
