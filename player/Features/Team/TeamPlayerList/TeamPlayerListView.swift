//
//  TeamPlayerListView.swift
//  player
//
//  Created by minoh.park on 8/10/24.
//

import SwiftUI

struct TeamPlayerListView: View {
    @StateObject private var viewModel: TeamPlayerListViewModel

    init(team: Team) {
        _viewModel = StateObject(wrappedValue: TeamPlayerListViewModel(team: team))
    }

    var body: some View {
        List(viewModel.players) { player in
            VStack(alignment: .leading) {
                Text(player.name)
                    .font(.headline)
                Text("BackNumber: \(player.backNumber)")
                    .font(.subheadline)
            }
        }
        .navigationTitle(viewModel.team.name)
        .onAppear {
            viewModel.fetchPlayers()
            print("Players loaded: \(viewModel.players)")
        }
    }
}
